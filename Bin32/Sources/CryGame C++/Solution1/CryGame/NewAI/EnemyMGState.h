//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: EnemyMGState.h
// Description: Abstraction of the state of an enemy machine gunner
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#ifndef _ENEMYMGSTATE_H_
#define _ENEMYMGSTATE_H_
class CEnemyMGState
{
public:
//! Constructors
CEnemyMGState( void ) : m_nCurrentGunnerId(0) {}
CEnemyMGState( int id) : m_nCurrentGunnerId(id){}
//! Destructor
virtual ~CEnemyMGState( void ) {}
//! Sets the id of the current gunner
void setGunnerID(const int id);
//! Gets the id of the current gunner
int getGunnerID();
//! Resets the gunner state
void gunnerDied();
//! Gets whether a gunner is currently assigned
bool gunnerAssigned();
private:
//! The agent id
int m_nCurrentGunnerId;
};
#endif //_ENEMYMGSTATE_H_
