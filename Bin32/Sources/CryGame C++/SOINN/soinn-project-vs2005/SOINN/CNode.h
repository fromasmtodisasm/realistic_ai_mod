#ifndef _NODE_HEADER_
#define _NODE_HEADER_

class CNode
{
	friend class CSOINN;
	friend class COutputWindow;

	// Constant
public:
	static const int	MAX_NEIGHBOR/*=30*/;
	static const int	EMPTY/*=-1*/;

	// Function
public:
	CNode(const int dimension);
	CNode(const int dimension, const double *signal);
	CNode(const CNode &node);
	~CNode();
	CNode& operator=(const CNode &node);
	bool	AddNeighbor(const int node);
	bool	DeleteNeighbor(const int node);
	bool	ReplaceNeighbor(const int before, const int after);
	bool	IsNeighbor(const int node);
	double* GetSignal();
	int     GetClass();
	bool	GetIsEdgeRemoved();
	void	SetIsEdgeRemoved(const bool isEdgeRemoved);

private:
	void	Init(const int dimension);
	void	Copy(const CNode &src);

	// Variable
private:
	double*	m_signal;
	int*	m_neighbor;
	int		m_neighborNum;
	int		m_learningTime;
	int		m_classID;
	int		m_dimension;
	bool	m_isEdgeRemoved;
};

#endif
