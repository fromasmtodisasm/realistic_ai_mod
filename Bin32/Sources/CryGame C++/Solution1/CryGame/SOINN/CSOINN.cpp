/*
 * SOINN Software Version 1.2.0
 * http://haselab.info/
 * реализует алгоритм SOINN
 */

#include "CSOINN.h"
#include <math.h>
#include <windows.h>

#define MY_ERROR(x)   MessageBox(NULL, TEXT(x), TEXT("error"),  MB_TASKMODAL | MB_TOPMOST | MB_SETFOREGROUND | MB_ICONERROR)
#define MY_WARNING(x) MessageBox(NULL, TEXT(x), TEXT("error"),  MB_TASKMODAL | MB_TOPMOST | MB_SETFOREGROUND | MB_WARNING)
#define MY_INFO(x)    MessageBox(NULL, TEXT(x), TEXT("information"), MB_TASKMODAL | MB_TOPMOST | MB_SETFOREGROUND | MB_ICONINFORMATION)
#define MY_YESNO(x)   MessageBox(NULL, TEXT(x), TEXT("warning"), MB_TASKMODAL | MB_TOPMOST | MB_SETFOREGROUND | MB_ICONWARNING | MB_YESNO)

const int    CSOINN::NO_CHANGE    = 0;
const int    CSOINN::UNCLASSIFIED = -1;
const int    CSOINN::NOT_FOUND    = -1;
const double CSOINN::INFINITY     = 1e10;

const std::string CSOINN::VERSION = "1.2.0";

// Arguments: Dimension of input data, training time for removing node, threshold of age for removing edge
CSOINN::CSOINN(const int dimension, const int lambda, const int ageMax)
{
	m_dimension = 0;
	m_lambda    = 0;
	m_ageMax    = 0;
	m_classNum  = 0;
	m_inputNum  = 0;

	// Initialize dimension
	if (dimension > 0)
	{
		m_dimension = dimension;
	}
	// Initialize training time for removing node
	if (lambda > 0)
	{
		m_lambda = lambda;
	}
	// Initialize threshold of age for removing edge
	if (ageMax > 0)
	{
		m_ageMax = ageMax;
	}
}

CSOINN::~CSOINN()
{
	// Free memory and exit
	while (!m_nodeInfo.empty())
	{
		m_nodeInfo.pop_back();
	}
	while (!m_edgeInfo.empty())
	{
		m_edgeInfo.pop_back();
	}
}

// Input data vector
bool CSOINN::InputSignal(const double *signal)
{
	int winner, secondWinner;

	// If the input data is invalid value, returan false and exit
	if (signal == NULL) return false;

	// Count up the number of input data
	m_inputNum++;

	// If number of nodes is less than 2, directly add the input data as new node
	if (m_nodeInfo.size() < 2)
	{
		AddNode(signal);
		return true;
	}

	// Find winner and runnerup
	FindWinnerAndSecondWinner(winner, secondWinner, signal);

	// If the input data belongs to new knowledge, insert it as new node
	if (!IsWithinThreshold(winner, secondWinner, signal))
	{
		AddNode(signal);
	}
	else
	{
		AddEdge(winner, secondWinner);			// generate edge between winner and runnerup
		ResetEdgeAge(winner, secondWinner);		// Reset the age of edge between winner and runnerup
		IncrementEdgeAge(winner);				// Count up the age of edges linked with winner
		UpdateLearningTime(winner);				// Count up the number of times been winner
		MoveNode(winner, signal);				// Update weight of winner and neighbor of winner
		RemoveDeadEdge();						// Remove edges whose age are greater than threshold of age
	}

	// If the learning times are greater than threshold, remove isolated nodes
	if (m_inputNum % m_lambda == 0)
	{
		RemoveUnnecessaryNode();

		// Give class label for all nodes
		Classify();
	}

	return true;
}

