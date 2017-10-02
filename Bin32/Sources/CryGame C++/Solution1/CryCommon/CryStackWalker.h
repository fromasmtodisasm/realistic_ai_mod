#pragma once

#ifndef USE_STACK_WALKER
#define CryStackWalkerBegin(_block_) {_block_
#define CryStackWalkerEnd(_block_)  _block_ }
#else

#define CryStackWalkerBegin(_block_) {_block_ CryStackWalkerTry
#define CryStackWalkerEnd(_block_) CryStackWalkerCatch { } _block_ }
#endif


#define CryStackWalkerBlock(_block_) CryStackWalkerBegin(;) _block_ CryStackWalkerEnd(;)
#define CryStackWalkerCallFunction(_f_) CryStackWalkerBlock({_f_;});

#define CryStackWalkerTry __try
#define CryStackWalkerCatch __except (CryStackWalker::HandleException(GetExceptionInformation()))

#include <StackWalker.h>
#include <tchar.h>


struct ILog;

class CryStackWalker : public StackWalker
{
public:

	enum eReportType
	{
		eReportOther = 0,
		eReportIssue = 1,
		eReportBug = 2,
		eReportCrash = 3
	};

	CryStackWalker () : StackWalker(StackWalkOptions::RetrieveLine) {}

	CryStackWalker (DWORD dwProcessId, HANDLE hProcess) : StackWalker (dwProcessId, hProcess) {}

	virtual void OnOutput(LPCSTR szText);

	virtual void OnDbgHelpErr(LPCSTR szFuncName, DWORD gle, DWORD64 addr) { }

	static void Init(ILog *pLog, const char *szGameMod);

	//static bool ReportIssue(eReportType eType);

	static LONG WINAPI HandleException(EXCEPTION_POINTERS* pExp);
};
