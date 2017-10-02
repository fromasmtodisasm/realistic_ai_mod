//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: BreachCombatState.cpp
// Description: Abstraction of the state of a breach agent
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "BreachCombatState.h"
void CBreachCombatState::setBreachID(const int id)
{
this->m_nBreachId = id;
}
int CBreachCombatState::getBreachID()
{
return this->m_nBreachId;
}
void CBreachCombatState::setInPosn(const bool flag)
{
this->m_bInPosn = flag;
}
int CBreachCombatState::getInPosn()
{
return this->m_bInPosn;
}
void CBreachCombatState::setDestination(const string destn)
{
m_destination = destn;
}
string CBreachCombatState::getDestination()
{
return m_destination;
}