// Label nodes with class label
void CSOINN::Classify(void)
{
	int i, nodeNum, classNum;

	nodeNum = (int)m_nodeInfo.size();
	for (i=0; i<nodeNum; i++)
	{
		// At first set all nodes as unlabeled
		m_nodeInfo[i].m_classID = UNCLASSIFIED;
	}

	classNum = 0;
	for (i=0; i<nodeNum; i++)
	{
		if (m_nodeInfo[i].m_classID == UNCLASSIFIED)
		{
			// If there are unlabeled nodes, label them
			// Recurrently call SetClassID(...)
			SetClassID(i, classNum);
			// If nodes are labeled with new class label, count up the number of classes
			classNum++;
		}
	}

	m_classNum = classNum;
}

// Reset SOINN
void CSOINN::Reset(const int dimension/*=NO_CHANGE*/, const int lambda/*=NO_CHANGE*/, const int ageMax/*=NO_CHANGE*/)
{
	while (!m_nodeInfo.empty())
	{
		m_nodeInfo.pop_back();
	}
	while (!m_edgeInfo.empty())
	{
		m_edgeInfo.pop_back();
	}

	m_classNum = 0;
	m_inputNum = 0;

	if (dimension != NO_CHANGE && dimension > 0)
	{
		m_dimension		= dimension;
	}
	if (lambda != NO_CHANGE && lambda > 0)
	{
		m_lambda		= lambda;
	}
	if (ageMax != NO_CHANGE && ageMax > 0)
	{
		m_ageMax		= ageMax;
	}
}

bool CSOINN::SetDimension(int dimension)
{
	if (m_dimension == dimension) return false;
	if (dimension <= 0) return false;

	Reset(dimension, NO_CHANGE, NO_CHANGE);

	return true;
}

int CSOINN::GetDimension(void)
{
	return m_dimension;
}

int CSOINN::GetNodeNum(const bool ignoreAcnode/*=false*/)
{
	int i, nodeNum, count;

	if (ignoreAcnode)
	{
		// Return the number of nodes who are not isolated node
		count = 0;
		nodeNum = (int)m_nodeInfo.size();
		for (i=0; i<nodeNum; i++)
		{
			if (m_nodeInfo[i].m_neighborNum > 0)
			{
				count++;
			}
		}
		return count;
	}
	else
	{
		// Return number of all nodes
		return (int)m_nodeInfo.size();
	}
}

int CSOINN::GetEdgeNum(void)
{
	return (int)m_edgeInfo.size();
}

int CSOINN::GetClassNum(void)
{
	return m_classNum;
}

CNode* CSOINN::GetNode(const int node)
{
	if (!IsExistNode(node)) return NULL;

	return &(m_nodeInfo[node]);
}

CEdge* CSOINN::GetEdge(const int edge)
{
	if (!IsExistEdge(edge)) return NULL;

	return &(m_edgeInfo[edge]);
}

int CSOINN::GetClassFromNode(const int node)
{
	if (!IsExistNode(node)) return NOT_FOUND;

	return m_nodeInfo[node].m_classID;
}

// Remove isolated nodes when learning time is greater than threshold
void CSOINN::RemoveUnnecessaryNode(void)
{
	m_deleteNodeList.clear();

	int lastNode = ((int) m_nodeInfo.size() - 1);
	for (int i = lastNode; i >= 0; i--)
	{
		if (m_nodeInfo[i].m_neighborNum <= 1)
		{
			m_deleteNodeList.push_back(i);  // boxing.
		}
	}

	for (int i = 0; i < (int) m_deleteNodeList.size(); i++)
	{
		RemoveNode(m_deleteNodeList[i]);  // unboxing.
	}
}

