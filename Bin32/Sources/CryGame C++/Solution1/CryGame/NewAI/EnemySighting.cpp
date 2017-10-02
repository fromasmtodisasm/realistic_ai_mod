//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: EnemySighting.cpp
// Description: Abstraction of an enemy sighting record
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "EnemySighting.h"
void CEnemySighting::setEnemyAlive(const bool alive)
{
m_bAlive = alive;
}
bool CEnemySighting::getEnemyAlive()
{
return m_bAlive;
}
void CEnemySighting::setPosition(const Vec3 posn)
{
m_position = posn;
}
Vec3 CEnemySighting::getPosition()
{
return m_position;
}
