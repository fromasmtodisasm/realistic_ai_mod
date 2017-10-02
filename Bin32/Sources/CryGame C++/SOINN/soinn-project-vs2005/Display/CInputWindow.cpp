#include "CInputWindow.h"
#include <math.h>

const COLORREF CInputWindow::NODE_COLOR = RGB(96, 80, 128);

CInputWindow::CInputWindow(HWND hParentWnd, const char *windowClassName, const char *windowTitle, int width, int height) : CChildWindow(hParentWnd, windowClassName, windowTitle, width, height)
{
	m_numSignal = 0;
	m_centerX = 0.0;
	m_centerY = 0.0;
	m_zoom = 1.0;
	m_width = width;
	m_height = height;
	m_pScreen = new CScreen(width, height, 24);
}

CInputWindow::~CInputWindow()
{
	while (!m_signalQueue.empty())
	{
		m_signalQueue.pop();
	}
	if (m_pScreen != NULL)
	{
		delete m_pScreen;
		m_pScreen = NULL;
	}
}

void CInputWindow::AddSignal(const double x, const double y)
{
	struct sCoordinates coordinates;
	
	m_numSignal++;

	coordinates.x = x;
	coordinates.y = y;
	m_signalQueue.push(coordinates);
}

void CInputWindow::Reset(void)
{
	m_numSignal = 0;
	while (!m_signalQueue.empty())
	{
		m_signalQueue.pop();
	}
	m_pScreen->Clear();
}

bool CInputWindow::InitScreen(double x/*=0.0*/, double y/*=0.0*/, double zoom/*=1.0*/)
{
	if (zoom <= 0.0) return false;

	m_centerX = x;
	m_centerY = y;
	m_zoom = zoom;

	return true;
}

bool CInputWindow::MoveScreen(int x, int y, double zoom/*=1.0*/)
{
	if (zoom <= 0.0) return false;

	m_centerX -= (double)x/m_zoom;
	m_centerY -= (double)y/m_zoom;
	m_zoom *= zoom;

	return true;
}

void CInputWindow::Refresh(void)
{
	struct sCoordinates coordinates;
	char buf[128];
	
	m_pScreen->Clear();

	while (!m_signalQueue.empty())
	{
		coordinates = m_signalQueue.front();
		TransrateToScreenCoordinates(coordinates.x, coordinates.y);
		m_pScreen->DrawNode((int)coordinates.x, (int)coordinates.y, NODE_COLOR);
		m_signalQueue.pop();
	}

	sprintf(buf, "Input : %d", m_numSignal);
	m_pScreen->DrawText(buf, 5, 5, true);
	
	InvalidateRect(m_hWnd, NULL, false);
	SendMessage(m_hWnd, WM_PAINT, 0, 0);
}

void CInputWindow::Clear(void)
{
	while (!m_signalQueue.empty())
	{
		m_signalQueue.pop();
	}
	m_pScreen->Clear();
}

int CInputWindow::GetScreenWidth(void)
{
	return m_pScreen->GetScreenWidth();
}

int CInputWindow::GetScreenHeight(void)
{
	return m_pScreen->GetScreenHeight();
}

bool CInputWindow::WriteBitmapFile(const char *fileName)
{
	return m_pScreen->WriteBitmapFile(fileName);
}

void CInputWindow::TransrateToScreenCoordinates(double &x, double &y)
{
	x -= m_centerX;
	y -= m_centerY;
	x *= m_zoom;
	y *= m_zoom;
	x += m_pScreen->GetScreenWidth()/2;
	y += m_pScreen->GetScreenHeight()/2;
}

LRESULT CInputWindow::OnCreate(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return 0L;
}

LRESULT CInputWindow::OnSize(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	int width, height;

	switch (wParam)
	{
	case SIZE_RESTORED:
	case SIZE_MAXIMIZED:
	case SIZE_MAXSHOW:
		width = (int)LOWORD(lParam);
		height = (int)HIWORD(lParam);
		m_pScreen->ChangeSize(width, height);
		break;
	default:
		break;
	}

	return 0L;
}

LRESULT CInputWindow::OnMouseMove(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	static int previousX = -1, previousY = -1;
	int moveX, moveY;

	if (wParam == MK_LBUTTON)
	{
		if (previousX != -1 && previousY != -1)
		{
			moveX = LOWORD(lParam)-previousX;
			moveY = HIWORD(lParam)-previousY;
			MoveScreen(moveX, moveY, 1.0);
		}
		previousX = LOWORD(lParam);
		previousY = HIWORD(lParam);
	}
	else
	{
		previousX = -1;
		previousY = -1;
	}

	return 0L;
}

LRESULT CInputWindow::OnMouseWheel(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	int move;
	double zoom;
	
	move = GET_WHEEL_DELTA_WPARAM(wParam);
	zoom = pow(1.2, -(double)(move/120));
	MoveScreen(0, 0, zoom);
	
	return 0L;
}

LRESULT CInputWindow::OnKeyDown(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	UINT keyCode;
	BOOL shiftDown;
	
	keyCode = (UINT)wParam;
	shiftDown = (BOOL)(GetAsyncKeyState(VK_SHIFT)&0x8000);
	
	switch (keyCode)
	{
	case VK_PRIOR:
	case VK_NEXT:
	case VK_UP:
	case VK_DOWN:
	case VK_LEFT:
	case VK_RIGHT:
		SendMessage(m_hParentWnd, uMsg, wParam, lParam);
		break;
	default:
		break;
	}
	
	return 0L;
}

LRESULT CInputWindow::OnPaint(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	PAINTSTRUCT paintStruct;
	
	BeginPaint(hWnd, &paintStruct);
	if (m_pScreen != NULL)
	{
		m_pScreen->DrawScreen(paintStruct.hdc, 0, 0, 0, 0);
	}
	EndPaint(hWnd, &paintStruct);
	
	return 0L;
}

LRESULT CInputWindow::OnDestroy(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return 0L;
}