// Save the network data of SOINN
// LoadNetworkData(...) can be used to restore the network for learning
bool CSOINN::SaveNetworkData(const char *fileName)
{
	HANDLE hFile;
	DWORD dwWriteSize;
	int i, nodeNum, edgeNum;

	hFile = CreateFile(fileName, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, 0, NULL);
	if (hFile == INVALID_HANDLE_VALUE)
	{
		CloseHandle(hFile);
		return false;
	}

	// SOINN data
	WriteFile(hFile, &(this->m_dimension), sizeof(int), &dwWriteSize, NULL);// m_dimension
	WriteFile(hFile, &(this->m_lambda), sizeof(int), &dwWriteSize, NULL);	// m_lambda
	WriteFile(hFile, &(this->m_ageMax), sizeof(int), &dwWriteSize, NULL);	// m_ageMax
	WriteFile(hFile, &(this->m_classNum), sizeof(int), &dwWriteSize, NULL);	// m_classNum
	WriteFile(hFile, &(this->m_inputNum), sizeof(int), &dwWriteSize, NULL);	// m_inputNum

	// Node data
	nodeNum = (int)m_nodeInfo.size();
	WriteFile(hFile, &nodeNum, sizeof(int), &dwWriteSize, NULL);// nodeNum
	for (i=0; i<nodeNum; i++)
	{
		WriteFile(hFile, this->m_nodeInfo[i].m_signal, sizeof(double)*m_dimension, &dwWriteSize, NULL);			// m_signal
		WriteFile(hFile, this->m_nodeInfo[i].m_neighbor, sizeof(int)*CNode::MAX_NEIGHBOR, &dwWriteSize, NULL);	// m_neighbor
		WriteFile(hFile, &(this->m_nodeInfo[i].m_neighborNum), sizeof(int), &dwWriteSize, NULL);				// m_neighborNum
		WriteFile(hFile, &(this->m_nodeInfo[i].m_learningTime), sizeof(int), &dwWriteSize, NULL);				// m_learningTime
		WriteFile(hFile, &(this->m_nodeInfo[i].m_classID), sizeof(int), &dwWriteSize, NULL);					// m_classID
		//WriteFile(hFile, &(this->m_nodeInfo[i].m_dimension), sizeof(int), &dwWriteSize, NULL);					// m_dimension
	}

	// Edge data
	edgeNum = (int)m_edgeInfo.size();
	WriteFile(hFile, &edgeNum, sizeof(int), &dwWriteSize, NULL);// edgeNum
	for (i=0; i<edgeNum; i++)
	{
		WriteFile(hFile, &(this->m_edgeInfo[i].m_from), sizeof(int), &dwWriteSize, NULL);	// m_from
		WriteFile(hFile, &(this->m_edgeInfo[i].m_to), sizeof(int), &dwWriteSize, NULL);		// m_to
		WriteFile(hFile, &(this->m_edgeInfo[i].m_age), sizeof(int), &dwWriteSize, NULL);	// m_age
	}

	CloseHandle(hFile);
	return true;
}

