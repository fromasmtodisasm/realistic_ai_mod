#include "../CryGame/stdafx.h"
#include "CryStackWalker.h"

#if _MSC_VER >= 1300
#include <Tlhelp32.h>
#endif

//#include <Registry/Registry.h>

//#include "../build_info.h"

typedef std::map<DWORD,const char*> CodeDescMap;

struct CryStackWalkerInternal
{
	CodeDescMap mapCodeDesc;
	ILog*		pLog;
	//std::string sFCMMPath;
	const char *szGameMod;

	std::string sStackTrace;

	void SetGameMod(const char *szMod)
	{
		if (szMod && szMod[0])
		{
			szGameMod = szMod;
		}
		else
		{
			szGameMod = "Far Cry";
		}
	}

	/*void UpdateFCMMPath()
	{

		sFCMMPath.clear();

		CRegistry regFCMM(NULL);

		if (regFCMM.Open("SOFTWARE\\FC_MOD_Manager", HKEY_CURRENT_USER))
		{
			sFCMMPath += (std::string)regFCMM["szAppPath"];
			sFCMMPath += "\\FC MOD Manager.exe";

			regFCMM.Close();
		}
		else
		{
			pLog->LogWarning("CryStackWalker::Init: failed to open 'Far Cry Mod Manager' registry");
		}
	}*/

	#define ADD_CODE_DESCR_EX(code, desc) mapCodeDesc.insert(CodeDescMap::value_type(code, desc))
	#define ADD_CODE_DESCR(code) ADD_CODE_DESCR_EX(code, #code)

	void InitExeptionCodeMap()
	{
		ADD_CODE_DESCR(EXCEPTION_ACCESS_VIOLATION);
		ADD_CODE_DESCR(EXCEPTION_DATATYPE_MISALIGNMENT);
		ADD_CODE_DESCR(EXCEPTION_BREAKPOINT);
		ADD_CODE_DESCR(EXCEPTION_SINGLE_STEP);
		ADD_CODE_DESCR(EXCEPTION_ARRAY_BOUNDS_EXCEEDED);
		ADD_CODE_DESCR(EXCEPTION_FLT_DENORMAL_OPERAND);
		ADD_CODE_DESCR(EXCEPTION_FLT_DIVIDE_BY_ZERO);
		ADD_CODE_DESCR(EXCEPTION_FLT_INEXACT_RESULT);
		ADD_CODE_DESCR(EXCEPTION_FLT_INVALID_OPERATION);
		ADD_CODE_DESCR(EXCEPTION_FLT_OVERFLOW);
		ADD_CODE_DESCR(EXCEPTION_FLT_STACK_CHECK);
		ADD_CODE_DESCR(EXCEPTION_FLT_UNDERFLOW);
		ADD_CODE_DESCR(EXCEPTION_INT_DIVIDE_BY_ZERO);
		ADD_CODE_DESCR(EXCEPTION_INT_OVERFLOW);
		ADD_CODE_DESCR(EXCEPTION_PRIV_INSTRUCTION);
		ADD_CODE_DESCR(EXCEPTION_IN_PAGE_ERROR);
		ADD_CODE_DESCR(EXCEPTION_ILLEGAL_INSTRUCTION);
		ADD_CODE_DESCR(EXCEPTION_NONCONTINUABLE_EXCEPTION);
		ADD_CODE_DESCR(EXCEPTION_STACK_OVERFLOW);
		ADD_CODE_DESCR(EXCEPTION_INVALID_DISPOSITION);
		ADD_CODE_DESCR(EXCEPTION_GUARD_PAGE);
		ADD_CODE_DESCR(EXCEPTION_INVALID_HANDLE);
	}

#undef ADD_CODE_DESCR_EX
#undef ADD_CODE_DESCR

	const char *GetExceptionDescriptionWithCode(DWORD dwCode)
	{
		CodeDescMap::iterator itc = mapCodeDesc.find(dwCode);

		return itc != mapCodeDesc.end() ? itc->second : "Unknown";
	}

	void AddStackItem(LPCSTR szText)
	{
		sStackTrace += "\t";
		sStackTrace += szText;
	}

} CryStackWalkerGlobal;

void CryStackWalker::OnOutput(LPCSTR szText)
{
	CryStackWalkerGlobal.AddStackItem(szText);

	StackWalker::OnOutput(szText);
}

void CryStackWalker::Init(ILog *pLog, const char *szGameMod)
{
	CryStackWalkerGlobal.pLog = pLog;

	CryStackWalkerGlobal.SetGameMod(szGameMod);

	//CryStackWalkerGlobal.UpdateFCMMPath();

	CryStackWalkerGlobal.InitExeptionCodeMap();
}

/*bool CryStackWalker::ReportIssue(eReportType eType)
{
	std::string sArg;

	sArg += "--task=issue-report";
	sArg += " --mod-info=";
	sArg += CryStackWalkerGlobal.szGameMod;
	sArg += " --type=";

#define case_e(_type_) case eReport##_type_: sArg += #_type_; break

	switch(eType)
	{
		case_e(Other);
		case_e(Issue);
		case_e(Bug);
		case_e(Crash);
	}

#undef case_e

	if (eType == eReportCrash)
	{
		sArg += " --attachments=";
		sArg += CryStackWalkerGlobal.pLog->GetFileName();
		sArg += ";";
	}

	sArg += " --build-info=";
	sArg += BUILD_INFO_BRANCH;
	sArg += ":";
	sArg += BUILD_INFO_COMMIT;

	return CryRunProcess(CryStackWalkerGlobal.sFCMMPath.c_str(), sArg.c_str());
}*/

LONG WINAPI CryStackWalker::HandleException(EXCEPTION_POINTERS* pExp)
{
	CryStackWalkerGlobal.sStackTrace.clear();

	StackWalkerOutputVia(CryStackWalker)(GetCurrentThread(), pExp->ContextRecord);

	CryStackWalkerGlobal.pLog->Log("Exception.Code: %s", CryStackWalkerGlobal.GetExceptionDescriptionWithCode(pExp->ExceptionRecord->ExceptionCode));
	CryStackWalkerGlobal.pLog->Log("Exception.Address: %p", pExp->ExceptionRecord->ExceptionAddress);
	CryStackWalkerGlobal.pLog->Log("Exception.StackTrace: {\n%s}", CryStackWalkerGlobal.sStackTrace.c_str());

	//ReportIssue(eReportCrash);

	return EXCEPTION_EXECUTE_HANDLER;
}
