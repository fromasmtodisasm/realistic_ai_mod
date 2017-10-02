//////////////////////////////////////////////////////////////////////
//
//	validator header
//	
//	File: utils.h
//	Description : Validator specification outsorced from utils.h
//
//	History:
//	-:Created by Michael Glueck
//
//////////////////////////////////////////////////////////////////////

#ifndef validator_h
#define validator_h

template<class dtype> bool is_valid(const dtype &op) { return is_valid(op|op); }

inline bool is_valid(float op) { return op*op>=0 && op*op<1E30f; }
inline bool is_valid(int op) { return true; }
inline bool is_valid(unsigned int op) { return true; }


#define VALIDATOR_LOG(pLog,str) pLog->Log(str) //OutputDebugString(str)
#define VALIDATORS_START bool validate( const char *strSource, ILog *pLog, const vectorf &pt,\
	IPhysicsStreamer *pStreamer, void *param0, int param1, int param2 ) { bool res=true; char errmsg[256];
#define VALIDATOR(member) if (!is_unused(member) && !is_valid(member)) { \
	res=false; sprintf(errmsg,"\002%s: (%.50s @ %.1f,%.1f,%.1f) Validation Error: %s is invalid",strSource,\
		pStreamer->GetForeignName(param0,param1,param2),pt.x,pt.y,pt.z,#member); \
	VALIDATOR_LOG(pLog,errmsg); } 
#define VALIDATOR_NORM(member) if (!is_unused(member) && !(is_valid(member) && fabs_tpl((member|member)-1.0f)<0.01f)) { \
	res=false; sprintf(errmsg,"\002%s: (%.50s @ %.1f,%.1f,%.1f) Validation Error: %s is invalid or unnormalized",\
	strSource,pStreamer->GetForeignName(param0,param1,param2),pt.x,pt.y,pt.z,#member); VALIDATOR_LOG(pLog,errmsg); }
#define VALIDATOR_NORM_MSG(member,msg,member1) if (!is_unused(member) && !(is_valid(member) && fabs_tpl((member|member)-1.0f)<0.01f)) { \
	res=false; sprintf(errmsg,"\002%s: (%.50s @ %.1f,%.1f,%.1f) Validation Error: %s is invalid or unnormalized %s",\
	strSource,pStreamer->GetForeignName(param0,param1,param2),pt.x,pt.y,pt.z,#member,msg); \
	if (!is_unused(member1)) sprintf(errmsg+strlen(errmsg)," "#member1": %.1f,%.1f,%.1f",member1.x,member1.y,member1.z); \
	VALIDATOR_LOG(pLog,errmsg); }
#define VALIDATOR_RANGE(member,minval,maxval) if (!is_unused(member) && !(is_valid(member) && member>=minval && member<=maxval)) { \
	res=false; sprintf(errmsg,"\002%s: (%.50s @ %.1f,%.1f,%.1f) Validation Error: %s is invalid or out of range",\
	strSource,pStreamer->GetForeignName(param0,param1,param2),pt.x,pt.y,pt.z,#member); VALIDATOR_LOG(pLog,errmsg); }
#define VALIDATOR_RANGE2(member,minval,maxval) if (!is_unused(member) && !(is_valid(member) && member*member>=minval*minval && \
		member*member<=maxval*maxval)) { \
	res=false; sprintf(errmsg,"\002%s: (%.50s @ %.1f,%.1f,%.1f) Validation Error: %s is invalid or out of range",\
	strSource,pStreamer->GetForeignName(param0,param1,param2),pt.x,pt.y,pt.z,#member); VALIDATOR_LOG(pLog,errmsg); }
#define VALIDATORS_END return res; }

#define ENTITY_VALIDATE(strSource,pStructure) if (!pStructure->validate(strSource,m_pWorld->m_pLog,m_pos,\
	m_pWorld->m_pPhysicsStreamer,m_pForeignData,m_iForeignData,m_iForeignFlags)) { \
	if (m_pWorld->m_vars.bBreakOnValidation) DoBreak return 0; }
#define ENTITY_VALIDATE_ERRCODE(strSource,pStructure,iErrCode) if (!pStructure->validate(strSource,m_pWorld->m_pLog,m_pos, \
	m_pWorld->m_pPhysicsStreamer,m_pForeignData,m_iForeignData,m_iForeignFlags)) { \
	if (m_pWorld->m_vars.bBreakOnValidation) DoBreak return iErrCode; }

#endif //validator_h