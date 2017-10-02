//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: ScriptObjectBlackboard.cpp
// Description: Script wrapper for blackbaord system
//
// History:
// 04August2007 : File created by Spencer Drayton
// 18August2007 : Added agent combat state management methods
//
//////////////////////////////////////////////////////////////////////
#include "stdafx.h"
#include "IAgent.h"
#include "IAISystem.h"
#include "ScriptObjectBlackboard.h"
_DECLARE_SCRIPTABLEEX(CScriptObjectBlackboard)
CScriptObjectBlackboard::~CScriptObjectBlackboard( void )
{
// Release the agent (cover) combat state objects from the heap
if (!m_AgentCombatStates.empty())
{
std::map<int, CAgentCombatState*>::iterator iter;
for (iter = m_AgentCombatStates.begin(); iter != m_AgentCombatStates.end(); iter++)
delete iter->second;
}
// Release the breach combat state objects from the heap
if (!m_BreachCombatStates.empty())
{
{
std::map<int, CBreachCombatState*>::iterator iter;
for (iter = m_BreachCombatStates.begin(); iter != m_BreachCombatStates.end(); iter++)
delete iter->second;
}
// Release the scout combat state objects from the heap
if (!m_ScoutCombatStates.empty())
{
std::map<int, CScoutCombatState*>::iterator iter;
for (iter = m_ScoutCombatStates.begin(); iter != m_ScoutCombatStates.end(); iter++)
delete iter->second;
}
// Release enemy machine gunner state
if (m_pEnemyMGState != NULL)
delete m_pEnemyMGState;
}
void CScriptObjectBlackboard::Init(IScriptSystem *pScriptSystem, CXGame* pGame)
{
m_pGame = pGame;
//! Enemy machine gunner state
m_pEnemyMGState = new CEnemyMGState(0);
// Causes this script object to be globally accessible in all LUA scripts using the
// namespace BlackboardObject
InitGlobal(pScriptSystem, "BlackboardObject", this);
}
void CScriptObjectBlackboard::InitializeTemplate(IScriptSystem *pSS)
{
_ScriptableEx<CScriptObjectBlackboard>::InitializeTemplate(pSS);
// Register the functions we want to be accessible from LUA
REG_FUNC(CScriptObjectBlackboard, PrintTestMessage);
// Covers:
REG_FUNC(CScriptObjectBlackboard, addCoverCombatState);
REG_FUNC(CScriptObjectBlackboard, removeCoverCombatState);
REG_FUNC(CScriptObjectBlackboard, setCoverElapsedTime);
REG_FUNC(CScriptObjectBlackboard, getCoverElapsedTime);
REG_FUNC(CScriptObjectBlackboard, canCoverMoveUp);
REG_FUNC(CScriptObjectBlackboard, coverFinishedMovingUp);
REG_FUNC(CScriptObjectBlackboard, getNumCovers);
REG_FUNC(CScriptObjectBlackboard, getAllCoversInPosn);
REG_FUNC(CScriptObjectBlackboard, getCoverInPosn);
REG_FUNC(CScriptObjectBlackboard, setCoverInPosn);
REG_FUNC(CScriptObjectBlackboard, addCoverEnemySighting);
REG_FUNC(CScriptObjectBlackboard, setCoverEnemyAlive);
REG_FUNC(CScriptObjectBlackboard, getCoverEnemyIDs);
REG_FUNC(CScriptObjectBlackboard, setCoverDestination);
REG_FUNC(CScriptObjectBlackboard, getCoverDestination);
// Scouts:
REG_FUNC(CScriptObjectBlackboard, addScoutCombatState);
REG_FUNC(CScriptObjectBlackboard, removeScoutCombatState);
REG_FUNC(CScriptObjectBlackboard, addScoutEnemySighting);
REG_FUNC(CScriptObjectBlackboard, addScoutEnemySighting);
REG_FUNC(CScriptObjectBlackboard, addScoutTargetSighting);
REG_FUNC(CScriptObjectBlackboard, getScoutTargetSighting);
REG_FUNC(CScriptObjectBlackboard, setScoutDestination);
REG_FUNC(CScriptObjectBlackboard, getScoutDestination);
// Enemy gunners:
REG_FUNC(CScriptObjectBlackboard, setGunnerID);
REG_FUNC(CScriptObjectBlackboard, getGunnerID);
REG_FUNC(CScriptObjectBlackboard, gunnerDied);
REG_FUNC(CScriptObjectBlackboard, gunnerAssigned);
// Breaches:
REG_FUNC(CScriptObjectBlackboard, addBreachCombatState);
REG_FUNC(CScriptObjectBlackboard, removeBreachCombatState);
REG_FUNC(CScriptObjectBlackboard, setBreachInPosn);
REG_FUNC(CScriptObjectBlackboard, getBreachInPosn);
REG_FUNC(CScriptObjectBlackboard, getAllBreachesInPosn);
REG_FUNC(CScriptObjectBlackboard, setBreachDestination);
REG_FUNC(CScriptObjectBlackboard, getBreachDestination);
// Also initialise any global values
pSS->SetGlobalValue("GVAR_TEST", 0);
}
// script functions
int CScriptObjectBlackboard::PrintTestMessage(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// NB: to check number of parameters passed, use:
// pH->GetParamCount()
// To check that the paramater passed is a string , use:
// pH->GetParamType(1) == svtString
// Get the string
const char *szMessage = 0;
pH->GetParam(1, szMessage);
if (!szMessage)
return pH->EndFunction();
// Print the string to the console
char szMsgLine[64] = {0};
sprintf(szMsgLine, "Message = \"%s\"", szMessage);
m_pGame->GetSystem()->GetIConsole()->PrintLine(szMsgLine);
// Print the string to the log
m_pGame->m_pLog->Log("Message= \"%s\"", szMessage);
// NB: To call this function from LUA, use:
// BlackboardObject:PrintTestMessage("This is a test message");
// To build a table, set some values then return it to the script, use:
// _SmartScriptObject pObj(m_pScriptSystem);
// pObj->SetValue("TestNumber", nValueID);
// return pH->EndFunction(*pObj);
return pH->EndFunction();
}
//************************************
// Cover Agent Combat State Management
//************************************
int CScriptObjectBlackboard::setCoverInPosn(IFunctionHandler* pH)
{
// Check that only two parameters were passed in
CHECK_PARAMETERS(2);
// Get the id
int coverID;
pH->GetParam(1, coverID);
// Get the flag
bool flag;
pH->GetParam(2, flag);
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(coverID);
if (iter != m_AgentCombatStates.end())
{
iter->second->setInPosn(flag);
// Log the call
m_pGame->m_pLog->Log("Updated combat state (in posn) for cover id: \"%d\"", coverID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getCoverInPosn(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
bool result = false;
// Get the id
int coverID;
pH->GetParam(1, coverID);
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(coverID);
if (iter != m_AgentCombatStates.end())
{
result = iter->second->getInPosn();
// Log the call
m_pGame->m_pLog->Log("Got combat state (in Posn) for cover id: \"%d\"", coverID);
}
return pH->EndFunction(result);
}
int CScriptObjectBlackboard::getAllCoversInPosn(IFunctionHandler* pH)
{
bool allInPosn = false;
// Iterate through all agents
std::map<int, CAgentCombatState*>::iterator iter;
if (!(m_AgentCombatStates.empty()))
{
int numInPosn = 0;
for (iter = m_AgentCombatStates.begin(); iter != m_AgentCombatStates.end(); iter++)
{
if (iter->second->getInPosn())
{
numInPosn++;
}
}
allInPosn = (numInPosn == m_AgentCombatStates.size());
}
int retVal = allInPosn ? 1 : 0;
m_pGame->m_pLog->Log("Returning getAllCoversInPosn: \"%d\"", retVal);
return pH->EndFunction(allInPosn);
}
int CScriptObjectBlackboard::addCoverCombatState(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// Get the integer
int agentID;
pH->GetParam(1, agentID);
// See if a combat state with this key already exists; if so, erase it
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(agentID);
if (iter != m_AgentCombatStates.end())
{
delete iter->second;
m_AgentCombatStates.erase(iter);
// Log the call
m_pGame->m_pLog->Log("Added combat state for cover id: \"%d\"", agentID);
}
// Add the newly created combat state
CAgentCombatState* pCombatState = new CAgentCombatState(agentID, 0.0, false);
m_AgentCombatStates.insert(std::make_pair(agentID, pCombatState));
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::removeCoverCombatState(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// Get the integer
int agentID;
pH->GetParam(1, agentID);
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(agentID);
if (iter != m_AgentCombatStates.end())
{
delete iter->second;
m_AgentCombatStates.erase(iter);
// Log the call
m_pGame->m_pLog->Log("Deleted combat state for cover id: \"%d\"", agentID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::setCoverElapsedTime(IFunctionHandler* pH)
{
// Check that only two parameters were passed in
CHECK_PARAMETERS(2);
// Get the id
int agentID;
pH->GetParam(1, agentID);
// Get the time
float time;
pH->GetParam(2, time);
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(agentID);
if (iter != m_AgentCombatStates.end())
{
iter->second->setElapsedTime(time);
// Log the call
m_pGame->m_pLog->Log("Updated combat state (elapsed time) for cover id: \"%d\"", agentID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getCoverElapsedTime(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
float result = 0.0;
// Get the id
int agentID;
pH->GetParam(1, agentID);
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(agentID);
if (iter != m_AgentCombatStates.end())
{
result = iter->second->getElapsedTime();
// Log the call
m_pGame->m_pLog->Log("Got combat state (elapsed time) for cover id: \"%d\"", agentID);
}
return pH->EndFunction(result);
}
int CScriptObjectBlackboard::canCoverMoveUp(IFunctionHandler* pH)
{
bool canMoveUp = false;
// Check that only two parameters were passed in
CHECK_PARAMETERS(2);
// Get the id
int agentID;
pH->GetParam(1, agentID);
// Get the time
float time;
pH->GetParam(2, time);
// Set the calling agents elapased time
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(agentID);
if (iter != m_AgentCombatStates.end())
{
iter->second->setElapsedTime(time);
}
// Can't move up if an agent is already moving up, or if we have no data
if ((m_bAgentIsMovingUp) || (m_AgentCombatStates.empty()))
return pH->EndFunction(canMoveUp);
float maxTime = 0.0;
int maxID = 0;
for (iter = m_AgentCombatStates.begin(); iter != m_AgentCombatStates.end(); iter++)
{
float currTime = iter->second->getElapsedTime();
m_pGame->m_pLog->Log("Current time is: \"%f\"", currTime);
if ( currTime > maxTime)
{
maxTime = currTime;
maxID = iter->first;
}
}
m_pGame->m_pLog->Log("Max time is: \"%f\"", maxTime);
// If the agent with the longest elapsed time made the request, then
// let it move up, otherwise update is elapsed time.
if (maxID == agentID)
{
m_bAgentIsMovingUp = true;
canMoveUp = true;
// Log the call
m_pGame->m_pLog->Log("Letting cover move up, id: \"%d\"", agentID);
}
return pH->EndFunction(canMoveUp);
}
int CScriptObjectBlackboard::coverFinishedMovingUp(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
float result = 0.0;
// Get the id
int agentID;
pH->GetParam(1, agentID);
// Reset the elapsed time
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(agentID);
if (iter != m_AgentCombatStates.end())
{
iter->second->setElapsedTime(0.0);
// Log the call
m_pGame->m_pLog->Log("Cover finished moving up, id: \"%d\"", agentID);
}
// Reset the flag
m_bAgentIsMovingUp = false;
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getNumCovers(IFunctionHandler* pH)
{
int result = m_AgentCombatStates.size();
return pH->EndFunction(result);
}
int CScriptObjectBlackboard::addCoverEnemySighting(IFunctionHandler* pH)
{
// expecting : int coverID, const int enemyID, const Vec3 vPosition, const bool alive
CHECK_PARAMETERS(4);
// Get the coverID
int coverID;
pH->GetParam(1, coverID);
// Get the enemyID
int enemyID;
pH->GetParam(2, enemyID);
// get the enemy position
Vec3 vPosn(0,0,0);
CScriptObjectVector vPosition(m_pScriptSystem,true);
if(pH->GetParam(3, *vPosition))
{
vPosn = vPosition.Get();
}
// get the enemy 'alive' flag
int bAlive;
pH->GetParam(4, bAlive);
// Find the specified cover, then add a new enemy sighting
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(coverID);
if (iter != m_AgentCombatStates.end())
{
iter->second->addEnemySighting(enemyID, vPosn, bAlive);
// Log the call
m_pGame->m_pLog->Log("Added enemy sighting for cover, id: \"%d\"", coverID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::setCoverEnemyAlive(IFunctionHandler* pH)
{
// int coverID, const int enemyID, const bool alive
CHECK_PARAMETERS(3);
// Get the coverID
int coverID;
pH->GetParam(1, coverID);
// Get the enemyID
int enemyID;
pH->GetParam(2, enemyID);
// get the enemy 'alive' flag
int bAlive;
pH->GetParam(3, bAlive);
// Find the specified cover, then add a new enemy sighting
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(coverID);
if (iter != m_AgentCombatStates.end())
{
iter->second->setEnemyAlive(enemyID, bAlive);
// Log the call
m_pGame->m_pLog->Log("Updated enemy sighting for cover, id: \"%d\"", coverID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getCoverEnemyIDs(IFunctionHandler* pH)
{
CHECK_PARAMETERS(1);
// Get the coverID
int coverID;
pH->GetParam(1, coverID);
// Find the specified cover, then get the enemy IDs
std::vector<int> enemyIDs;
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(coverID);
if (iter != m_AgentCombatStates.end())
{
iter->second->getEnemyIDs(enemyIDs);
// Log the call
m_pGame->m_pLog->Log("Got enemy IDs for cover, id: \"%d\"", coverID);
}
// Convert the vector of tagpoint names and return a LUA table
_SmartScriptObject cList(m_pGame->m_pSystem->GetIScriptSystem(), false);
for (std::vector<int>::iterator it = enemyIDs.begin(); it != enemyIDs.end(); ++it)
{
cList->SetAt(cList->Count()+1, *it);
}
return pH->EndFunction(cList);
}
int CScriptObjectBlackboard::setCoverDestination(IFunctionHandler* pH)
{
CHECK_PARAMETERS(2);
// Get the coverID
int coverID;
pH->GetParam(1, coverID);
// Get the destination string
const char *szDest = 0;
pH->GetParam(2, szDest);
string strDest(szDest);
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(coverID);
if (iter != m_AgentCombatStates.end())
{
iter->second->setDestination(strDest);
// Log the call
m_pGame->m_pLog->Log("Set destination for cover, id: \"%d\"", coverID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getCoverDestination(IFunctionHandler* pH)
{
CHECK_PARAMETERS(1);
// Get the coverID
int coverID;
pH->GetParam(1, coverID);
// Get the destination string
string strDest;
std::map<int, CAgentCombatState*>::iterator iter = m_AgentCombatStates.find(coverID);
if (iter != m_AgentCombatStates.end())
{
strDest = iter->second->getDestination();
// Log the call
m_pGame->m_pLog->Log("Got destination for cover, id: \"%d\"", coverID);
}
return pH->EndFunction(strDest.c_str());
}
//********************************
// Scout Combat State Management
//********************************
//! Add a new breach combat state
int CScriptObjectBlackboard::addScoutCombatState(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// Get the integer
int scoutID;
pH->GetParam(1, scoutID);
// See if a combat state with this key already exists; if so, erase it
std::map<int, CScoutCombatState*>::iterator iter = m_ScoutCombatStates.find(scoutID);
if (iter != m_ScoutCombatStates.end())
{
delete iter->second;
m_ScoutCombatStates.erase(iter);
// Log the call
m_pGame->m_pLog->Log("Added combat state for scout id: \"%d\"", scoutID);
}
// Add the newly created combat state
CScoutCombatState* pCombatState = new CScoutCombatState(scoutID, false);
m_ScoutCombatStates.insert(std::make_pair(scoutID, pCombatState));
return pH->EndFunction(1);
}
//! Remove an existing breach combat state
int CScriptObjectBlackboard::removeScoutCombatState(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// Get the integer
int scoutID;
pH->GetParam(1, scoutID);
std::map<int, CScoutCombatState*>::iterator iter = m_ScoutCombatStates.find(scoutID);
if (iter != m_ScoutCombatStates.end())
{
delete iter->second;
m_ScoutCombatStates.erase(iter);
// Log the call
m_pGame->m_pLog->Log("Deleted combat state for scout id: \"%d\"", scoutID);
}
return pH->EndFunction(1);
}
//! Adds to the list of enemies that have been spotted
int CScriptObjectBlackboard::addScoutEnemySighting(IFunctionHandler* pH)
{
CHECK_PARAMETERS(4);
// Get the scoutID
int scoutID;
pH->GetParam(1, scoutID);
// Get the enemyID
int enemyID;
pH->GetParam(2, enemyID);
// get the enemy position
Vec3 vPosn(0,0,0);
CScriptObjectVector vPosition(m_pScriptSystem,true);
if(pH->GetParam(3, *vPosition))
{
vPosn = vPosition.Get();
}
// get the enemy 'alive' flag
int bAlive;
pH->GetParam(4, bAlive);
// Find the specified scout, then add a new enemy sighting
std::map<int, CScoutCombatState*>::iterator iter = m_ScoutCombatStates.find(scoutID);
if (iter != m_ScoutCombatStates.end())
{
iter->second->addEnemySighting(enemyID, vPosn, bAlive);
// Log the call
m_pGame->m_pLog->Log("Added enemy sighting for scout, id: \"%d\"", scoutID);
}
return pH->EndFunction(1);
}
//! Adds details of main target sighting
int CScriptObjectBlackboard::addScoutTargetSighting(IFunctionHandler* pH)
{
CHECK_PARAMETERS(2);
// Get the scoutID
int scoutID;
pH->GetParam(1, scoutID);
// get the target position
Vec3 vPosn(0,0,0);
CScriptObjectVector vPosition(m_pScriptSystem,true);
if(pH->GetParam(2, *vPosition))
{
vPosn = vPosition.Get();
}
// Find the specified scout, then get the target sighting
std::map<int, CScoutCombatState*>::iterator iter = m_ScoutCombatStates.find(scoutID);
if (iter != m_ScoutCombatStates.end())
{
iter->second->addTargetSighting(vPosn);
// Log the call
m_pGame->m_pLog->Log("Set target sighting for scout, id: \"%d\"", scoutID);
}
return pH->EndFunction(1);
}
//! Gets the position of the main target sighting
int CScriptObjectBlackboard::getScoutTargetSighting(IFunctionHandler* pH)
{
CHECK_PARAMETERS(1);
// Get the scoutID
int scoutID;
pH->GetParam(1, scoutID);
// Find the specified scout, then get the target sighting
CScriptObjectVector vPosition(m_pScriptSystem,true);
Vec3 targetPosn;
std::map<int, CScoutCombatState*>::iterator iter = m_ScoutCombatStates.find(scoutID);
if (iter != m_ScoutCombatStates.end())
{
targetPosn = iter->second->getTargetSighting();
vPosition.Set(targetPosn);
// Log the call
m_pGame->m_pLog->Log("Got target sighting from scout, id: \"%d\"", scoutID);
}
return pH->EndFunction(vPosition);
}
int CScriptObjectBlackboard::setScoutDestination(IFunctionHandler* pH)
{
CHECK_PARAMETERS(2);
// Get the scoutID
int scoutID;
pH->GetParam(1, scoutID);
// Get the destination string
const char *szDest = 0;
pH->GetParam(2, szDest);
string strDest(szDest);
std::map<int, CScoutCombatState*>::iterator iter = m_ScoutCombatStates.find(scoutID);
if (iter != m_ScoutCombatStates.end())
{
iter->second->setDestination(strDest);
// Log the call
m_pGame->m_pLog->Log("Set destination for scout, id: \"%d\"", scoutID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getScoutDestination(IFunctionHandler* pH)
{
CHECK_PARAMETERS(1);
// Get the scoutID
int scoutID;
pH->GetParam(1, scoutID);
// Get the destination string
string strDest;
std::map<int, CScoutCombatState*>::iterator iter = m_ScoutCombatStates.find(scoutID);
if (iter != m_ScoutCombatStates.end())
{
strDest = iter->second->getDestination();
// Log the call
m_pGame->m_pLog->Log("Got destination for scout, id: \"%d\"", scoutID);
}
return pH->EndFunction(strDest.c_str());
}
//**************************************
// Enemy Machine Gunner State Management
//**************************************
int CScriptObjectBlackboard::setGunnerID(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// Get the id
int gunnerID;
pH->GetParam(1, gunnerID);
m_pEnemyMGState->setGunnerID(gunnerID);
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getGunnerID(IFunctionHandler* pH)
{
return pH->EndFunction(m_pEnemyMGState->getGunnerID());
}
int CScriptObjectBlackboard::gunnerDied(IFunctionHandler* pH)
{
m_pEnemyMGState->gunnerDied();
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::gunnerAssigned(IFunctionHandler* pH)
{
bool ga = m_pEnemyMGState->gunnerAssigned();
return pH->EndFunction(ga);
}
//********************************
// Breach State Management
//********************************
int CScriptObjectBlackboard::setBreachDestination(IFunctionHandler* pH)
{
CHECK_PARAMETERS(2);
// Get the breachID
int breachID;
pH->GetParam(1, breachID);
// Get the destination string
const char *szDest = 0;
pH->GetParam(2, szDest);
string strDest(szDest);
std::map<int, CBreachCombatState*>::iterator iter = m_BreachCombatStates.find(breachID);
if (iter != m_BreachCombatStates.end())
{
iter->second->setDestination(strDest);
// Log the call
m_pGame->m_pLog->Log("Set destination for breach, id: \"%d\"", breachID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getBreachDestination(IFunctionHandler* pH)
{
CHECK_PARAMETERS(1);
// Get the breachID
int breachID;
pH->GetParam(1, breachID);
// Get the destination string
string strDest;
std::map<int, CBreachCombatState*>::iterator iter = m_BreachCombatStates.find(breachID);
if (iter != m_BreachCombatStates.end())
{
strDest = iter->second->getDestination();
// Log the call
m_pGame->m_pLog->Log("Got destination for breach, id: \"%d\"", breachID);
}
return pH->EndFunction(strDest.c_str());
}
int CScriptObjectBlackboard::getAllBreachesInPosn(IFunctionHandler* pH)
{
bool allInPosn = false;
// Iterate through all agents
std::map<int, CBreachCombatState*>::iterator iter;
if (!(m_BreachCombatStates.empty()))
{
int numInPosn = 0;
for (iter = m_BreachCombatStates.begin(); iter != m_BreachCombatStates.end(); iter++)
{
if (iter->second->getInPosn())
{
numInPosn++;
}
}
allInPosn = (numInPosn == m_BreachCombatStates.size());
}
// Log the call
int retVal = allInPosn ? 1 : 0;
m_pGame->m_pLog->Log("Returning getAllBreachesInPosn: \"%d\"", retVal);
return pH->EndFunction(allInPosn);
}
int CScriptObjectBlackboard::addBreachCombatState(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// Get the integer
int agentID;
pH->GetParam(1, agentID);
// See if a combat state with this key already exists; if so, erase it
std::map<int, CBreachCombatState*>::iterator iter = m_BreachCombatStates.find(agentID);
if (iter != m_BreachCombatStates.end())
{
delete iter->second;
m_BreachCombatStates.erase(iter);
// Log the call
m_pGame->m_pLog->Log("Added combat state for breach id: \"%d\"", agentID);
}
// Add the newly created combat state
CBreachCombatState* pCombatState = new CBreachCombatState(agentID, false);
m_BreachCombatStates.insert(std::make_pair(agentID, pCombatState));
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::removeBreachCombatState(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
// Get the integer
int agentID;
pH->GetParam(1, agentID);
std::map<int, CBreachCombatState*>::iterator iter = m_BreachCombatStates.find(agentID);
if (iter != m_BreachCombatStates.end())
{
delete iter->second;
m_BreachCombatStates.erase(iter);
// Log the call
m_pGame->m_pLog->Log("Deleted combat state for breach id: \"%d\"", agentID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::setBreachInPosn(IFunctionHandler* pH)
{
// Check that only two parameters were passed in
CHECK_PARAMETERS(2);
// Get the id
int breachID;
pH->GetParam(1, breachID);
// Get the flag
bool flag;
pH->GetParam(2, flag);
std::map<int, CBreachCombatState*>::iterator iter = m_BreachCombatStates.find(breachID);
if (iter != m_BreachCombatStates.end())
{
iter->second->setInPosn(flag);
// Log the call
m_pGame->m_pLog->Log("Updated combat state (in posn) for breach id: \"%d\"", breachID);
}
return pH->EndFunction(1);
}
int CScriptObjectBlackboard::getBreachInPosn(IFunctionHandler* pH)
{
// Check that only one parameter was passed in
CHECK_PARAMETERS(1);
bool result = false;
// Get the id
int breachID;
pH->GetParam(1, breachID);
std::map<int, CBreachCombatState*>::iterator iter = m_BreachCombatStates.find(breachID);
if (iter != m_BreachCombatStates.end())
{
result = iter->second->getInPosn();
// Log the call
m_pGame->m_pLog->Log("Got combat state (in Posn) for breach id: \"%d\"", breachID);
}
return pH->EndFunction(result);
}