bool CSOINN::LoadNetworkData(const char *fileName)
{
	HANDLE hFile;
	DWORD dwWriteSize;
	int i, nodeNum, edgeNum;
	int intTemp;

	hFile = CreateFile(fileName, GENERIC_READ, NULL, NULL, OPEN_EXISTING, NULL, NULL);
	if (hFile == INVALID_HANDLE_VALUE){
		MY_INFO(TEXT("cannot open the file to load"));
		CloseHandle(hFile);
		return false;
	}

	// SOINN data
	ReadFile(hFile, &intTemp, sizeof(int), &dwWriteSize, NULL);// m_dimension
	if(intTemp != this->m_dimension){
		if(MY_YESNO(TEXT("m_dimension is NOT equal to loaded data\ndo you want to overwrite?")) == IDNO){
			MY_INFO(TEXT("abort loading"));
			CloseHandle(hFile);
			return false;
		}
	}
	this->m_dimension = intTemp;

	ReadFile(hFile, &intTemp, sizeof(int), &dwWriteSize, NULL);// m_lambda
	if(intTemp != this->m_lambda){
		if(MY_YESNO(TEXT("m_lambda is NOT equal to loaded data\ndo you want to overwrite?")) == IDNO){
			MY_INFO(TEXT("abort loading"));
			CloseHandle(hFile);
			return false;
		}
	}
	this->m_lambda = intTemp;

	ReadFile(hFile, &intTemp, sizeof(int), &dwWriteSize, NULL);// m_ageMax
	if(intTemp != this->m_ageMax){
		if(MY_YESNO(TEXT("m_ageMax is NOT equal to loaded data\ndo you want to overwrite?")) == IDNO){
			MY_INFO(TEXT("abort loading"));
			CloseHandle(hFile);
			return false;
		}
	}
	this->m_ageMax = intTemp;

	ReadFile(hFile, &(this->m_classNum), sizeof(int), &dwWriteSize, NULL);	// m_classNum
	ReadFile(hFile, &(this->m_inputNum), sizeof(int), &dwWriteSize, NULL);	// m_inputNum

	// Node data
	ReadFile(hFile, &nodeNum, sizeof(int), &dwWriteSize, NULL);// nodeNum
	while (!m_nodeInfo.empty())// initialize Node data
	{
		m_nodeInfo.pop_back();
	}
	for(i=0; i<nodeNum; i++){
		m_nodeInfo.push_back(CNode(m_dimension));
	}
	for (i=0; i<nodeNum; i++)
	{
		ReadFile(hFile, this->m_nodeInfo[i].m_signal, sizeof(double)*m_dimension, &dwWriteSize, NULL);			// m_signal
		ReadFile(hFile, this->m_nodeInfo[i].m_neighbor, sizeof(int)*CNode::MAX_NEIGHBOR, &dwWriteSize, NULL);	// m_neighbor
		ReadFile(hFile, &(this->m_nodeInfo[i].m_neighborNum), sizeof(int), &dwWriteSize, NULL);					// m_neighborNum
		ReadFile(hFile, &(this->m_nodeInfo[i].m_learningTime), sizeof(int), &dwWriteSize, NULL);				// m_learningTime
		ReadFile(hFile, &(this->m_nodeInfo[i].m_classID), sizeof(int), &dwWriteSize, NULL);						// m_classID
		//ReadFile(hFile, &(this->m_nodeInfo[i].m_dimension), sizeof(int), &dwWriteSize, NULL);					// m_dimension
	}

	// Edge data
	ReadFile(hFile, &edgeNum, sizeof(int), &dwWriteSize, NULL);// edgeNum
	while (!m_edgeInfo.empty())// initialize Edge data
	{
		m_edgeInfo.pop_back();
	}
	for(i=0; i<edgeNum; i++){
		m_edgeInfo.push_back(CEdge());
	}
	for (i=0; i<edgeNum; i++)
	{
		ReadFile(hFile, &(this->m_edgeInfo[i].m_from), sizeof(int), &dwWriteSize, NULL);	// m_from
		ReadFile(hFile, &(this->m_edgeInfo[i].m_to), sizeof(int), &dwWriteSize, NULL);		// m_to
		ReadFile(hFile, &(this->m_edgeInfo[i].m_age), sizeof(int), &dwWriteSize, NULL);		// m_age
	}

	CloseHandle(hFile);
	return true;
}

// Find winner and runnerup
//
bool CSOINN::FindWinnerAndSecondWinner(int &winner, int &secondWinner, const double *signal)
{
	int i, nodeNum;
	double dist, minDist, secondMinDist;

	winner        = NOT_FOUND;
	secondWinner  = NOT_FOUND;

	// If number of nodes is less than 2, return false and exit
	if (m_nodeInfo.size() < 2) return false;

	minDist       = INFINITY;
	secondMinDist = INFINITY;

	nodeNum = (int)m_nodeInfo.size();
	for (i=0; i<nodeNum; i++)
	{
		// Calculate distance
		dist = Distance(m_nodeInfo[i].m_signal, signal);
		if (minDist > dist)
		{
			secondMinDist = minDist;
			minDist       = dist;
			secondWinner  = winner;
			winner        = i;
		}
		else if (secondMinDist > dist)
		{
			secondMinDist = dist;
			secondWinner  = i;
		}
	}

	return true;
}

