/*
 * SOINN Software Version 1.2.0
 * http://haselab.info/
 */

#include "CEdge.h"
#include <string.h>

const int CEdge::EMPTY = -1;

CEdge::CEdge()
{
	Init();
}

// Generate edge between the given nodes
CEdge::CEdge(const int node1, const int node2)
{
	Init();
	m_from = node1;
	m_to   = node2;
}

// Generate edge with the same contents as the given edge
CEdge::CEdge(const CEdge &edge)
{
	Copy(edge);
}

CEdge::~CEdge()
{
}


CEdge& CEdge::operator=(const CEdge &edge)
{
	if (this != &edge)
	{
		Copy(edge);
	}
	return *this;
}

void CEdge::Init(void)
{
	m_from = EMPTY;
	m_to   = EMPTY;
	m_age  = 0;
}

// Copy edge
void CEdge::Copy(const CEdge &edge)
{
	::memcpy(this, &edge, sizeof(CEdge));
}

// Replace edge with new node
bool CEdge::Replace(const int before, const int after)
{
	if (before == after) return false;
	if (m_from == before && m_to == after) return false;
	if (m_to == before && m_from == after) return false;

	if (m_from == before) m_from = after;
	if (m_to   == before) m_to   = after;

	return true;
}
