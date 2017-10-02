//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: BreachCombatState.h
// Description: Abstraction of the state of a single agent
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#ifndef _BREACHCOMBATSTATE_H_
#define _BREACHCOMBATSTATE_H_
#include <map>
#include <vector>
#include "EnemySighting.h"
class CBreachCombatState
{
public:
//! Constructors
CBreachCombatState( void ) : m_nId(0), m_fElapsedTime(0.0), m_bInPosn(false) {}
CBreachCombatState( int id, float time, bool flag ) : m_nId(id), m_fElapsedTime(time),
m_bInPosn(flag) {}
//! Destructor
virtual ~CBreachCombatState( void );
//! Sets the id of the agent associated with this state object
void setID(const int id);
//! Gets the id of the agent associated with this state object
int getID();
//! Sets the elapsed time in position of this agent
void setElapsedTime(const float time);
//! Gets the elapsed time in position of this agent
float getElapsedTime();
//! Sets the 'in position' state of the agent
void setInPosn(const bool flag);
//! Gets the 'in position' state of the agent
int getInPosn();
//! Adds to the list of enemies that have been spotted
void addEnemySighting(const int id, const Vec3 vPosition, const bool alive);
//! Sets the 'alive' state of an enemy
void setEnemyAlive(const int id, const bool alive);
//! Returns a list of enemy IDs
void getEnemyIDs(std::vector<int>& enemyIDList);
//! Set this agents current destination (tagpoint name)
void setDestination(const string name);
//! Get this agents current destination (tagpoint name)
string getDestination();
private:
//! The agent id
int m_nId;
//! The elapsed time
float m_fElapsedTime;
//! The 'in position' state
bool m_bInPosn;
//! The list of enemy sightings
std::map<int, CEnemySighting*> m_enemySightings;
//! The name of the current detsination (tagpoint)
string m_destination;
};
#endif //_BREACHCOMBATSTATE_H_
