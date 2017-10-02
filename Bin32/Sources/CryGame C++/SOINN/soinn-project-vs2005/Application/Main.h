#ifndef _MAIN_HEADER_
#define _MAIN_HEADER_

#include <windows.h>
#include <tchar.h>

LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
void InitWindowClass(HINSTANCE hInstance, WNDCLASS &WndClass, const char *className);
void OnCreate(HWND hWnd);
void OnCommand(HWND hWnd, int msg);
void OnPaint(HWND hWnd);
void OnKeyDown(HWND hWnd, UINT keyCode, BOOL shiftDown);
void OnMenuInputStop(BOOL checked);
void OnChangeInput(HWND hWnd, int msg);
void OnMessageLoop(HWND hWnd);
void OnExitMessageLoop(void);
void CreateOpenFileNameInfo(OPENFILENAME *openFileName, const HWND hWnd, char *fileName, const int fileNameLength, LPCSTR filter);
TCHAR *GetAppPath(void);

#endif
