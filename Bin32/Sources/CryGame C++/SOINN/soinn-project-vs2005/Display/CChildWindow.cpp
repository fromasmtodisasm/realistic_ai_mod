#include "CChildWindow.h"
#include <string.h>

const char* CChildWindow::PROPNAME = "PROP:CHILDWND";

CChildWindow::CChildWindow(HWND hParentWnd, const char *windowClassName, const char *windowTitle, int width, int height)
{
	m_hParentWnd = hParentWnd;
	m_windowClassName = new char[sizeof(char)*(strlen(windowClassName)+1)];
	m_windowTitle     = new char[sizeof(char)*(strlen(windowTitle)+1)];
	m_width  = width;
	m_height = height;
	memcpy(m_windowClassName, windowClassName, sizeof(char)*(strlen(windowClassName)+1));
	memcpy(m_windowTitle,     windowTitle,     sizeof(char)*(strlen(windowTitle)+1));
}

CChildWindow::~CChildWindow()
{
	HINSTANCE hInstance;
	
	DestroyWindow(m_hWnd);
	hInstance = (HINSTANCE)GetWindowLong(m_hParentWnd, GWL_HINSTANCE);
	UnregisterClass(m_windowClassName, hInstance);
	
	if (m_windowClassName != NULL)
	{
		delete [] m_windowClassName;
		m_windowClassName = NULL;
	}
	if (m_windowTitle != NULL)
	{
		delete [] m_windowTitle;
		m_windowTitle = NULL;
	}
	
	m_hWnd = NULL;
}

BOOL CChildWindow::CreateChildWindow(void)
{
	HINSTANCE hInstance;
	WNDCLASS wc;
	
	hInstance = (HINSTANCE)GetWindowLong(m_hParentWnd, GWL_HINSTANCE);
	
	ZeroMemory(&wc, sizeof(WNDCLASS));
	wc.lpszClassName = m_windowClassName;
	wc.lpfnWndProc = (WNDPROC)StaticWndProc;
	wc.style = CS_DBLCLKS;
	wc.hInstance = hInstance;
	wc.hIcon = NULL;
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
	wc.lpszMenuName = NULL;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	
	if (!RegisterClass(&wc)) return FALSE;
	
	m_hWnd = CreateWindow(
		m_windowClassName,
		m_windowTitle,
		WS_OVERLAPPED | WS_TABSTOP | WS_THICKFRAME,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		m_width+GetSystemMetrics(SM_CXBORDER)*2,
		m_height+GetSystemMetrics(SM_CYCAPTION)+GetSystemMetrics(SM_CYBORDER)*2,
		m_hParentWnd,
		NULL,
		hInstance,
		(void*)this
		);
	
	if (m_hWnd == NULL) return FALSE;
	
	SetProp(m_hWnd, PROPNAME, (HANDLE)this);
	
	SendMessage(m_hWnd, WM_CREATE, 0, 0);
	ShowWindow(m_hWnd, SW_SHOW);
	UpdateWindow(m_hWnd);
	
	return TRUE;
}

HWND CChildWindow::GetWindowHandle(void)
{
	return m_hWnd;
}

LRESULT CALLBACK CChildWindow::StaticWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	CChildWindow* pChildWindow;
	LRESULT result;
	
	pChildWindow = (CChildWindow*)GetProp(hWnd, PROPNAME);

	if (pChildWindow != NULL)
	{
		result = pChildWindow->WndProc(hWnd, uMsg, wParam, lParam);
		if (uMsg == WM_DESTROY)
		{
			if (pChildWindow->m_hWnd != NULL)
			{
				DestroyWindow(pChildWindow->m_hWnd);
				RemoveProp(pChildWindow->m_hWnd, PROPNAME);
			}
		}
		return result;
	}

	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CALLBACK CChildWindow::WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch(uMsg)
	{
		case WM_CREATE:
			return OnCreate(hWnd, uMsg, wParam, lParam);
		case WM_SIZE:
			return OnSize(hWnd, uMsg, wParam, lParam);
		case WM_MOUSEMOVE:
			return OnMouseMove(hWnd, uMsg, wParam, lParam);
		case WM_MOUSEWHEEL:
			return OnMouseWheel(hWnd, uMsg, wParam, lParam);
		case WM_KEYDOWN:
			return OnKeyDown(hWnd, uMsg, wParam, lParam);
		case WM_PAINT:
			return OnPaint(hWnd, uMsg, wParam, lParam);
		case WM_DESTROY:
			return OnDestroy(hWnd, uMsg, wParam, lParam);
		default:
			break;
	}

	return OnMsg(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnCreate(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnSize(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnMouseMove(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnMouseWheel(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnKeyDown(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnPaint(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnDestroy(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

LRESULT CChildWindow::OnMsg(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return DefWindowProc(hWnd, uMsg, wParam, lParam);
}
