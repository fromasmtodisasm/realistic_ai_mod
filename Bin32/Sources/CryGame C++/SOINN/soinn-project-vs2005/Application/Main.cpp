#include "Main.h"
#include "..\\SOINN\\CSOINN.h"
#include "COption.h"
#include "..\\Display\\CInputWindow.h"
#include "..\\Display\\COutputWindow.h"
#include "..\\InputData\\CInputAdministrator.h"
#include "..\\InputData\\CVectorGeneratorFromFile.h"
#include "resource.h"
#include <math.h>
#include <time.h>

// constant
const char *WndClassName = "CLS:SOINN";
const char *WndTitle = "Self-Organizing Incremental Neural Network (SOINN)";
const int windowWidth = 480;
const int windowHeight = 23;	// 23 = menu bar height
const char *iniFile = "option.ini";
const int additionalMenuIDStart = 10000;

// Global variables
COption *pOption = NULL;
CInputWindow *pInputWindow = NULL;
COutputWindow *pOutputWindow = NULL;
CInputAdministrator *pInputAdministrator = NULL;
CSOINN * pSOINN = NULL;

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpszCmdLine, int nCmdShow)
{
	WNDCLASS WndClass;
	HWND hWnd;
	MSG msg;
	
	InitWindowClass(hInstance, WndClass, WndClassName);	
	if (!RegisterClass(&WndClass)) return FALSE;
	
	hWnd = CreateWindow(
		WndClassName,
		WndTitle,
		WS_OVERLAPPED | WS_CAPTION | WS_MINIMIZEBOX | WS_SYSMENU,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		windowWidth+GetSystemMetrics(SM_CXBORDER)*2,
		windowHeight+GetSystemMetrics(SM_CYCAPTION)+GetSystemMetrics(SM_CYBORDER)*2,
		NULL,
		NULL,
		hInstance,
		NULL
		);
	
	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	while (true)
	{
		if (PeekMessage(&msg,NULL,0,0,PM_NOREMOVE))
		{
			if (!GetMessage(&msg, NULL, 0, 0)) break;
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		OnMessageLoop(hWnd);
	
	}

	OnExitMessageLoop();

	return TRUE;
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
	case WM_CREATE:
		OnCreate(hWnd);
		break;
	case WM_COMMAND:
		OnCommand(hWnd, LOWORD(wParam));
		break;
	case WM_PAINT:
		OnPaint(hWnd);
		break;
	case WM_KEYDOWN:
		OnKeyDown(hWnd, (UINT)wParam, (BOOL)(GetAsyncKeyState(VK_SHIFT)&0x8000));
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return(DefWindowProc(hWnd, uMsg, wParam, lParam));
	}
	return (0L);
}

void InitWindowClass(HINSTANCE hInstance, WNDCLASS &WndClass, const char *className)
{
	ZeroMemory(&WndClass, sizeof(WNDCLASS));
	WndClass.lpszClassName = className;
	WndClass.lpfnWndProc = WndProc;
	WndClass.style = CS_HREDRAW | CS_VREDRAW;
	WndClass.hInstance = hInstance;
	WndClass.hIcon = NULL;
	WndClass.hCursor = LoadCursor(NULL, IDC_ARROW);
	WndClass.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
	WndClass.lpszMenuName = MAKEINTRESOURCE(IDM_MAIN);
	WndClass.cbClsExtra = 0;
	WndClass.cbWndExtra = 0;
}

