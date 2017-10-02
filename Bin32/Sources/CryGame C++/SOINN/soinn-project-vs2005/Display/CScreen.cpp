#include "CScreen.h"

const int CScreen::NODE_RADIUS = 6;

CScreen::CScreen(int width, int height, int colorBit)
{
	m_width = width;
	m_height = height;
	m_colorBit = colorBit;
	m_hDC = NULL;
	m_hBitmap = NULL;
	m_hPrevBitmap = NULL;
	m_hFont = NULL;
	m_hPrevFont = NULL;
	ZeroMemory(&m_bitmapInfo, sizeof(BITMAPINFO));
	ZeroMemory(&m_frontColor, sizeof(COLORREF));
	ZeroMemory(&m_backColor, sizeof(COLORREF));
	
	CreateScreen(width, height, colorBit);
}

CScreen::~CScreen()
{
	DeleteFont();
	DeleteDIB();
}

void CScreen::DrawScreen(HDC hDC, int destX, int destY, int srcX, int srcY)
{
	if (m_hDC == NULL) return;
	
	BitBlt(hDC, destX, destY, m_width, m_height, m_hDC, srcX, srcY, SRCCOPY);
}

void CScreen::Clear(void)
{
	if (m_lpBits == NULL) return;

	ZeroMemory((void *)m_lpBits, m_bitmapInfo.bmiHeader.biSizeImage);
}

void CScreen::ChangeSize(int width, int height)
{
	if (width == m_width && height == m_height) return;

	m_width = width;
	m_height = height;
	DeleteDIB();
	CreateScreen(width, height, m_colorBit);
}

int CScreen::GetScreenWidth(void)
{
	return m_bitmapInfo.bmiHeader.biWidth;
}

int CScreen::GetScreenHeight(void)
{
	return m_bitmapInfo.bmiHeader.biHeight;
}

void CScreen::DrawNode(int x, int y, COLORREF color)
{
	int r, g, b;
	int i, j, drawX, drawY, dist;
	int brightness;
	
	if (m_hDC == NULL) return;

	if (!IsInsideScreen(x-NODE_RADIUS, y-NODE_RADIUS, x+NODE_RADIUS, y+NODE_RADIUS)) return;

	r = (int)GetRValue(color);
	g = (int)GetGValue(color);
	b = (int)GetBValue(color);
	
	for (i=-NODE_RADIUS; i<=NODE_RADIUS; i++)
	{
		for (j=-NODE_RADIUS; j<=NODE_RADIUS; j++)
		{
			dist = (i*i)+(j*j);
			drawX = x+i;
			drawY = y+j;
			if (IsInsideScreen(drawX, drawY) && (dist <= NODE_RADIUS*NODE_RADIUS))
			{
				r = GetRValue(color);
				g = GetGValue(color);
				b = GetBValue(color);
				brightness = (int)(128.0*(1.0-(double)dist/(double)(NODE_RADIUS*NODE_RADIUS)));
				r += brightness;
				if (r > 255) r = 255;
				g += brightness;
				if (g > 255) g = 255;
				b += brightness;
				if (b > 255) b = 255;
				DrawPixel(drawX, drawY, RGB(r, g, b));
			}
		}
	}
}

void CScreen::DrawEdge(int x0, int y0, int x1, int y1)
{
	HPEN hPen, hPrevPen;
	
	if (m_hDC == NULL) return;
	
	if (!IsInsideScreen(x0, y0, x1, y1)) return;
	
	hPen = CreatePen(PS_SOLID, 1, RGB(255, 255, 255));
	hPrevPen = (HPEN)SelectObject(m_hDC, hPen);
	MoveToEx(m_hDC, x0, y0, NULL);
	LineTo(m_hDC, x1, y1);
	SelectObject(m_hDC, hPrevPen);
	DeleteObject(hPen);
}

