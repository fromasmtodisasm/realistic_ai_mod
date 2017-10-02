#ifndef _SELF_ORGANIZING_INCREMENTAL_NEURAL_NETWORK_HEADER_
#define _SELF_ORGANIZING_INCREMENTAL_NEURAL_NETWORK_HEADER_

#include "CNode.h"
#include "CEdge.h"
#include <vector>
#include <windows.h>

class CSOINN
{
public:
	static const int    NO_CHANGE/*=0*/;
	static const int	UNCLASSIFIED/*=-1*/;
	static const int	NOT_FOUND/*=-1*/;
	static const double	INFINITY/*=1e10*/;

	static const std::string VERSION;

public:
	CSOINN(const int dimension, const int lambda, const int ageMax);
	~CSOINN();
	bool	InputSignal(const double *signal);
	void	Classify(void);
	void	Reset(const int dimension=NO_CHANGE, const int lambda=NO_CHANGE, const int ageMax=NO_CHANGE);
	bool	SetDimension(int dimension);
	int		GetDimension(void);
	int		GetNodeNum(const bool ignoreAcnode=false);
	int		GetEdgeNum(void);
	int		GetClassNum(void);
	CNode*	GetNode(const int node);
	CEdge*	GetEdge(const int edge);
	int     GetClassFromNode(const int node);
	void	RemoveUnnecessaryNode(void);
	bool	SaveNetworkData(const char *fileName);
	bool    LoadNetworkData(const char *fileName);

private:
	bool	FindWinnerAndSecondWinner(int &winner, int &secondWinner, const double *signal);
	bool	IsWithinThreshold(const int winner, const int secondWinner, const double *signal);
	bool	IncrementEdgeAge(const int node);
	bool	ResetEdgeAge(const int node1, const int node2);
	bool	RemoveDeadEdge(void);
	bool	UpdateLearningTime(const int node);
	bool	MoveNode(const int node, const double *signal);
	double	Distance(const double *signal1, const double *signal2);
	double	Distance(const int node1, const int node2);
	double	GetSimilarityThreshold(const int node);
	bool	AddNode(const double *signal);
	bool	RemoveNode(int node);
	bool	IsExistNode(int node);
	bool	AddEdge(const int node1, const int node2);
	bool	RemoveEdge(const int edge);
	bool	RemoveEdge(const int node1, const int node2);
	bool	IsExistEdge(const int edge);
	bool	IsExistEdge(const int node1, const int node2);
	int		FindEdge(const int node1, const int node2);
	bool	SetClassID(const int node, const int classID);

private:
	std::vector<CNode>	m_nodeInfo;
	std::vector<CEdge>	m_edgeInfo;
	int	m_dimension;
	int	m_lambda;
	int	m_ageMax;
	int	m_classNum;
	int m_inputNum;
	std::vector<int>	m_deleteNodeList;
};

#endif