void OnCreate(HWND hWnd)
{
	HMENU hMenu;
	MENUITEMINFO menuItemInfo;
	RECT rect;
	int x, y, width, height;
	TCHAR* appPath;
	char buf[_MAX_PATH];
	
	appPath = GetAppPath();
	if (appPath != NULL)
	{
		::SetCurrentDirectory(appPath);
	}

	if (pOption == NULL)
	{
		appPath = GetAppPath();
		if (appPath == NULL)
		{
			sprintf_s(buf, "%s", iniFile);
		}
		else
		{
			if (appPath[strlen(appPath)-1] == '\\')
			{
				sprintf_s(buf, "%s%s", appPath, iniFile);
			}
			else
			{
				sprintf_s(buf, "%s\\%s", appPath, iniFile);
			}
		}
		pOption = new COption(buf);
	}

	if (pInputAdministrator == NULL)
	{
		pInputAdministrator = new CInputAdministrator();
		if (pOption != NULL)
		{
			pInputAdministrator->SetNoise(pOption->GetInputAdministrator_noise());
		}
	}

	GetWindowRect(hWnd, &rect);
	x = rect.left;
	y = rect.bottom;
	width = (rect.right-rect.left)/2;
	height = (rect.right-rect.left)/2;

	if (pInputWindow == NULL)
	{
		pInputWindow = new CInputWindow(hWnd, "CLS:InputWindow", "Input", width, height);
	}
	pInputWindow->CreateChildWindow();
	SetWindowPos(pInputWindow->GetWindowHandle(), NULL, x, y, NULL, NULL, SWP_NOSIZE | SWP_NOZORDER);
	UpdateWindow(pInputWindow->GetWindowHandle());

	if (pOutputWindow == NULL)
	{
		pOutputWindow = new COutputWindow(hWnd, "CLS:OutputWindow", "Output", width, height);
	}
	pOutputWindow->CreateChildWindow();
	SetWindowPos(pOutputWindow->GetWindowHandle(), NULL, x+width, y, NULL, NULL, SWP_NOSIZE | SWP_NOZORDER);
	UpdateWindow(pOutputWindow->GetWindowHandle());
	if (pOption != NULL)
	{
		pOutputWindow->SetShowAcnode(pOption->GetOutputWindow_showAcnode());
	}

	if (pSOINN == NULL)
	{
		if (pOption != NULL)
		{
			pSOINN = new CSOINN(0, pOption->GetSOINN_parameter_lambda(), pOption->GetSOINN_parameter_ageMax());
		}
		else
		{
			pSOINN = new CSOINN(0, 200, 100);
		}
	}

	hMenu = GetMenu(hWnd);
	ZeroMemory(&menuItemInfo, sizeof(MENUITEMINFO));
	menuItemInfo.cbSize = sizeof(MENUITEMINFO);
	menuItemInfo.fMask = MIIM_STATE;
	if (GetMenuItemInfo(hMenu, IDM_INPUT_STOP, FALSE, &menuItemInfo))
	{
		CheckMenuItem(hMenu, IDM_INPUT_STOP, MF_UNCHECKED);
	}
	if (pOption != NULL)
	{
		if (pOption->GetOutputWindow_showAcnode())
		{
			CheckMenuItem(hMenu, IDM_SHOWACNODE, MF_CHECKED);
			if (pOutputWindow != NULL)
			{
				pOutputWindow->SetShowAcnode(true);
			}
		}
		else
		{			
			CheckMenuItem(hMenu, IDM_SHOWACNODE, MF_UNCHECKED);
			if (pOutputWindow != NULL)
			{
				pOutputWindow->SetShowAcnode(false);
			}
		}
	}
	else
	{
		CheckMenuItem(hMenu, IDM_SHOWACNODE, MF_UNCHECKED);
	}

	srand((int)time(NULL));
}

