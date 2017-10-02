#ifndef _EDGE_HEADER_
#define _EDGE_HEADER_


class CEdge
{
	friend class CSOINN;
	friend class COutputWindow;

	// Constant
public:
	static const int EMPTY/*=-1*/;

	// Function
public:
	CEdge();
	CEdge(const int node1, const int node2);
	CEdge(const CEdge &edge);
	~CEdge();
	CEdge&	operator=(const CEdge &edge);

private:
	void	Init(void);
	void	Copy(const CEdge &edge);
	bool	Replace(const int before, const int after);

	// Variable
private:
	int		m_from;
	int		m_to;
	int		m_age;
};

#endif
