#ifndef _OUTPUT_WINDOW_HEADER_
#define _OUTPUT_WINDOW_HEADER_

#include "CChildWindow.h"
#include "CScreen.h"
#include "..\\SOINN\\CSOINN.h"
#include "..\\InputData\\CInputAdministrator.h"

const int MAX_COLOR = 16;

class COutputWindow : public CChildWindow
{
public:
	COutputWindow(HWND hParentWnd, const char *windowClassName, const char *windowTitle, int width, int height);
	~COutputWindow();
	bool	InitScreen(double x, double y, double zoom=1.0);
	bool	MoveScreen(int x=0.0, int y=0.0, double zoom=1.0);
	void	CreateColor(void);
	void	Refresh(CSOINN *pSOINN, CInputAdministrator *pInputAdministrator);
	void	Clear(void);
	bool	SetShowAcnode(bool showAcnode);
	int		GetScreenWidth(void);
	int		GetScreenHeight(void);
	bool	WriteBitmapFile(const char *fileName);

private:
	void TransrateToScreenCoordinates(double &x, double &y);
	LRESULT OnCreate(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT OnSize(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT OnMouseMove(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT OnMouseWheel(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT OnKeyDown(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT OnPaint(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT OnDestroy(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

private:
	CScreen*	m_pScreen;
	double		m_centerX;
	double		m_centerY;
	double		m_zoom;
	COLORREF	m_color[MAX_COLOR];
	bool		m_showAcnode;
};

#endif