void OnCommand(HWND hWnd, int msg)
{
	HMENU hMenu;
	MENUITEMINFO menuItemInfo;
	OPENFILENAME openFileName;
	char fileName[MAX_PATH];
	int classNum, classID;
	CVectorGeneratorFromFile *pVectorGeneratorFromFile;
	int i;
	bool generate;
	static int checkedItemNum = 0;

	switch (msg)
	{
	// menu -> file
	case IDM_OUTPUT_SOINN:	// Save results of SOINN
		if (pSOINN == NULL) return;
		CreateOpenFileNameInfo(&openFileName, hWnd, fileName, sizeof(fileName), "vector file(*.snn)\0*.txt\0");
		if (!GetSaveFileName(&openFileName)) return;
		pSOINN->SaveNetworkData(fileName);
		break;
	case IDM_SAVE_INPUT:	// Save the contents of the input screen
		if (pInputWindow == NULL) return;
		CreateOpenFileNameInfo(&openFileName, hWnd, fileName, sizeof(fileName), "BITMAP Image(*.bmp)\0*.bmp\0");
		if (!GetSaveFileName(&openFileName)) return;
		pInputWindow->WriteBitmapFile(fileName);
		break;
	case IDM_SAVE_OUTPUT:	// Save the contents of the output screen
		if (pOutputWindow == NULL) return;
		CreateOpenFileNameInfo(&openFileName, hWnd, fileName, sizeof(fileName), "BITMAP Image(*.bmp)\0*.bmp\0");
		if (!GetSaveFileName(&openFileName)) return;
		pOutputWindow->WriteBitmapFile(fileName);
		break;
	case IDM_QUIT:	// End
		SendMessage(hWnd, WM_CLOSE, 0, 0L);
		break;
	// ƒƒjƒ…[ ¨ “ü—Í
	case IDM_INPUT_SIN:			// Input data->sin
	case IDM_INPUT_GAUSSIAN:	// Artificial data->Gaussian
	case IDM_INPUT_CONCENTRIC:	// Artificial data->Concentric
		OnChangeInput(hWnd, msg);
		break;
	case IDM_INPUT_FILE:	// Read from file
		hMenu = GetSubMenu(GetSubMenu(GetMenu(hWnd), 1), 1);
		pVectorGeneratorFromFile = pInputAdministrator->GetGeneratorFromFile();
		if (pVectorGeneratorFromFile != NULL)
		{
			classNum = pVectorGeneratorFromFile->GetClassNum();
			for (i=0; i<classNum+3; i++)
			{
				DeleteMenu(hMenu, 1, MF_BYPOSITION);
			}
		}
		checkedItemNum = 0;
		OnChangeInput(hWnd, msg);
		if (pInputAdministrator->GetGeneratorType() == CInputAdministrator::NO_GENERATOR) return;
		pVectorGeneratorFromFile = pInputAdministrator->GetGeneratorFromFile();
		if (pVectorGeneratorFromFile == NULL) return;
		ZeroMemory(&menuItemInfo, sizeof(MENUITEMINFO));
		menuItemInfo.cbSize = sizeof(MENUITEMINFO);
		menuItemInfo.fMask = MIIM_TYPE;
		menuItemInfo.fType = MFT_SEPARATOR;
		InsertMenuItem(hMenu, 1, TRUE, &menuItemInfo);
		ZeroMemory(&menuItemInfo, sizeof(MENUITEMINFO));
		menuItemInfo.cbSize = sizeof(MENUITEMINFO);
		menuItemInfo.fMask = MIIM_TYPE | MIIM_ID | MIIM_STATE;
		menuItemInfo.fType = MFT_STRING;
		menuItemInfo.fState = MFS_CHECKED;
		menuItemInfo.wID = additionalMenuIDStart;
		menuItemInfo.dwTypeData = "All";
		InsertMenuItem(hMenu, 2, TRUE, &menuItemInfo);
		classNum = pVectorGeneratorFromFile->GetClassNum();
		for (i=0; i<classNum; i++)
		{
			ZeroMemory(&menuItemInfo, sizeof(MENUITEMINFO));
			menuItemInfo.cbSize = sizeof(MENUITEMINFO);
			menuItemInfo.fMask = MIIM_TYPE | MIIM_ID | MIIM_STATE;
			menuItemInfo.fType = MFT_STRING;
			menuItemInfo.wID = additionalMenuIDStart+i+1;
			menuItemInfo.fState = MFS_CHECKED;
			menuItemInfo.dwTypeData = pVectorGeneratorFromFile->GetClassName(i);
			InsertMenuItem(hMenu, 3+i, TRUE, &menuItemInfo);
		}
		checkedItemNum = classNum;
		break;
	case IDM_INPUT_STOP:	// Stop
		hMenu = GetMenu(hWnd);
		ZeroMemory(&menuItemInfo, sizeof(MENUITEMINFO));
		menuItemInfo.cbSize = sizeof(MENUITEMINFO);
		menuItemInfo.fMask = MIIM_STATE;
		if (!GetMenuItemInfo(hMenu, IDM_INPUT_STOP, FALSE, &menuItemInfo)) return;
		if (menuItemInfo.fState == MFS_CHECKED)
		{
			CheckMenuItem(hMenu, IDM_INPUT_STOP, MF_UNCHECKED);
			OnMenuInputStop(FALSE);
		}
		else
		{
			CheckMenuItem(hMenu, IDM_INPUT_STOP, MF_CHECKED);
			OnMenuInputStop(TRUE);
		}
		break;
	// Menu -> Setting
	case IDM_OPTION:	// Setting
		if (pOption == NULL) return;
		if (!pOption->OpenDialog(hWnd)) return;
		if (pSOINN != NULL)
		{
			pSOINN->Reset(CSOINN::NO_CHANGE, pOption->GetSOINN_parameter_lambda(), pOption->GetSOINN_parameter_ageMax());
			if (pInputAdministrator == NULL) return;
			pInputAdministrator->ResetInputNum();
		}
		if (pInputAdministrator != NULL)
		{
			pInputAdministrator->SetNoise(pOption->GetInputAdministrator_noise());
		}
		break;
	case IDM_SHOWACNODE:	// Show isolated point
		hMenu = GetMenu(hWnd);
		ZeroMemory(&menuItemInfo, sizeof(MENUITEMINFO));
		menuItemInfo.cbSize = sizeof(MENUITEMINFO);
		menuItemInfo.fMask = MIIM_STATE;
		if (!GetMenuItemInfo(hMenu, IDM_SHOWACNODE, FALSE, &menuItemInfo)) return;
		if (menuItemInfo.fState == MFS_CHECKED)
		{
			CheckMenuItem(hMenu, IDM_SHOWACNODE, MF_UNCHECKED);
			if (pOption != NULL)
			{
				pOption->SetOutputWindow_showAcnode(false);
			}
			if (pOutputWindow != NULL)
			{
				pOutputWindow->SetShowAcnode(false);
			}
		}
		else
		{
			CheckMenuItem(hMenu, IDM_SHOWACNODE, MF_CHECKED);
			if (pOption != NULL)
			{
				pOption->SetOutputWindow_showAcnode(true);
			}
			if (pOutputWindow != NULL)
			{
				pOutputWindow->SetShowAcnode(true);
			}		
		}
		break;
	case IDM_RESET:	// Reset
		if (pSOINN != NULL)
		{
			pSOINN->Reset();
		}
		if (pInputWindow != NULL)
		{
			pInputWindow->Reset();
			pInputWindow->Refresh();
		}
		if (pOutputWindow != NULL)
		{
			pOutputWindow->Refresh(NULL, NULL);
		}
		break;
	default:
		if (pInputAdministrator != NULL)
		{
			pVectorGeneratorFromFile = pInputAdministrator->GetGeneratorFromFile();
			if (pVectorGeneratorFromFile == NULL) return;
			if (msg < additionalMenuIDStart || additionalMenuIDStart+pVectorGeneratorFromFile->GetClassNum() < msg) return;
			hMenu = GetMenu(hWnd);
			ZeroMemory(&menuItemInfo, sizeof(MENUITEMINFO));
			menuItemInfo.cbSize = sizeof(MENUITEMINFO);
			menuItemInfo.fMask = MIIM_STATE;
			if (!GetMenuItemInfo(hMenu, msg, FALSE, &menuItemInfo)) return;
			if (menuItemInfo.fState == MFS_CHECKED)
			{
				CheckMenuItem(hMenu, msg, MF_UNCHECKED);
				checkedItemNum--;
				CheckMenuItem(hMenu, additionalMenuIDStart, MF_UNCHECKED);
				generate = false;
			}
			else
			{
				CheckMenuItem(hMenu, msg, MF_CHECKED);
				checkedItemNum++;
				classNum = pVectorGeneratorFromFile->GetClassNum();
				if (checkedItemNum == classNum)
				{
					CheckMenuItem(hMenu, additionalMenuIDStart, MF_CHECKED);
				}
				generate = true;
			}
			if (msg == additionalMenuIDStart)
			{
				pVectorGeneratorFromFile->SetGenerateState(CVectorGeneratorFromFile::ALL_CLASS, generate);
				classNum = pVectorGeneratorFromFile->GetClassNum();
				if (generate)
				{
					for (i=0; i<classNum+1; i++)
					{
						CheckMenuItem(hMenu, additionalMenuIDStart+i, MF_CHECKED);
					}
				}
				else
				{
					for (i=0; i<classNum+1; i++)
					{
						CheckMenuItem(hMenu, additionalMenuIDStart+i, MF_UNCHECKED);
					}
				}
			}
			else
			{
				classID = msg-additionalMenuIDStart-1;
				pVectorGeneratorFromFile->SetGenerateState(classID, generate);
			}
		}
		break;
	}
}