// Judge if the input data belongs to known knowledge or new knowledge
bool CSOINN::IsWithinThreshold(const int winner, const int secondWinner, const double *signal)
{
	if (!IsExistNode(winner)) return false;
	if (!IsExistNode(secondWinner)) return false;

	if (Distance(m_nodeInfo[winner].m_signal, signal) > GetSimilarityThreshold(winner))
	{
		return false;
	}
	if (Distance(m_nodeInfo[secondWinner].m_signal, signal) > GetSimilarityThreshold(secondWinner))
	{
		return false;
	}

	// If distance between input data and winner or runnerup is less than similarity threshold, it belongs to known knowledge
	return true;
}

// Increment the age of edge
bool CSOINN::IncrementEdgeAge(const int node)
{
	int i, f, t, edgeNum;

	// If no such nodes exited, return false and exit
	if (!IsExistNode(node)) return false;
	// If there is no neighbor of this node, return false and exit
	if (m_nodeInfo[node].m_neighborNum == 0) return false;

	// Count up the age of edge linked with the node
	edgeNum = (int)m_edgeInfo.size();
	for (i=0; i<edgeNum; i++)
	{
		f = m_edgeInfo[i].m_from;
		t = m_edgeInfo[i].m_to;
		if (f == node || t == node)
		{
			m_edgeInfo[i].m_age++;
		}
	}

	return true;
}

bool CSOINN::ResetEdgeAge(const int node1, const int node2)
{
	int edge;

	if (node1 == node2) return false;
	if (!IsExistNode(node1)) return false;
	if (!IsExistNode(node2)) return false;

	edge = FindEdge(node1, node2);
	if (edge == NOT_FOUND) return false;

	m_edgeInfo[edge].m_age = 0;

	return true;
}

// Remove edges whose age are greater than threshold age
// Return true if there is removed edge
bool CSOINN::RemoveDeadEdge(void)
{
	bool isRemoved = false;
	int lastEdge = ((int)m_edgeInfo.size() - 1);

	m_deleteNodeList.clear();

	for (int i = lastEdge; i >= 0; i--)
	{
		if (m_edgeInfo[i].m_age > m_ageMax)
		{
			m_nodeInfo[m_edgeInfo[i].m_from].SetIsEdgeRemoved(true);
			m_nodeInfo[m_edgeInfo[i].m_to].SetIsEdgeRemoved(true);

			RemoveEdge(i);
			isRemoved = true;
		}
	}

	int lastNode = ((int)m_nodeInfo.size() - 1);
	for (int i = lastNode; i >= 0; i--)
	{
		if (m_nodeInfo[i].GetIsEdgeRemoved() && m_nodeInfo[i].m_neighborNum == 0)
		{
			m_deleteNodeList.push_back(i);
		} else {
			m_nodeInfo[i].SetIsEdgeRemoved(false);
		}
	}

	for (int i = 0; i < (int) m_deleteNodeList.size(); i++)
	{
		RemoveNode(m_deleteNodeList[i]);
	}

	return isRemoved;
}

// Update the times been winner for the node
bool CSOINN::UpdateLearningTime(const int node)
{
	if (!IsExistNode(node)) return false;

	m_nodeInfo[node].m_learningTime++;

	return true;
}