void CScreen::DrawPixel(int x,int y,COLORREF color)
{
	BYTE *lpBitsTemp;
//	int colorNum;

	if (m_hDC == NULL) return;
	if (!IsInsideScreen(x, y)) return;

	lpBitsTemp = (BYTE*)m_lpBits;

	switch(m_colorBit)
	{
//	case 8:
//		colorNum = (int)color&0x000000ff;
//		if (colorNum > 255) return;
//		lpBitsTemp += m_width*(m_height-y-1)+x;
//		*lpBitsTemp++ = (BYTE)colorNum;
//		break;
	case 24:
		lpBitsTemp += (m_bitmapInfo.bmiHeader.biWidth*(m_bitmapInfo.bmiHeader.biHeight-y-1)+x)*3;
		*lpBitsTemp++ = (BYTE)((color&0x00ff0000)>>16);
		*lpBitsTemp++ = (BYTE)((color&0x0000ff00)>>8);
		*lpBitsTemp++ = (BYTE)(color&0x000000ff);
		break;
	default:
		break;
	}
}

void CScreen::DrawText(const char *text, int x, int y, bool outline/*=false*/)
{
	if (m_hDC == NULL) return;

	if (outline)
	{
		::SetTextColor(m_hDC, m_backColor);
		::TextOut(m_hDC, x-1, y, text, (int)strlen(text));
		::TextOut(m_hDC, x+1, y, text, (int)strlen(text));
		::TextOut(m_hDC, x, y-1, text, (int)strlen(text));
		::TextOut(m_hDC, x, y+1, text, (int)strlen(text));
		::SetTextColor(m_hDC, m_frontColor);
	}
	::TextOut(m_hDC, x, y, text, (int)strlen(text));
}

void CScreen::ChangeTextColor(COLORREF frontColor, COLORREF backColor)
{
	m_frontColor = frontColor;
	m_backColor = backColor;
	
	if (m_hDC == NULL) return;

	::SetTextColor(m_hDC, frontColor);
	::SetBkColor(m_hDC, backColor);
}

bool CScreen::GetTextLength(const char *text, int &x, int &y)
{
	SIZE size;

	x = 0;
	y = 0;

	if (m_hDC == NULL) return false;

	GetTextExtentPoint32(m_hDC, text, (int)strlen(text), &size);
	x = size.cx;
	y = size.cy;

	return true;
}

bool CScreen::WriteBitmapFile(const char *fileName)
{
	BITMAPFILEHEADER bitmapFileHeader;
	HANDLE hFile;
	DWORD dwWriteSize;

	if (m_lpBits == NULL) return false;

	bitmapFileHeader.bfType = 'B'+('M'<<8);
	bitmapFileHeader.bfOffBits = sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER);
	if (m_bitmapInfo.bmiHeader.biBitCount <= 8)
	{
		bitmapFileHeader.bfOffBits += sizeof(COLORREF)*(1<<m_bitmapInfo.bmiHeader.biBitCount);
	}
	bitmapFileHeader.bfSize = bitmapFileHeader.bfOffBits+m_bitmapInfo.bmiHeader.biSizeImage;

	hFile = CreateFile(fileName, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, 0, NULL);
	if (hFile == INVALID_HANDLE_VALUE) return false;
	WriteFile(hFile, &bitmapFileHeader, sizeof(bitmapFileHeader), &dwWriteSize, NULL);
	WriteFile(hFile, &m_bitmapInfo.bmiHeader, sizeof(m_bitmapInfo.bmiHeader), &dwWriteSize, NULL);
	if (m_bitmapInfo.bmiHeader.biBitCount <= 8)
	{
		WriteFile(hFile, &m_bitmapInfo.bmiColors, sizeof(COLORREF)*(1<<m_bitmapInfo.bmiHeader.biBitCount), &dwWriteSize, NULL);
	}
	SetFilePointer(hFile, bitmapFileHeader.bfOffBits, NULL, FILE_BEGIN);
	GdiFlush();
	WriteFile(hFile, m_lpBits, m_bitmapInfo.bmiHeader.biSizeImage, &dwWriteSize, NULL);
	CloseHandle(hFile);

	return true;
}

bool CScreen::CreateScreen(int width, int height, int colorBit/*=24*/)
{
	CreateBitmapInfo(width, height, colorBit);

	if (!CreateDIB()) return false;
	if (!CreateFont(12, RGB(255, 255, 255), RGB(0, 0, 0))) return false;

	return true;
}

