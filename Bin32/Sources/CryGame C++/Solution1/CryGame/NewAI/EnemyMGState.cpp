//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: EnemyMGState.cpp
// Description: Abstraction of the state of an enemy machine gunner
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "EnemyMGState.h"
void CEnemyMGState::setGunnerID(const int id)
{
this->m_nCurrentGunnerId = id;
}
int CEnemyMGState::getGunnerID()
{
return this->m_nCurrentGunnerId;
}
void CEnemyMGState::gunnerDied()
{
this->m_nCurrentGunnerId = 0;
}
bool CEnemyMGState::gunnerAssigned()
{
return this->m_nCurrentGunnerId != 0;
}
