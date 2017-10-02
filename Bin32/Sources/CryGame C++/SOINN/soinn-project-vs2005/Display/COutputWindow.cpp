#include "COutputWindow.h"
#include <math.h>

COutputWindow::COutputWindow(HWND hParentWnd, const char *windowClassName, const char *windowTitle, int width, int height) : CChildWindow(hParentWnd, windowClassName, windowTitle, width, height)
{
	m_centerX = 0.0;
	m_centerY = 0.0;
	m_zoom = 1.0;
	m_showAcnode = false;
	m_width = width;
	m_height = height;
	m_pScreen = new CScreen(width, height, 24);
	CreateColor();
}

COutputWindow::~COutputWindow()
{
	if (m_pScreen != NULL)
	{
		delete m_pScreen;
		m_pScreen = NULL;
	}
}

bool COutputWindow::InitScreen(double x/*=0.0*/, double y/*=0.0*/, double zoom/*=1.0*/)
{
	if (zoom <= 0.0) return false;

	m_centerX = x;
	m_centerY = y;
	m_zoom = zoom;

	return true;
}

bool COutputWindow::MoveScreen(int x, int y, double zoom/*=1.0*/)
{
	if (zoom <= 0.0) return false;

	m_centerX -= (double)x/m_zoom;
	m_centerY -= (double)y/m_zoom;
	m_zoom *= zoom;

	return true;
}

void COutputWindow::CreateColor(void)
{
//	int i;
	
//	for (i=0; i<MAX_COLOR; i++)
//	{
//		m_color[i] = RGB(64+rand()%128, 64+rand()%128, 64+rand()%128);
//	}

	m_color[0] = RGB(64+128, 64, 64);
	m_color[1] = RGB(64, 64+128, 64);
	m_color[2] = RGB(64, 64, 64+128);
	m_color[3] = RGB(64+128, 64+128, 64);
	m_color[4] = RGB(64+128, 64, 64+128);
	m_color[5] = RGB(64, 64+128, 64+128);
	m_color[6] = RGB(64, 64, 64);
	m_color[7] = RGB(64, 64+64, 64+128);
	m_color[8] = RGB(64+64, 64+128, 64);
	m_color[9] = RGB(64+128, 64, 64+64);
	m_color[10] = RGB(64, 64+128, 64+64);
	m_color[11] = RGB(64+64, 64, 64+128);
	m_color[12] = RGB(64+128, 64+64, 64);
	m_color[13] = RGB(64+128, 64+64, 64+64);
	m_color[14] = RGB(64+64, 64+128, 64+64);
	m_color[15] = RGB(64+64, 64+64, 64+128);
}

void COutputWindow::Refresh(CSOINN *pSOINN, CInputAdministrator *pInputAdministrator)
{
	int i, f, t, nodeNum, edgeNum;
	double x, y, x0, y0, x1, y1;
	CNode* node;
	CEdge* edge;
	char buf[128];
	
	m_pScreen->Clear();

	if (pSOINN == NULL || pInputAdministrator == NULL)
	{
		InvalidateRect(m_hWnd, NULL, false);
		SendMessage(m_hWnd, WM_PAINT, 0, 0);
		return;
	}
	if (pInputAdministrator->GetGeneratorType() == CInputAdministrator::NO_GENERATOR)
	{
		InvalidateRect(m_hWnd, NULL, false);
		SendMessage(m_hWnd, WM_PAINT, 0, 0);
		return;
	}

	pSOINN->Classify();

	edgeNum = pSOINN->GetEdgeNum();
	for (i=0; i<edgeNum; i++)
	{
		edge = pSOINN->GetEdge(i);
		f = edge->m_from;
		node = pSOINN->GetNode(f);
		pInputAdministrator->GetDrawCoordinates(node->m_signal, x0, y0);
		TransrateToScreenCoordinates(x0, y0);
		t = edge->m_to;
		node = pSOINN->GetNode(t);
		pInputAdministrator->GetDrawCoordinates(node->m_signal, x1, y1);
		TransrateToScreenCoordinates(x1, y1);
		m_pScreen->DrawEdge((int)x0, (int)y0, (int)x1, (int)y1);
	}

	nodeNum = pSOINN->GetNodeNum();
	for (i=0; i<nodeNum; i++)
	{
		node = pSOINN->GetNode(i);
		if (m_showAcnode || node->m_neighborNum > 0)
		{
			pInputAdministrator->GetDrawCoordinates(node->m_signal, x, y);
			TransrateToScreenCoordinates(x, y);
			m_pScreen->DrawNode((int)x, (int)y, m_color[node->m_classID%MAX_COLOR]);
		}
	}
	
	sprintf(buf, "Node : %d", pSOINN->GetNodeNum(true));
	m_pScreen->DrawText(buf, 5, 5, true);
	sprintf(buf, "Class : %d", pSOINN->GetClassNum());
	m_pScreen->DrawText(buf, 5, 25, true);

	InvalidateRect(m_hWnd, NULL, false);
	SendMessage(m_hWnd, WM_PAINT, 0, 0);
}

void COutputWindow::Clear(void)
{
	if (m_pScreen == NULL) return;
	
	m_pScreen->Clear();
}

bool COutputWindow::SetShowAcnode(bool showAcnode)
{
	if (m_showAcnode == showAcnode) return false;

	m_showAcnode = showAcnode;

	return true;
}

int COutputWindow::GetScreenWidth(void)
{
	return m_pScreen->GetScreenWidth();
}

int COutputWindow::GetScreenHeight(void)
{
	return m_pScreen->GetScreenHeight();
}

bool COutputWindow::WriteBitmapFile(const char *fileName)
{
	return m_pScreen->WriteBitmapFile(fileName);
}

void COutputWindow::TransrateToScreenCoordinates(double &x, double &y)
{
	x -= m_centerX;
	y -= m_centerY;
	x *= m_zoom;
	y *= m_zoom;
	x += m_pScreen->GetScreenWidth()/2;
	y += m_pScreen->GetScreenHeight()/2;
}

LRESULT COutputWindow::OnCreate(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return 0L;
}

LRESULT COutputWindow::OnSize(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
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

LRESULT COutputWindow::OnMouseMove(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
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

LRESULT COutputWindow::OnMouseWheel(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	int move;
	double zoom;
	
	move = GET_WHEEL_DELTA_WPARAM(wParam);
	zoom = pow(1.2, -(double)(move/120));
	MoveScreen(0, 0, zoom);
	
	return 0L;
}

LRESULT COutputWindow::OnKeyDown(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
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

LRESULT COutputWindow::OnPaint(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
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

LRESULT COutputWindow::OnDestroy(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	return 0L;
}