// update the weight of node and its neighbor
bool CSOINN::MoveNode(const int node, const double *signal)
{
	int i, j, neighbor, neighborNum;
	double learningRateOfNode, learningRateOfNeighbor;

	if (!IsExistNode(node)) return false;
	if (m_nodeInfo[node].m_learningTime == 0) return false;

	learningRateOfNode     = 1.0/(double)m_nodeInfo[node].m_learningTime;
	learningRateOfNeighbor = learningRateOfNode/100.0;
//	learningRateOfNeighbor = 0.0; // If want to converge to average position

	for (j=0; j<m_dimension; j++)
	{
		m_nodeInfo[node].m_signal[j] += learningRateOfNode*(signal[j]-m_nodeInfo[node].m_signal[j]);
	}

	neighborNum = m_nodeInfo[node].m_neighborNum;
	for (i=0; i<neighborNum; i++)
	{
		neighbor = m_nodeInfo[node].m_neighbor[i];
		for (j=0; j<m_dimension; j++)
		{
			m_nodeInfo[neighbor].m_signal[j] += learningRateOfNeighbor*(signal[j]-m_nodeInfo[neighbor].m_signal[j]);
		}
	}

	return true;
}

double CSOINN::Distance(const double *signal1, const double *signal2)
{
	int i;
	double sum;

	if (signal1 == NULL || signal2 == NULL) return 0.0;

	sum = 0.0;
	for (i=0; i<m_dimension; i++)
	{
		sum += (signal1[i]-signal2[i])*(signal1[i]-signal2[i]);
	}

	return sqrt(sum)/(double)m_dimension;
}

double CSOINN::Distance(const int node1, const int node2)
{
	if (node1 == node2) return 0.0;
	if (!IsExistNode(node1)) return 0.0;
	if (!IsExistNode(node2)) return 0.0;

	return Distance(m_nodeInfo[node1].m_signal, m_nodeInfo[node2].m_signal);
}

// Calculate the simiarity threshold
double CSOINN::GetSimilarityThreshold(const int node)
{
	int i, nodeNum, neighborNum, neighbor;
	double dist, minDist, maxDist;

	// If the node is not exist, return 0
	if (!IsExistNode(node)) return 0.0;

	// Get the number of neighbors
	neighborNum = m_nodeInfo[node].m_neighborNum;
	if (neighborNum > 0)
	{
		// If there are neighbor nodes
		maxDist = 0.0;
		for (i=0; i<neighborNum; i++)
		{
			// Set the longest distance between neighbors and the node as the similarity threshold
			neighbor = m_nodeInfo[node].m_neighbor[i];
			dist = Distance(node, neighbor);
			if (maxDist < dist)
			{
				maxDist = dist;
			}
		}

		return maxDist;
	}
	else
	{
		// If there is no neighbor
		minDist = INFINITY;
		nodeNum = (int)m_nodeInfo.size();
		for (i=0; i<nodeNum; i++)
		{
			// Set the shortest distance of all nodes to the node as the similarity threshold
			if (i != node)
			{
				dist = Distance(node, i);
				if (minDist > dist)
				{
					minDist = dist;
				}
			}
		}

		return minDist;
	}
}

bool CSOINN::AddNode(const double *signal)
{
	CNode newNode(m_dimension, signal);
	m_nodeInfo.push_back(newNode);

	return true;
}

bool CSOINN::RemoveNode(int node)
{
	int i, nodeNum, edgeNum, neighbor, lastNode;

	if (!IsExistNode(node)) return false;

	while (m_nodeInfo[node].m_neighborNum > 0)
	{
		neighbor = m_nodeInfo[node].m_neighbor[0];
		RemoveEdge(node, neighbor);
	}

	nodeNum  = (int)m_nodeInfo.size();
	edgeNum  = (int)m_edgeInfo.size();
	lastNode = (int)m_nodeInfo.size()-1;
	if (node < lastNode)
	{
		m_nodeInfo[node] = m_nodeInfo[lastNode];
		for (i=0; i<nodeNum; i++)
		{
			m_nodeInfo[i].ReplaceNeighbor(lastNode, node);
		}
		for (i=0; i<edgeNum; i++)
		{
			m_edgeInfo[i].Replace(lastNode, node);
		}
	}
	m_nodeInfo.pop_back();

	return true;
}

// Judge if the node exist or not
bool CSOINN::IsExistNode(int node)
{
	if (node < 0)          return false;
	if (node >= (int)m_nodeInfo.size()) return false;

	return true;
}