void CScreen::CreateBitmapInfo(int width, int height, int colorBit)
{
	HDC hDC;
	int i;
	PALETTEENTRY paletteEntry[256];
	
	width = (width+3)&0xfffc;
	height = (height+3)&0xfffc;
	
	ZeroMemory(&m_bitmapInfo, sizeof(BITMAPINFOHEADER));
	
	m_bitmapInfo.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	m_bitmapInfo.bmiHeader.biWidth = width;
	m_bitmapInfo.bmiHeader.biHeight = height;
	m_bitmapInfo.bmiHeader.biPlanes = 1;
	m_bitmapInfo.bmiHeader.biBitCount = colorBit;
	m_bitmapInfo.bmiHeader.biSizeImage = (((width*colorBit+31)>>3)&0xfffffffc)*height;
	
	if (m_bitmapInfo.bmiHeader.biBitCount <= 8)
	{
		hDC = GetDC(NULL);
		GetSystemPaletteEntries(hDC, 0, (1<<colorBit), paletteEntry);
		for (i=0; i<(1<<colorBit); i++)
		{
			m_bitmapInfo.bmiColors[i].rgbRed   = paletteEntry[i].peRed;
			m_bitmapInfo.bmiColors[i].rgbGreen = paletteEntry[i].peGreen;
			m_bitmapInfo.bmiColors[i].rgbBlue  = paletteEntry[i].peBlue;
			m_bitmapInfo.bmiColors[i].rgbReserved = 0;
		}
		ReleaseDC(NULL, hDC);
	}
}

bool CScreen::CreateDIB(void)
{
	HDC hDC;
	
	if (m_hBitmap != NULL)
	{
		DeleteDIB();
	}
	
	hDC = GetDC(NULL);
	
	m_hDC = CreateCompatibleDC(hDC);
	if (m_hDC == NULL) return false;
	
	m_hBitmap = CreateDIBSection(m_hDC, (BITMAPINFO*)&m_bitmapInfo, DIB_RGB_COLORS, &m_lpBits, NULL, NULL);
	if (m_hBitmap == NULL)
	{
		ReleaseDC(NULL, hDC);
		return false;
	}
	
	m_hPrevBitmap = (HBITMAP)SelectObject(m_hDC, m_hBitmap);
	
	ReleaseDC(NULL, hDC);
	
	return true;
}

void CScreen::DeleteDIB(void)
{
	if (m_hDC == NULL) return;
	if (m_hBitmap == NULL) return;
	
	if (m_hPrevBitmap != NULL)
	{
		SelectObject(m_hDC, m_hPrevBitmap);
		m_hPrevBitmap = NULL;
	}
	DeleteObject(m_hBitmap);
	m_hBitmap = NULL;
	
	m_lpBits = NULL;
}

bool CScreen::CreateFont(int size, COLORREF frontColor/*=RGB(0, 0, 0)*/, COLORREF backColor/*=RGB(255, 255, 255)*/)
{
	if (m_hDC == NULL) return false;

	if (m_hFont != NULL)
	{
		DeleteFont();
	}

	m_frontColor = frontColor;
	m_backColor = backColor;
	::SetTextColor(m_hDC, m_frontColor);
	::SetBkColor(m_hDC, m_backColor);
	::SetBkMode(m_hDC, TRANSPARENT);

	m_hFont = ::CreateFont(
		size,
        0,
        0,
        0,
        FW_SEMIBOLD,
        FALSE,
        FALSE,
        FALSE,
        SHIFTJIS_CHARSET,
        OUT_DEFAULT_PRECIS,
        CLIP_DEFAULT_PRECIS,
        PROOF_QUALITY,
        FIXED_PITCH | FF_MODERN,
        "‚l‚r ƒSƒVƒbƒN"
		);

	m_hPrevFont = (HFONT)SelectObject(m_hDC, m_hFont);

	return true;
}

void CScreen::DeleteFont(void)
{
	if (m_hFont == NULL) return;

	SelectObject(m_hDC, m_hPrevFont);
	DeleteObject(m_hFont);
	m_hFont = NULL;
	m_hPrevFont = NULL;
}

bool CScreen::IsInsideScreen(int x, int y)
{
	if (x < 0 || m_width  <= x) return false;
	if (y < 0 || m_height <= y) return false;
	
	return true;
}

bool CScreen::IsInsideScreen(int x0, int y0, int x1, int y1)
{
	int left, right, top, bottom;
	
	left   = __min(x0, x1);
	right  = __max(x0, x1);
	top    = __min(y0, y1);
	bottom = __max(y0, y1);

	if (left   >= m_width ) return false;
	if (right  <  0       ) return false;
	if (top    >= m_height) return false;
	if (bottom <  0       ) return false;

	return true;
}
