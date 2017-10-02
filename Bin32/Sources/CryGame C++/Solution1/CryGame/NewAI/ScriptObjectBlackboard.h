//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: ScriptObjectBlackboard.h
// Description: Script wrapper for blackbaord system
//
// History:
// 25July2007 : File created
// 18August2007 : Added agent combat state management methods
//
//////////////////////////////////////////////////////////////////////
#ifndef _SCRIPTOBJECTBLACKBOARD_H_
#define _SCRIPTOBJECTBLACKBOARD_H_
#include <IScriptSystem.h>
#include <_ScriptableEx.h>
#include "AgentCombatState.h"
#include "EnemyMGState.h"
#include "BreachCombatState.h"
#include "ScoutCombatState.h"
#include <map>
/*!
All Blackboard system related script functions are implemented in
this class
All functions are script-exclusive, they aren't called from the
game C code
*/
class CScriptObjectBlackboard : public _ScriptableEx<CScriptObjectBlackboard>
{
public:
//! Constructor
CScriptObjectBlackboard( void ) {m_bAgentIsMovingUp = false;}
//! Destructor
virtual ~CScriptObjectBlackboard( void );
//! Registers functions and global vars with LUA
static void InitializeTemplate(IScriptSystem* pSS);
//! Sets up this object as being accessible from LUA
void Init(IScriptSystem* pScriptSystem, CXGame* pGame);
//! Debug method - just prints a string to the console and the log file
int PrintTestMessage(IFunctionHandler* pH);
//********************************
// Cover Combat State Management
//********************************
//! Add a new cover combat state
int addCoverCombatState(IFunctionHandler* pH);
//! Remove an existing cover combat state
int removeCoverCombatState(IFunctionHandler* pH);
//! Set the elapsed time of an cover combat state
int setCoverElapsedTime(IFunctionHandler* pH);
//! Get the elapsed time of an cover combat state
int getCoverElapsedTime(IFunctionHandler* pH);
//! Call to determine whether cover with specified id is OK to begin moving up
int canCoverMoveUp(IFunctionHandler* pH);//! Call to inform that the cover with specified id has finished moving up
int coverFinishedMovingUp(IFunctionHandler* pH);
//! Call to determine the number of cover agents registered
int getNumCovers(IFunctionHandler* pH);
//! Call to set the cover 'in position' state
int setCoverInPosn(IFunctionHandler* pH);
//! Call to get the cover 'in position' state
int getCoverInPosn(IFunctionHandler* pH);
//! Call to determine if all covers are in position
int getAllCoversInPosn(IFunctionHandler* pH);
//! Adds to the list of enemies that have been spotted
int addCoverEnemySighting(IFunctionHandler* pH);
//! Sets the 'alive' state of an enemy
int setCoverEnemyAlive(IFunctionHandler* pH);
//! Returns a list of enemy IDs
int getCoverEnemyIDs(IFunctionHandler* pH);
//! sets the Cover Destination
int setCoverDestination(IFunctionHandler* pH);
//! gets the Cover Destination
int getCoverDestination(IFunctionHandler* pH);
//**************************************
// Enemy Machine Gunner State Management
//**************************************
//! Sets the id of the current gunner
int setGunnerID(IFunctionHandler* pH);
//! Gets the id of the current gunner
int getGunnerID(IFunctionHandler* pH);
//! Resets the gunner state
int gunnerDied(IFunctionHandler* pH);
//! Gets whether a gunner is currently assigned
int gunnerAssigned(IFunctionHandler* pH);
//********************************
// Breach Combat State Management
//********************************
//! Add a new breach combat state
int addBreachCombatState(IFunctionHandler* pH);
//! Remove an existing breach combat state
int removeBreachCombatState(IFunctionHandler* pH);
//! Call to set the breach 'in position' state
int setBreachInPosn(IFunctionHandler* pH);
//! Call to get the breach 'in position' state
int getBreachInPosn(IFunctionHandler* pH);
//! Call to determine if all breaches are in position
int getAllBreachesInPosn(IFunctionHandler* pH);
//! sets Breach Destination
int setBreachDestination(IFunctionHandler* pH);
//! gets the Breach Destination
int getBreachDestination(IFunctionHandler* pH);
//********************************
// Scout Combat State Management
//********************************
//! Add a new breach combat state
int addScoutCombatState(IFunctionHandler* pH);
//! Remove an existing breach combat state
int removeScoutCombatState(IFunctionHandler* pH);
//! Adds to the list of enemies that have been spotted
int addScoutEnemySighting(IFunctionHandler* pH);;
//! Adds details of main target sighting
int addScoutTargetSighting(IFunctionHandler* pH);
//! Gets the position of the main target sighting
int getScoutTargetSighting(IFunctionHandler* pH);
//! Sets the destination of the scout
int setScoutDestination(IFunctionHandler* pH);
//! gets the destination of the scout
int getScoutDestination(IFunctionHandler* pH);
private:
//! The game object itself
CXGame *m_pGame;
//! Map of agent combat states
std::map<int, CAgentCombatState*> m_AgentCombatStates;
//! Map of breach combat states
std::map<int, CBreachCombatState*> m_BreachCombatStates;
//! Map of scout combat states
std::map<int, CScoutCombatState*> m_ScoutCombatStates;
//! Flag to indicate whether a cover agent is currently moving up
bool m_bAgentIsMovingUp;
//! Handle to the enemy machine gunner state
CEnemyMGState* m_pEnemyMGState;
};
#endif //_SCRIPTOBJECTBLACKBOARD_H_