void OnPaint(HWND hWnd)
{
	PAINTSTRUCT paintStruct;

	BeginPaint(hWnd, &paintStruct);
	EndPaint(hWnd, &paintStruct);
}

void OnKeyDown(HWND hWnd, UINT keyCode, BOOL shiftDown)
{
	switch (keyCode)
	{
	case VK_PRIOR:
		if (shiftDown)
		{
			if (pInputWindow != NULL)
			{
				pInputWindow->MoveScreen(0, 0, pow(1.2, 1.2));
			}
		}
		else
		{
			if (pOutputWindow != NULL)
			{
				pOutputWindow->MoveScreen(0, 0, pow(1.2, 1.2));
			}
		}
		break;
	case VK_NEXT:
		if (shiftDown)
		{
			if (pInputWindow != NULL)
			{
				pInputWindow->MoveScreen(0, 0, pow(1.2, -1.2));
			}
		}
		else
		{
			if (pOutputWindow != NULL)
			{
				pOutputWindow->MoveScreen(0, 0, pow(1.2, -1.2));
			}
		}
		break;
	case VK_UP:
		if (shiftDown)
		{
			if (pInputWindow != NULL)
			{
				pInputWindow->MoveScreen(0, -pInputWindow->GetScreenHeight()/10, 1.0);
			}
		}
		else
		{
			if (pOutputWindow != NULL)
			{
				pOutputWindow->MoveScreen(0, -pOutputWindow->GetScreenHeight()/10, 1.0);
			}
		}
		break;
	case VK_DOWN:
		if (shiftDown)
		{
			if (pInputWindow != NULL)
			{
				pInputWindow->MoveScreen(0, pInputWindow->GetScreenHeight()/10, 1.0);
			}
		}
		else
		{
			if (pOutputWindow != NULL)
			{
				pOutputWindow->MoveScreen(0, pOutputWindow->GetScreenHeight()/10, 1.0);
			}
		}
		break;
	case VK_LEFT:
		if (shiftDown)
		{
			if (pInputWindow != NULL)
			{
				pInputWindow->MoveScreen(-pInputWindow->GetScreenWidth()/10, 0, 1.0);
			}
		}
		else
		{
			if (pOutputWindow != NULL)
			{
				pOutputWindow->MoveScreen(-pOutputWindow->GetScreenWidth()/10, 0, 1.0);
			}
		}
		break;
	case VK_RIGHT:
		if (shiftDown)
		{
			if (pInputWindow != NULL)
			{
				pInputWindow->MoveScreen(pInputWindow->GetScreenWidth()/10, 0, 1.0);
			}
		}
		else
		{
			if (pOutputWindow != NULL)
			{
				pOutputWindow->MoveScreen(pOutputWindow->GetScreenWidth()/10, 0, 1.0);
			}
		}
		break;
	default:
		break;
	}
}

