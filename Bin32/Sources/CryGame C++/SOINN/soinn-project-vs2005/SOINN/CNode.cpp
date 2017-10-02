/*
 * SOINN Software Version 1.2.0
 * http://haselab.info/
 */

#include "CNode.h"
#include "CSOINN.h"
#include <string.h>

//int CNode::m_dimension        = 0;
const int CNode::MAX_NEIGHBOR = 30;
const int CNode::EMPTY        = -1;

CNode::CNode(const int dimension)
{
	Init(dimension);
}

// Generate node with given data dimension and given data vector
CNode::CNode(const int dimension, const double *signal)
{
	Init(dimension);
	
	if (m_dimension <= 0) return;
	if (m_signal == NULL)
	{
		m_signal = new double[m_dimension];
	}
	memcpy(m_signal, signal, sizeof(double)*m_dimension);
}

// Generate node with same contents as given node
CNode::CNode(const CNode &node)
{
	m_signal   = NULL;
	m_neighbor = NULL;
	Copy(node);
}

CNode& CNode::operator=(const CNode &node)
{
	if (this != &node)
	{
		Copy(node);
	}
	return *this;
}

// The destructor frees the memory
CNode::~CNode()
{
	if (m_signal != NULL)
	{
		delete [] m_signal;
		m_signal = NULL;
	}
	if (m_neighbor != NULL)
	{
		delete [] m_neighbor;
		m_neighbor = NULL;
	}
}

// The node is registered as neighbor node
// 
bool CNode::AddNeighbor(const int node)
{
	int i;

	// If number of neighbors is greater than threshold, return false
	if (m_neighborNum >= MAX_NEIGHBOR) return false;

	// If this node is already neighbor
	for (i=0; i<m_neighborNum; i++)
	{
		if (m_neighbor[i] == node) return false;
	}

	// Add this node as new neighbor
	m_neighbor[m_neighborNum] = node;
	m_neighborNum++;

	return true;
}

// Delete the neighbor node
bool CNode::DeleteNeighbor(const int node)	
{
	int i;

	for (i=0; i<m_neighborNum; i++)
	{
		if(node == m_neighbor[i])
		{
			m_neighborNum--;
			m_neighbor[i] = m_neighbor[m_neighborNum];
			m_neighbor[m_neighborNum] = EMPTY;
			return true;
		}
	}

	return false;
}

// Replace neighbor node
bool CNode::ReplaceNeighbor(const int before, const int after)
{
	int i;

	// If the nodes are same, return false
	if (before == after) return false;

	for (i=0; i<m_neighborNum; i++)
	{
		// If before node is neighbor node
		if (before == m_neighbor[i])
		{
			// If after node is also neighbor node
			if (IsNeighbor(after))
			{
				// remove before node
				m_neighborNum--;
				m_neighbor[i] = m_neighbor[m_neighborNum];
				m_neighbor[m_neighborNum] = EMPTY;
			}
			else
			{
				// replace before node with after node
				m_neighbor[i] = after;
			}
			return true;
		}
	}

	// If cannot find the before node
	return false;
}

// Judge if the node is the neighbor
bool CNode::IsNeighbor(const int node)
{
	int i;

	for (i=0; i<m_neighborNum; i++)
	{
		if (m_neighbor[i] == node)
		{
			return true;
		}
	}

	return false;
}

// get signal vector
double* CNode::GetSignal()
{
	return m_signal;
}

// get class id
int CNode::GetClass()
{
	return m_classID;
}

// get isEdgeRemoved
bool CNode::GetIsEdgeRemoved()
{
	return m_isEdgeRemoved;
}

// set isEdgeRemoved
void CNode::SetIsEdgeRemoved(const bool isEdgeRemoved)
{
	m_isEdgeRemoved = isEdgeRemoved;
}

// Initialize
void CNode::Init(const int dimension)
{
	m_dimension = dimension;

	int i;

	if (m_dimension > 0)
	{
		m_signal       = new double[m_dimension];
	}
	m_neighbor      = new int[MAX_NEIGHBOR];
	m_neighborNum   = 0;
	m_learningTime  = 0;
	m_classID       = CSOINN::UNCLASSIFIED;
	m_isEdgeRemoved = false;

	for (i=0; i<MAX_NEIGHBOR; i++)
	{
		m_neighbor[i] = EMPTY;
	}
}

// Copy node
void CNode::Copy(const CNode &src)
{
	if (m_signal != NULL)
	{
		delete [] m_signal;
	}
	if (m_neighbor != NULL)
	{
		delete [] m_neighbor;
	}
	
	::memcpy(this, &src, sizeof(CNode));
	
	m_signal    = new double[m_dimension];
	m_neighbor  = new int[MAX_NEIGHBOR];

	memcpy(m_signal,   src.m_signal,   sizeof(double)*m_dimension);
	memcpy(m_neighbor, src.m_neighbor, sizeof(int)*MAX_NEIGHBOR);
}
