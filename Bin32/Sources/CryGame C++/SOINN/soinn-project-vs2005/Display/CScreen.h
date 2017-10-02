#ifndef _SCREEN_HEADER_
#define _SCREEN_HEADER_

#include <windows.h>

class CScreen
{
public:
	CScreen(int width, int height, int colorBit);
	~CScreen();
	void	DrawScreen(HDC hDC, int destX, int destY, int srcX, int srcY);
	void	Clear(void);
	void	ChangeSize(int width, int height);
	int		GetScreenWidth(void);
	int		GetScreenHeight(void);
	void	DrawNode(int x, int y, COLORREF color);
	void	DrawEdge(int x0, int y0, int x1, int y1);
	void	DrawPixel(int x, int y, COLORREF color);
	void	DrawText(const char *text, int x, int y, bool outline=false);
	void	ChangeTextColor(COLORREF frontColor, COLORREF backColor);
	bool	GetTextLength(const char *text, int &x, int &y);
	bool	WriteBitmapFile(const char *fileName);

private:
	bool	CreateScreen(int width, int height, int colorBit=24);
	void	CreateBitmapInfo(int width, int height, int colorBit);
	bool	CreateDIB(void);
	void	DeleteDIB(void);
	bool	CreateFont(int size, COLORREF frontColor=RGB(0, 0, 0), COLORREF backColor=RGB(255, 255, 255));
	void	DeleteFont(void);
	bool	IsInsideScreen(int x, int y);
	bool	IsInsideScreen(int x0, int y0, int x1, int y1);

private:
	int m_width;
	int m_height;
	int m_colorBit;
	HDC m_hDC;
	BITMAPINFO m_bitmapInfo;
	LPVOID	m_lpBits;
	HBITMAP m_hBitmap;
	HBITMAP m_hPrevBitmap;
	HFONT m_hFont;
	HFONT m_hPrevFont;
	COLORREF m_frontColor;
	COLORREF m_backColor;

	static const int NODE_RADIUS;
};

#endif