void OnMenuInputStop(BOOL checked)
{
	// If the stop is checked
	if (checked)
	{
		pInputAdministrator->SetGeneratorState(CInputAdministrator::STATE_STOP);
	}
	// If the check of stop is cancelled
	else
	{
		pInputAdministrator->SetGeneratorState(CInputAdministrator::STATE_START);
	}
}

void OnChangeInput(HWND hWnd, int msg)
{
	int generator;
	int InputDimension, SOINNDimension;
	int ans;
	CVectorGeneratorFromFile *pVectorGeneratorFromFile;
	char fileName[_MAX_PATH];
	OPENFILENAME openFileName;

	if (pSOINN == NULL) return;
	if (pInputAdministrator == NULL) return;

	switch (msg)
	{
	case IDM_INPUT_FILE:
		generator = CInputAdministrator::GENERATOR_FROM_FILE;
		break;
	case IDM_INPUT_SIN:
		generator = CInputAdministrator::GENERATOR_SIN;
		break;
	case IDM_INPUT_GAUSSIAN:
		generator = CInputAdministrator::GENERATOR_GAUSSIAN;
		break;
	case IDM_INPUT_CONCENTRIC:
		generator = CInputAdministrator::GENERATOR_CONCENTRIC;
		break;
	default:
		generator = CInputAdministrator::NO_GENERATOR;
		break;
	}
	pInputAdministrator->SetGeneratorType(generator);
	pInputAdministrator->ResetInputNum();

	if (msg == IDM_INPUT_FILE)
	{
		pVectorGeneratorFromFile = pInputAdministrator->GetGeneratorFromFile();
		if (pVectorGeneratorFromFile == NULL) return;
		fileName[0] = '\0';
		ZeroMemory(&openFileName, sizeof(OPENFILENAME));
		openFileName.lStructSize = sizeof(OPENFILENAME);
		openFileName.hwndOwner = hWnd;
		// for vs2005
		//openFileName.hInstance = (HINSTANCE)GetWindowLong(hWnd, GWL_HINSTANCE);
		openFileName.hInstance = (HINSTANCE)(LONG_PTR)GetWindowLongPtr(hWnd, GWL_HINSTANCE);
		openFileName.lpstrFilter = "vector files(*.vct)\0*.vct\0";
		openFileName.nFilterIndex = 1;
		openFileName.lpstrFile = fileName;
		openFileName.nMaxFile = sizeof(fileName);
		openFileName.lpstrInitialDir = NULL;
		openFileName.lpstrTitle = "Open";
		openFileName.lpstrDefExt = NULL;
		openFileName.Flags = OFN_OVERWRITEPROMPT | OFN_HIDEREADONLY;
		if (!GetOpenFileName(&openFileName)) return;
		if (!pVectorGeneratorFromFile->ReadVectorFile(fileName))
		{
			pInputAdministrator->SetGeneratorType(CInputAdministrator::NO_GENERATOR);
			return;
		}
	}

	InputDimension = pInputAdministrator->GetDimension();
	SOINNDimension = pSOINN->GetDimension();
	if (SOINNDimension == 0)
	{
			pSOINN->Reset(InputDimension);
	}
	else
	{
		if (SOINNDimension != InputDimension)
		{
			MessageBox(hWnd, "Because input data is different in dimension, reset SOINN", "OK", MB_OK);
			pSOINN->Reset(InputDimension);
		}
		else
		{
			ans = ::MessageBox(hWnd, "Reset SOINNH", "Confirm", MB_YESNO);
			if (ans == IDYES)
			{
				pSOINN->Reset(InputDimension);
			}
		}
	}
	if (pInputWindow != NULL)
	{
		pInputWindow->Clear();
		pInputWindow->InitScreen(0.0, 0.0, 30.0);
		pInputWindow->Reset();
	}
	if (pOutputWindow != NULL)
	{
		pOutputWindow->Clear();
		pOutputWindow->InitScreen(0.0, 0.0, 30.0);
	}
}

