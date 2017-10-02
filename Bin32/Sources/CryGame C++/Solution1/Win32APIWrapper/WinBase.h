#ifndef __WINBASE_H
#define __WINBASE_H

#if defined(LINUX32)
	#include "Linux32Specific.h"
#elif defined(LINUX64)
	#include "Linux64Specific.h"
#else
	#include "LinuxSpecific.h"
#endif
#include "platform.h"
#include <asm/msr.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>
#include <aio.h>
#include <string.h>
#include <stdio.h>
#include <sys/time.h>
#include <time.h>
#include <errno.h>
#include <dirent.h>
#include <fnmatch.h>
#include <termios.h>
#include <pthread.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdlib.h>

static const char* scTimerEnvVarName = "FarCryT0";


#ifndef __cplusplus
	#ifndef bool
    typedef enum
    {
      false = 0,
      true = 1
    } _Bool;
    #define bool _Bool
	#endif
#endif

extern int errno;

/* Memory block identification */
#define _FREE_BLOCK      0
#define _NORMAL_BLOCK    1
#define _CRT_BLOCK       2
#define _IGNORE_BLOCK    3
#define _CLIENT_BLOCK    4
#define _MAX_BLOCKS      5

typedef struct tagRECT
{
	LONG    left;
	LONG    top;
	LONG    right;
	LONG    bottom;
} RECT, *PRECT;

#ifndef _FILETIME_
#define _FILETIME_
typedef struct _FILETIME
{
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
} FILETIME, *PFILETIME, *LPFILETIME;
#endif

typedef union _ULARGE_INTEGER
{
    struct
		{
        DWORD LowPart;
        DWORD HighPart;
    };
    unsigned long long QuadPart;
} ULARGE_INTEGER;

typedef ULARGE_INTEGER *PULARGE_INTEGER;

#ifdef __cplusplus
inline LONG CompareFileTime(const FILETIME *lpFileTime1, const FILETIME *lpFileTime2)
#else
static LONG CompareFileTime(const FILETIME *lpFileTime1, const FILETIME *lpFileTime2)
#endif
{
	const ULARGE_INTEGER u1 = *((const ULARGE_INTEGER*)(lpFileTime1));
	const ULARGE_INTEGER u2 = *((const ULARGE_INTEGER*)(lpFileTime2));
	if(u1.QuadPart < u2.QuadPart)
		return -1;
	else
	if(u1.QuadPart > u2.QuadPart)
		return 1;
	return 0;
}

#ifdef __cplusplus
BOOL GetFileTime(HANDLE hFile, LPFILETIME lpCreationTime, LPFILETIME lpLastAccessTime, LPFILETIME lpLastWriteTime);
#endif


