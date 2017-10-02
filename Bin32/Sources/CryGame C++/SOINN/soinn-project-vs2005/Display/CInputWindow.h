#ifndef _INPUT_WINDOW_HEADER_
#define _INPUT_WINDOW_HEADER_

#include "CChildWindow.h"
#include "CScreen.h"
#include <queue>

class CInputWindow : public CChildWindow
{
public:
	CInputWindow(HWND hOwnerWnd, const char *windowClassName, const char *windowTitle, int width, int height);
	~CInputWindow();
	void	AddSignal(const double x, const double y);
	void	Reset(void);
	bool	InitScreen(double x=0.0, double y=0.0, double zoom=1.0);
	bool	MoveScreen(int x, int y, double zoom=1.0);
	void	Refresh(void);
	void	Clear(void);
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
	struct sCoordinates
	{
		double x;
		double y;
	};
	std::queue<struct sCoordinates> m_signalQueue;
	CScreen*	m_pScreen;
	int			m_numSignal;
	double		m_centerX;
	double		m_centerY;
	double		m_zoom;

	static const COLORREF NODE_COLOR;
};

#endif