void OnMessageLoop(HWND hWnd)
{
	double *signal;
	double x, y;
	
	if (pInputAdministrator == NULL || pSOINN == NULL)
	{
		Sleep(1);
		return;
	}

	if (pInputAdministrator->GetGeneratorType() == CInputAdministrator::NO_GENERATOR
		|| pInputAdministrator->GetGeneratorState() == CInputAdministrator::STATE_STOP
		|| pInputAdministrator->GetDimension() != pSOINN->GetDimension())
	{
		Sleep(1);
		return;
	}

	signal = pInputAdministrator->GenerateVector();
	if (signal == NULL)
	{
		Sleep(1);
		return;
	}
	
	pSOINN->InputSignal(signal);
	pInputAdministrator->GetDrawCoordinates(signal, x, y);
	if (pInputWindow != NULL)
	{
		pInputWindow->AddSignal(x, y);
	}
	if (pInputAdministrator->GetInputNum()%100 == 0)
	{
		if (pInputWindow != NULL)
		{
			pInputWindow->Refresh();
		}
		if (pOutputWindow != NULL)
		{
			pOutputWindow->Refresh(pSOINN, pInputAdministrator);
		}
	}
}

void OnExitMessageLoop(void)
{
	if (pOption != NULL)
	{
		delete pOption;
		pOption = NULL;
	}
	if (pInputWindow != NULL)
	{
		delete pInputWindow;
		pInputWindow = NULL;
	}
	if (pOutputWindow != NULL)
	{
		delete pOutputWindow;
		pOutputWindow = NULL;
	}
	if (pInputAdministrator != NULL)
	{
		delete pInputAdministrator;
		pInputAdministrator = NULL;
	}
	if (pSOINN != NULL)
	{
		delete pSOINN;
		pSOINN = NULL;
	}
}

