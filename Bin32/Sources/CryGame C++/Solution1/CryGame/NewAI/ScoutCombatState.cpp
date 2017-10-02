//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: ScoutCombatState.cpp
// Description: Abstraction of the state of a breach agent
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "ScoutCombatState.h"
void CScoutCombatState::setBreachID(const int id)
{
this->m_nBreachId = id;
}
int CScoutCombatState::getBreachID()
{
return this->m_nBreachId;
}
void CScoutCombatState::setInPosn(const bool flag)
{
this->m_bInPosn = flag;
}
int CScoutCombatState::getInPosn()
{
return this->m_bInPosn;
}
void CScoutCombatState::setDestination(const string destn)
{
m_destination = destn;
}
string CScoutCombatState::getDestination()
{
return m_destination;
}
