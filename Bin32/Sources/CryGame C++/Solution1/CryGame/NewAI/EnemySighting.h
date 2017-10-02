//////////////////////////////////////////////////////////////////////
//
// SJD Source code
//
// File: EnemySighting.h
// Description: Abstraction of an enemy sighting record
//
// History:
// 18August2007: File created
//
//////////////////////////////////////////////////////////////////////
#ifndef _ENEMYSIGHTING_H_
#define _ENEMYSIGHTING_H_
class CEnemySighting
{
public:
//! Constructors
CEnemySighting( void ) : m_nEnemyId(0), m_position(Vec3(0.0, 0.0, 0.0)), m_bAlive(false) {}
CEnemySighting( int id, Vec3 posn, bool alive) : m_nEnemyId(id), m_position(posn),
m_bAlive(alive) {}
//! Destructor
virtual ~CEnemySighting( void ) {}
//! Sets the 'alive' state of an enemy
void setEnemyAlive(const bool alive);
//! Gets the 'alive' state of an enemy
bool getEnemyAlive();
//! Sets the position of an enemy
void setPosition(const Vec3 posn);
//! gets the position of an enemy
Vec3 getPosition();
private:
//! The enemy system id
int m_nEnemyId;
//! The last known position
Vec3 m_position;
//! The last known 'alive' status
bool m_bAlive;
};
#endif //_ENEMYSIGHTING_H_