void CreateOpenFileNameInfo(OPENFILENAME *openFileName, const HWND hWnd, char *fileName, const int fileNameLength, LPCSTR filter)
{
	fileName[0] = '\0';
	ZeroMemory(openFileName,sizeof(OPENFILENAME));
	openFileName->lStructSize = sizeof(OPENFILENAME);
	openFileName->hwndOwner = hWnd;
	// for vs2005
	//openFileName->hInstance = (HINSTANCE)GetWindowLong(hWnd, GWL_HINSTANCE);
	openFileName->hInstance = (HINSTANCE)(LONG_PTR)GetWindowLongPtr(hWnd, GWL_HINSTANCE);
	openFileName->lpstrFilter = filter;
	openFileName->nFilterIndex = 1;
	openFileName->lpstrFile = fileName;
	openFileName->nMaxFile = fileNameLength;
	openFileName->lpstrInitialDir = NULL;
	openFileName->lpstrTitle = "Save";
	openFileName->Flags = OFN_OVERWRITEPROMPT | OFN_HIDEREADONLY;
}

TCHAR* GetAppPath(void)
{
	static TCHAR appPath[_MAX_PATH];
	static bool getAppPath = false;
	TCHAR path[_MAX_PATH];
	TCHAR drive[_MAX_DRIVE];
	TCHAR dir[_MAX_DIR];
	
	if (!getAppPath)
	{
		if (!GetModuleFileName(NULL, path, sizeof(path))) return NULL;
		// for vs2005
		//_tsplitpath_s(path, drive, dir, NULL, NULL);
		int nErr = (path, drive, _MAX_DRIVE, dir, _MAX_DIR, NULL, _MAX_FNAME, NULL, _MAX_EXT);
		memcpy(appPath, dir, sizeof(TCHAR)*strlen(dir));
		getAppPath = true;
	}

	return appPath;
}
