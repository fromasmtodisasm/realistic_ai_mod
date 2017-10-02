#ifndef _CHILD_WINDOW_HEADER_
#define _CHILD_WINDOW_HEADER_

#define _WIN32_WINNT 0x0400
#include <windows.h>

class CChildWindow
{
public:
	CChildWindow(HWND hParentWnd, const char *windowClassName, const char *windowTitle, int width, int height);
	~CChildWindow();
	BOOL CreateChildWindow(void);
	HWND GetWindowHandle(void);

protected:
	static	LRESULT CALLBACK StaticWndProc(HWND hWnd, UINT uMsg,WPARAM wParam, LPARAM lParam);
	LRESULT CALLBACK WndProc(HWND hWnd,UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnCreate(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnSize(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnMouseMove(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnMouseWheel(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnKeyDown(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnPaint(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnDestroy(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	virtual LRESULT OnMsg(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

protected:
	HWND	m_hWnd;
	HWND	m_hParentWnd;
	int		m_width;
	int		m_height;
	char*	m_windowClassName;
	char*	m_windowTitle;
	static const char *PROPNAME;
};

#endif