bool CSOINN::AddEdge(const int node1, const int node2)
{
	if (node1 == node2) return false;
	if (!IsExistNode(node1)) return false;
	if (!IsExistNode(node2)) return false;
	if (IsExistEdge(node1, node2)) return false;

	if (m_nodeInfo[node1].m_neighborNum >= CNode::MAX_NEIGHBOR ||
		m_nodeInfo[node2].m_neighborNum >= CNode::MAX_NEIGHBOR)
	{
		MY_ERROR(TEXT("the number of neighbor nodes is over CNode::MAX_NEIGHBOR"));
		return false;
	}

	CEdge newEdge(node1, node2);
	m_edgeInfo.push_back(newEdge);
	m_nodeInfo[node1].AddNeighbor(node2);
	m_nodeInfo[node2].AddNeighbor(node1);

	return true;
}

bool CSOINN::RemoveEdge(const int edge)
{
	int f, t, lastEdge;

	if (!IsExistEdge(edge)) return false;

	f = m_edgeInfo[edge].m_from;
	t = m_edgeInfo[edge].m_to;

	m_nodeInfo[f].DeleteNeighbor(t);
	m_nodeInfo[t].DeleteNeighbor(f);

	lastEdge = (int)m_edgeInfo.size()-1;
	if (edge < lastEdge)
	{
		m_edgeInfo[edge] = m_edgeInfo[lastEdge];
	}
	m_edgeInfo.pop_back();

	return true;
}

bool CSOINN::RemoveEdge(const int node1, const int node2)
{
	int edge;

	if (node1 == node2) return false;
	if (!IsExistNode(node1)) return false;
	if (!IsExistNode(node2)) return false;

	edge = FindEdge(node1, node2);
	if (edge == NOT_FOUND) return false;

	return RemoveEdge(edge);
}

bool CSOINN::IsExistEdge(const int edge)
{
	if (edge < 0 || (int)m_edgeInfo.size() <= edge) return false;

	return true;
}

bool CSOINN::IsExistEdge(const int node1, const int node2)
{
	int i, f, t, edgeNum;

	if (node1 == node2) return false;
	if (!IsExistNode(node1)) return false;
	if (!IsExistNode(node2)) return false;

	edgeNum = (int)m_edgeInfo.size();
	for (i=0; i<edgeNum; i++)
	{
		f = m_edgeInfo[i].m_from;
		t = m_edgeInfo[i].m_to;
		if ((f == node1 && t == node2) || (t == node1 && f == node2))
		{
			return true;
		}
	}

	return false;
}

int CSOINN::FindEdge(const int node1, const int node2)
{
	int i, f, t, edgeNum;

	if (node1 == node2) return false;
	if (!IsExistNode(node1)) return false;
	if (!IsExistNode(node2)) return false;

	edgeNum = (int)m_edgeInfo.size();
	for (i=0; i<edgeNum; i++)
	{
		f = m_edgeInfo[i].m_from;
		t = m_edgeInfo[i].m_to;
		if ((f == node1 && t == node2) || (t == node1 && f == node2))
		{
			return i;
		}
	}

	return NOT_FOUND;
}

// Label the node with classID, and then label all nodes linked with the node recurrently
bool CSOINN::SetClassID(const int node, const int classID)
{
	int i, neighbor, neighborNum;

	if (!IsExistNode(node)) return false;
	if (m_nodeInfo[node].m_classID != UNCLASSIFIED) return false;

	m_nodeInfo[node].m_classID = classID;
	neighborNum = m_nodeInfo[node].m_neighborNum;
	for (i=0; i<neighborNum; i++)
	{
		neighbor = m_nodeInfo[node].m_neighbor[i];
		if (m_nodeInfo[neighbor].m_classID == UNCLASSIFIED)
		{
			SetClassID(neighbor, classID);
		}
	}

	return true;
}
