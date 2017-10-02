//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: AgentCombatState.h
// Description: Abstraction of the state of a single agent
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "AgentCombatState.h"
#include "EnemySighting.h"
CAgentCombatState::~CAgentCombatState( void )
{
// Release the enemy sightings objects from the heap
if (!m_enemySightings.empty())
{
std::map<int, CEnemySighting*>::iterator iter;
for (iter = m_enemySightings.begin(); iter != m_enemySightings.end(); iter++)
delete iter->second;
}
}
void CAgentCombatState::setID(const int id)
{
this->m_nId = id;
}
int CAgentCombatState::getID()
{
return this->m_nId;
}
void CAgentCombatState::setElapsedTime(const float time)
{
this->m_fElapsedTime = time;
}
float CAgentCombatState::getElapsedTime()
{
return this->m_fElapsedTime;
}
void CAgentCombatState::setInPosn(const bool flag)
{
this->m_bInPosn = flag;
}
int CAgentCombatState::getInPosn()
{
return this->m_bInPosn;
}
void CAgentCombatState::addEnemySighting(const int id, const Vec3 vPosition, const bool alive)
{
// See if an enemy sighting with this key already exists; if so, erase it
std::map<int, CEnemySighting*>::iterator iter = m_enemySightings.find(id);
if (iter != m_enemySightings.end())
{
delete iter->second;
m_enemySightings.erase(iter);
}
// Add the newly created enemy sighting
CEnemySighting* pEnemySighting = new CEnemySighting(id, vPosition, alive);
m_enemySightings.insert(std::make_pair(id, pEnemySighting));
}
void CAgentCombatState::setEnemyAlive(const int id, const bool alive)
{
// See if an enemy sighting with this key already exists; if so, erase it
std::map<int, CEnemySighting*>::iterator iter = m_enemySightings.find(id);
if (iter != m_enemySightings.end())
{
iter->second->setEnemyAlive(alive);
}
}
void CAgentCombatState::getEnemyIDs(std::vector<int>& enemyIDList)
{
enemyIDList.clear();
std::map<int, CEnemySighting*>::iterator iter;
for (iter = m_enemySightings.begin(); iter != m_enemySightings.end(); iter++)
{
enemyIDList.push_back(iter->first);
}
}
void CAgentCombatState::setDestination(const string destn)
{
m_destination = destn;
}
string CAgentCombatState::getDestination()
{
return m_destination;
}

//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: AgentCombatState.h
// Description: Abstraction of the state of a single agent
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "AgentCombatState.h"
#include "EnemySighting.h"
CAgentCombatState::~CAgentCombatState( void )
{
// Release the enemy sightings objects from the heap
if (!m_enemySightings.empty())
{
std::map<int, CEnemySighting*>::iterator iter;
for (iter = m_enemySightings.begin(); iter != m_enemySightings.end(); iter++)
delete iter->second;
}
}
void CAgentCombatState::setID(const int id)
{
this->m_nId = id;
}
int CAgentCombatState::getID()
{
return this->m_nId;
}
void CAgentCombatState::setElapsedTime(const float time)
{
this->m_fElapsedTime = time;
}
float CAgentCombatState::getElapsedTime()
{
return this->m_fElapsedTime;
}
void CAgentCombatState::setInPosn(const bool flag)
{
this->m_bInPosn = flag;
}
int CAgentCombatState::getInPosn()
{
return this->m_bInPosn;
}
void CAgentCombatState::addEnemySighting(const int id, const Vec3 vPosition, const bool alive)
{
// See if an enemy sighting with this key already exists; if so, erase it
std::map<int, CEnemySighting*>::iterator iter = m_enemySightings.find(id);
if (iter != m_enemySightings.end())
{
delete iter->second;
m_enemySightings.erase(iter);
}
// Add the newly created enemy sighting
CEnemySighting* pEnemySighting = new CEnemySighting(id, vPosition, alive);
m_enemySightings.insert(std::make_pair(id, pEnemySighting));
}
void CAgentCombatState::setEnemyAlive(const int id, const bool alive)
{
// See if an enemy sighting with this key already exists; if so, erase it
std::map<int, CEnemySighting*>::iterator iter = m_enemySightings.find(id);
if (iter != m_enemySightings.end())
{
iter->second->setEnemyAlive(alive);
}
}
void CAgentCombatState::getEnemyIDs(std::vector<int>& enemyIDList)
{
enemyIDList.clear();
std::map<int, CEnemySighting*>::iterator iter;
for (iter = m_enemySightings.begin(); iter != m_enemySightings.end(); iter++)
{
enemyIDList.push_back(iter->first);
}
}
void CAgentCombatState::setDestination(const string destn)
{
m_destination = destn;
}
string CAgentCombatState::getDestination()
{
return m_destination;
}