typedef struct _SYSTEMTIME{
        WORD wYear;
        WORD wMonth;
        WORD wDayOfWeek;
        WORD wDay;
        WORD wHour;
        WORD wMinute;
        WORD wSecond;
        WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

typedef struct _TIME_FIELDS
{
	short Year;
  short Month;
  short Day;
  short Hour;
  short Minute;
  short Second;
  short Milliseconds;
  short Weekday;
} TIME_FIELDS, *PTIME_FIELDS;

#define DAYSPERNORMALYEAR  365
#define DAYSPERLEAPYEAR    366
#define MONSPERYEAR        12

bool TimeFieldsToTime(PTIME_FIELDS tfTimeFields, PLARGE_INTEGER Time);
BOOL SystemTimeToFileTime( const SYSTEMTIME *syst, LPFILETIME ft );

//console stuff
BOOL AllocConsole();
BOOL FreeConsole(); 
int kbhit();
int readch();
static const unsigned int MB_OK = 0;
static const unsigned int MB_ICONERROR = 0;
int MessageBox(void*, LPCSTR lpText, LPCSTR lpCaption, UINT);

//tell linux that we are about to quit, on some situation it crashed and this will force a abort call in case of a crash
static const char* gQuitEnvName = "OnQuit";

static void NotifySystemOnQuit()
{
	setenv(gQuitEnvName, "true",true);
}

static const bool IsOnQuit()
{
	const char *pOnQuitValue = getenv(gQuitEnvName);
	if(pOnQuitValue && strcmp(pOnQuitValue, "true") == 0)
		return true;
	return false;
}

//Win32API function declarations actually used 
bool IsBadReadPtr(void* ptr, unsigned int size );

#ifdef __cplusplus
inline bool SetFileAttributes(const char* lpFileName, DWORD attributes)
#else
static bool SetFileAttributes(const char* lpFileName, DWORD attributes)
#endif
{
	return (chmod ( lpFileName , S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IWGRP | S_IXGRP | S_IROTH | S_IWOTH | S_IXOTH ));
}

#define _chmod chmod 

char* strlwr (char * str);
char* strupr(char * str);
#define _strlwr	strlwr 
#define _strups	strupr

#ifndef __TRLTOA__
#define __TRLTOA__
char *ltoa ( long i , char *a , int radix );
#endif
#define itoa ltoa

void _makepath(char * path, const char * drive, const char *dir, const char * filename, const char * ext);
void _splitpath(const char* inpath, char * drv, char * dir, char* fname, char * ext);
char* _fullpath(char *, const char *, unsigned int );

#ifdef __cplusplus
	inline const double __rdtsc(){unsigned int L, H; rdtsc( L, H );	return ((double)L +  4294967296.0 * (double)H);}
#else
	static const double __rdtsc(){unsigned int L, H; rdtsc( L, H );	return ((double)L +  4294967296.0 * (double)H);}
#endif

// winapi stuff
static void OutputDebugString ( const char* lpOutputString )
{
#if !defined(NDEBUG)
	printf(lpOutputString);
#endif	
}
static void DebugBreak(){}

//critical section stuff
#define pthread_attr_default NULL

typedef pthread_mutex_t CRITICAL_SECTION;
#ifdef __cplusplus
	inline void InitializeCriticalSection(CRITICAL_SECTION *lpCriticalSection)
	{
		pthread_mutexattr_t pthread_mutexattr_def;
		pthread_mutexattr_settype(&pthread_mutexattr_def, PTHREAD_MUTEX_RECURSIVE_NP);
		pthread_mutex_init(lpCriticalSection, &pthread_mutexattr_def);
	}
	inline void EnterCriticalSection(CRITICAL_SECTION *lpCriticalSection){pthread_mutex_lock(lpCriticalSection);}
	inline void LeaveCriticalSection(CRITICAL_SECTION *lpCriticalSection){pthread_mutex_unlock(lpCriticalSection);}
	inline void DeleteCriticalSection(CRITICAL_SECTION *lpCriticalSection){}
#else
	static void InitializeCriticalSection(CRITICAL_SECTION *lpCriticalSection)
	{
		pthread_mutexattr_t pthread_mutexattr_def;
		pthread_mutexattr_settype(&pthread_mutexattr_def, PTHREAD_MUTEX_RECURSIVE_NP);
		pthread_mutex_init(lpCriticalSection, &pthread_mutexattr_def);
	}
	static void EnterCriticalSection(CRITICAL_SECTION *lpCriticalSection){pthread_mutex_lock(lpCriticalSection);}
	static void LeaveCriticalSection(CRITICAL_SECTION *lpCriticalSection){pthread_mutex_unlock(lpCriticalSection);}
	static void DeleteCriticalSection(CRITICAL_SECTION *lpCriticalSection){}
#endif

bool QueryPerformanceCounter(LARGE_INTEGER *counter);
bool QueryPerformanceFrequency(LARGE_INTEGER *frequency);

DWORD GetTickCount();
#define GetCurrentTime GetTickCount
#define timeGetTime GetTickCount

void GetLocalTime( LPSYSTEMTIME systime );

typedef struct stat __stat;
typedef struct stat64 __stat64;
#define _fstat64 fstat64

#define INVALID_FILE_ATTRIBUTES			((DWORD)-1)
#define FILE_ATTRIBUTE_READONLY     1
#define FILE_ATTRIBUTE_NORMAL       0x00000080
#define FILE_ATTRIBUTE_DIRECTORY    0x00000010
DWORD GetFileAttributes(LPCSTR lpFileName);
int _mkdir(const char *dirname);


//begin--------------------------------findfirst/-next declaration/implementation----------------------------------------------------

#define _A_RDONLY       0x01    /* Read only file */
#define _A_SUBDIR       0x10    /* Subdirectory */

#ifdef __cplusplus

inline int _findclose(intptr_t handle){return 0;}//nothing to do, does everything in the class destructor and calls to findfirst
inline BOOL FindClose(HANDLE handle){return 0;}//nothing to do, does everything in the class destructor and calls to findfirst
//!< is actually a class but we should be able to instantiate it with struct __finddata64_t ...
//!< implements the functionality behind findfirst and findnext
typedef struct __finddata64_t
{
	//!< atributes set by find request
  unsigned    int attrib;			//!< attributes, only directory and readonly flag actually set
  u64					time_create;		//!< creation time, cannot parse under linux, last modification time is used instead (game does nowhere makes decision based on this values)
  u64					time_access;		//!< last access time
  u64					time_write;			//!< last modification time
  u64					size;						//!< file size (for a directory it will be the block size)
  char        name[256];			//!< file/directory name

private:
	int										m_LastIndex;					//!< last index for findnext
	string								m_DirectoryName;			//!< directory name, needed when getting file attributes on the fly
	string								m_ToMatch;						//!< pattern to match with
	DIR										*m_pDir;							//!< directory to work in
	std::vector<string>		m_Entries;						//!< all file entries in the current directories
public:

	inline __finddata64_t(): attrib(0), time_create(0), time_access(0), time_write(0), size(0), m_LastIndex(-1), m_pDir(NULL)
	{
		memset(name, '0', 256);	
	}
	inline ~__finddata64_t(){if(m_pDir != NULL){ closedir(m_pDir);m_pDir = NULL;}}//!< destructor closes direcory handle

	//!< wildcard pattern matcher using fnmatch
	inline const bool PatternMatcher(const string& cName)const
	{
		const char *p = m_ToMatch.c_str();
		const char *f = cName.c_str();
		if(fnmatch(p, f, FNM_LEADING_DIR | FNM_CASEFOLD ) == 0)
		{
			return true;
		}
		return false;
	}

	//!< copies and retrieves the data for an actual match (to not waste any effort retrioeving data for unused files)
	void CopyFoundData(const string& rMatchedFileName);

public:
	//!< global _findfirst64 function using struct above, can't be a member function due to required semantic match
	friend intptr_t _findfirst64(const char *pFileName, __finddata64_t *pFindData);
	//!< global _findnext64 function using struct above, can't be a member function due to required semantic match
	friend int _findnext64(intptr_t last, __finddata64_t *pFindData);
}__finddata64_t;

typedef struct _finddata_t : public __finddata64_t
{}_finddata_t;//!< need inheritance since in many places it get used as struct _finddata_t

int _findnext64(intptr_t last, __finddata64_t *pFindData);
intptr_t _findfirst64(const char *pFileName, __finddata64_t *pFindData);
#endif
//end--------------------------------findfirst/-next declaration/implementation----------------------------------------------------


#define Int32x32To64( a, b ) (LONGLONG)((LONGLONG)(LONG)(a) * (LONG)(b))
#define UInt32x32To64( a, b ) (ULONGLONG)((ULONGLONG)(DWORD)(a) * (DWORD)(b))

int memicmp( LPCSTR s1, LPCSTR s2, DWORD len );
char * _ui64toa(unsigned long long value,	char *str, int radix);
long long _atoi64( char *str );

typedef struct _MEMORYSTATUS
{
    DWORD dwLength;
    DWORD dwMemoryLoad;
    SIZE_T dwTotalPhys;
    SIZE_T dwAvailPhys;
    SIZE_T dwTotalPageFile;
    SIZE_T dwAvailPageFile;
    SIZE_T dwTotalVirtual;
    SIZE_T dwAvailVirtual;
} MEMORYSTATUS, *LPMEMORYSTATUS;
void GlobalMemoryStatus(LPMEMORYSTATUS lpmem);

#ifdef __cplusplus
inline int closesocket(SOCKET hSocket)
#else
static int closesocket(SOCKET hSocket)
#endif
{
	return close(hSocket);
}

BOOL GetUserName(LPSTR lpBuffer, LPDWORD nSize);

//error code stuff
//not thread specific, just a coarse implementation for the main thread
static DWORD gErrCode = 0;
#ifdef __cplusplus
	inline DWORD GetLastError(){return errno;}
	inline void SetLastError(DWORD dwErrCode){errno = dwErrCode;}
#else
	static DWORD GetLastError(){return errno;}
	static void SetLastError(DWORD dwErrCode){errno = dwErrCode;}
#endif
#define WSAGetLastError GetLastError

//simulate CreateFile-funcionality for calls: HANDLE hFile = CreateFile (szFilePath, GENERIC_READ, FILE_SHARE_READ|FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL)
//all other calls might go wrong
#define GENERIC_READ							(0x80000000L)
#define FILE_SHARE_READ						0x00000001
#define FILE_SHARE_WRITE					0x00000002
#define OPEN_EXISTING							3
#define FILE_FLAG_OVERLAPPED			0x40000000
#define INVALID_FILE_SIZE					((DWORD)0xFFFFFFFFl)
#define FILE_BEGIN								0
#define FILE_CURRENT							1
#define FILE_END									2
#define ERROR_NO_SYSTEM_RESOURCES 1450L
#define ERROR_INVALID_USER_BUFFER	1784L
#define ERROR_NOT_ENOUGH_MEMORY   8L
#define FILE_FLAG_SEQUENTIAL_SCAN 0x08000000

#ifdef __cplusplus

inline void RemoveCRLF(string& rString)//removes carriage return and line feed introduced by opening text files in binary mode
{
	if(rString.size() == 0)
		return;
	string::size_type loc = 0; 
	while((loc = rString.find( "\r", loc)) != string::npos)
	{
		rString.replace(loc, 1, "");
	}
	loc = 0;
	while((loc = rString.find( "\n", loc)) != string::npos)
	{
		rString.replace(loc, 1, "");
	}
	if(rString.c_str()[rString.size()-1] == ' ')
	{
		rString.replace(rString.size()-1,1,"");
	}
}

inline void RemoveCRLF(const char *pString)//removes carriage return and line feed introduced by opening text files in binary mode
{
	char* pS = (char*)pString;
	unsigned int strLength = strlen(pS);
	if(strLength == 0)
		return;
	if(pS[strLength-1] == '\r' || pS[strLength-1] == '\n' )
		pS[--strLength] = '\0';
	if(pS[strLength-1] == '\r' || pS[strLength-1] == '\n' )
		pS[--strLength] = '\0';
	if(pS[strLength-1] == ' ')
		pS[--strLength] = '\0';
}


namespace NAsyncFileAccess
{
	class CAsyncFileAccess
	{
	protected:
		std::map<HANDLE, std::pair<aiocb*, LPOVERLAPPED> > m_CurrentFileAsyncIOOps;
	public:
		HANDLE CreateFile(
				LPCSTR lpFileName,
				DWORD dwDesiredAccess,
				DWORD dwShareMode,
				LPSECURITY_ATTRIBUTES lpSecurityAttributes,
				DWORD dwCreationDisposition,
				DWORD dwFlagsAndAttributes,
				HANDLE hTemplateFile );
		BOOL CloseHandle(HANDLE& hObject);
		DWORD GetFileSize(HANDLE hFile, LPDWORD lpFileSizeHigh);
		BOOL CancelIo(HANDLE hFile);
		BOOL GetOverlappedResult(HANDLE hFile, LPOVERLAPPED lpOverlapped, LPDWORD lpNumberOfBytesTransferred, BOOL bWait);
		BOOL ReadFileEx(HANDLE hFile, LPVOID lpBuffer, DWORD nNumberOfBytesToRead, LPOVERLAPPED lpOverlapped, LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine);

		~CAsyncFileAccess();
	};

	//delegations
	HANDLE CreateFile(
			LPCSTR lpFileName,
			DWORD dwDesiredAccess,
			DWORD dwShareMode,
			LPSECURITY_ATTRIBUTES lpSecurityAttributes,
			DWORD dwCreationDisposition,
			DWORD dwFlagsAndAttributes,
			HANDLE hTemplateFile );

	DWORD GetFileSize(HANDLE hFile, LPDWORD lpFileSizeHigh);
	BOOL CancelIo(HANDLE hFile);
	BOOL GetOverlappedResult(HANDLE hFile, LPOVERLAPPED lpOverlapped, LPDWORD lpNumberOfBytesTransferred, BOOL bWait);
	BOOL ReadFileEx(HANDLE hFile, LPVOID lpBuffer, DWORD nNumberOfBytesToRead, LPOVERLAPPED lpOverlapped, LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine);

	DWORD SetFilePointer(HANDLE hFile, LONG lDistanceToMove, PLONG lpDistanceToMoveHigh, DWORD dwMoveMethod);
	BOOL ReadFile(HANDLE hFile, LPVOID lpBuffer, DWORD nNumberOfBytesToRead, LPDWORD lpNumberOfBytesRead, LPOVERLAPPED lpOverlapped);
	//signal handler for async reading
	static void SignalCallback(sigval_t t);
}

using namespace NAsyncFileAccess;

namespace NThreads
{
	typedef CHandle<pthread_t, 0xFFFFFFFFl> THREAD_HANDLE;
	typedef pthread_cond_t *EVENT_HANDLE;//pointer since is must not be copied and always address is required

	#define STATUS_WAIT_0                   ((DWORD   )0x00000000L)
	#define STATUS_ABANDONED_WAIT_0         ((DWORD   )0x00000080L)
	#define WAIT_OBJECT_0										((STATUS_WAIT_0 ) + 0 )
	#define WAIT_TIMEOUT										258L
	#define WAIT_ABANDONED									((STATUS_ABANDONED_WAIT_0 ) + 0 )
	#define INFINITE						            0xFFFFFFFFl  // Infinite timeout

	//create map with assignment of HANDLES and void(this)-pointers
	typedef void* (*PTHREAD_START_ROUTINE)(LPVOID lpThreadParameter);
	typedef PTHREAD_START_ROUTINE LPTHREAD_START_ROUTINE;

	//class managing all thread accesses and administration
	//id and thread handle are the same, two maps are used to keep it fully associative
	//pay attention that bAlertable is not supported, dunno exactly what the consequences for that will be...
	//should actually be a singleton
	class CThreadManager
	{
	public:
		inline CThreadManager()
		{
			pthread_mutexattr_t pthread_mutexattr_def;
			pthread_mutexattr_settype(&pthread_mutexattr_def, PTHREAD_MUTEX_RECURSIVE);
			pthread_mutex_init(&m_Mutex, &pthread_mutexattr_def);//init mutex to be used in all functions
			pthread_mutex_init(&m_GlobalMutex, &pthread_mutexattr_def);//init mutex to be used in all namespace functions
		}

		inline ~CThreadManager()
		{
			pthread_mutex_lock(&m_Mutex);
			for(std::map<THREAD_HANDLE, void*>::iterator iter = m_ThreadMap.begin(); iter != m_ThreadMap.end(); ++iter)
			{
				pthread_kill((iter->first).Handle(), SIGKILL);
			}
			m_ThreadMap.clear(); 
			pthread_mutex_unlock(&m_Mutex);
		}

		BOOL CloseHandle(THREAD_HANDLE& hThread);
		THREAD_HANDLE CreateThread(LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter);

		pthread_mutex_t& GlobalMutex(); 

	private:
		pthread_mutex_t m_GlobalMutex; //to be used in other functions having a central initializer

		pthread_mutex_t m_Mutex;//mutex variable to this shared resource
		std::map<THREAD_HANDLE, void*> m_ThreadMap; //keeps track of active threads and caller source
	};

	static DWORD SleepEx(DWORD dwMilliseconds, BOOL)
	{
		struct timespec delay;
		delay.tv_sec = dwMilliseconds / 1000;
    delay.tv_nsec = (dwMilliseconds % 1000)*1000000;//specify in nanoseconds
		nanosleep(&delay, NULL);
		return 0;
	}; 

	static void Sleep( unsigned int t )
	{
		SleepEx(t, false);
	}

	BOOL					SetEvent(EVENT_HANDLE hEvent);
	EVENT_HANDLE	CreateEvent(LPSECURITY_ATTRIBUTES lpEventAttributes, BOOL bManualReset, BOOL bInitialState, LPCSTR lpName);
	DWORD					WaitForSingleObject(EVENT_HANDLE hHandle, DWORD dwMilliseconds);	//use pthread_cond_init and -_wait
	DWORD					WaitForSingleObject(THREAD_HANDLE hHandle, DWORD dwMilliseconds);	//use pthread_cond_init and -_wait
	DWORD					WaitForSingleObjectEx(EVENT_HANDLE hHandle, DWORD dwMilliseconds, BOOL bAlertable);
	DWORD					WaitForSingleObjectEx(THREAD_HANDLE hHandle, DWORD dwMilliseconds, BOOL bAlertable);
	BOOL					ResetEvent(EVENT_HANDLE hEvent);
	BOOL					CloseHandle(EVENT_HANDLE cHandle);

	THREAD_HANDLE CreateThread(LPSECURITY_ATTRIBUTES lpThreadAttributes, SIZE_T dwStackSize, LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter, DWORD dwCreationFlags, LPDWORD lpThreadId);
	inline DWORD GetCurrentThreadId(){return (DWORD)pthread_self();}
}

using namespace NThreads; 
 
 
BOOL CloseHandle(HANDLE& hObject);

BOOL CloseHandle(THREAD_HANDLE& hObject);

//case insensitive fopen
FILE *fopen_nocase(const char *file, const char *mode);
//helper function
const bool getFilenameNoCase(const char *file, string& rAdjustedFilename, const bool cCreateNew = false);
void adaptFilenameToLinux(string& rAdjustedFilename);
const int comparePathNames(const char* cpFirst, const char* cpSecond, const unsigned int len);//returns 0 if identical
void replaceDoublePathFilename(char *szFileName);//removes "\.\" to "\" and "/./" to "/"

const BOOL compareTextFileStrings(const char* cpReadFromFile, const char* cpToCompareWith);

//case insensitive opendir
DIR *opendir_nocase(const char *dir);
DIR *opendir_nocase(const char *dir, string& sRealDirName, const bool cDoOpen = true);

//force usage of case insensitive fopen
#define fopen fopen_nocase

inline BOOL DeleteFile(LPCSTR lpFileName)
{
	string adjustedFilename(lpFileName);
	getFilenameNoCase(lpFileName, adjustedFilename);
	return (unlink(adjustedFilename.c_str()) == 0);
}

inline BOOL RemoveDirectory(LPCSTR lpPathName)
{
	string adjustedPathname(lpPathName);
	opendir_nocase(lpPathName, adjustedPathname, false);
	return (rmdir(adjustedPathname.c_str()) == 0);
}

inline DWORD GetCurrentDirectory( DWORD nBufferLength, char* lpBuffer )
{
	if (getcwd (lpBuffer, nBufferLength) == lpBuffer)
		return TRUE;
	return FALSE;
}

inline BOOL SetCurrentDirectory(LPCSTR lpPathName) 
{
	if(chdir(lpPathName) != 0)
	{
		string adjustedPathname(lpPathName);
		opendir_nocase(lpPathName, adjustedPathname, false);
		return(chdir(adjustedPathname.c_str()) == 0);
	}
	else
	return FALSE;
}

BOOL MakeSureDirectoryPathExists(PCSTR DirPath);

DWORD GetPrivateProfileString(const char* lpAppName, const char* lpKeyName, const char* lpDefault, char* lpReturnedString, DWORD nSize, const char* lpFileName);

//internet related stuff
typedef LPVOID HINTERNET;
#define INTERNET_OPEN_TYPE_PRECONFIG 0						// use registry configuration
#define INTERNET_FLAG_HYPERLINK      0x00000400		// asking wininet to do hyperlinking semantic which works right for scripts
#define INTERNET_FLAG_NO_CACHE_WRITE 0x04000000
#define INTERNET_FLAG_NO_COOKIES 0x00080000
#define INTERNET_FLAG_NO_UI 0x00000200
#define INTERNET_FLAG_RELOAD 0x80000000
#define HTTP_QUERY_CONTENT_LENGTH 5
bool InternetCloseHandle(HINTERNET hInternet);
HINTERNET InternetOpenUrl(HINTERNET hInternet, const char* lpszUrl, const char* lpszHeaders, DWORD dwHeadersLength, DWORD dwFlags, DWORD_PTR dwContext);
HINTERNET InternetOpen(const char* lpszAgent, DWORD dwAccessType, const char* lpszProxy, const char* lpszProxyBypass, DWORD dwFlags);
bool InternetCloseHandle(HINTERNET hInternet);
bool InternetReadFile(HINTERNET hFile, LPVOID lpBuffer, DWORD dwNumberOfBytesToRead, LPDWORD lpdwNumberOfBytesRead);
bool HttpQueryInfo( HINTERNET hRequest, DWORD dwInfoLevel, LPVOID lpvBuffer, LPDWORD lpdwBufferLength, LPDWORD lpdwIndex);
// don't think this is actually used
inline int InternetSetStatusCallback( HINTERNET hInternet, int lpfnInternetCallback ) { return 0; }



#endif //__cplusplus

#endif // __WINBASE_H



