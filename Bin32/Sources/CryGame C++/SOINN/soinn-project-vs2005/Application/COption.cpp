#include "Coption.h"
#include "resource.h"
#include <windows.h>
#include <stdio.h>

const int COption::DEFAULT_SOINN_parameter_lambda = 200;
const int COption::DEFAULT_SOINN_parameter_ageMax = 100;
const double COption::DEFAULT_inputAdministrator_noise = 0.0;
const char* COption::PROPNAME = "PROP:OPTIONDLG";

COption::COption(const char *iniFile)
{
	m_iniFile = NULL;
	if (iniFile != NULL)
	{
		m_iniFile = new char[sizeof(char)*(strlen(iniFile)+1)];
		memcpy(m_iniFile, iniFile, sizeof(char)*(strlen(iniFile)+1));
	}
	Read();
}

COption::~COption()
{
	Write();
	if (m_iniFile != NULL)
	{
		delete [] m_iniFile;
		m_iniFile = NULL;
	}
}

LRESULT CALLBACK COption::StaticDlgProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	COption* pOption;
	LRESULT result;
	
	if (uMsg == WM_INITDIALOG)
	{
		pOption = (COption*)lParam;
		if (pOption != NULL)
		{
			SetProp(hWnd, PROPNAME, (HANDLE)pOption);
		}
	}
	else
	{
		pOption = (COption*)GetProp(hWnd, PROPNAME);
	}

	if (pOption != NULL)
	{
		result = pOption->DlgProc(hWnd, uMsg, wParam, lParam);
		if (uMsg == WM_DESTROY)
		{
			if (hWnd != NULL)
			{
				DestroyWindow(hWnd);
				RemoveProp(hWnd, PROPNAME);
			}
		}
		return result;
	}

	return FALSE;
}

LRESULT CALLBACK COption::DlgProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	char buf[256];
	int tempInt;
	double tempDouble;

	switch (uMsg)
	{
	case WM_INITDIALOG:
		sprintf_s(buf, "%d", m_SOINN_parameter_lambda);
		SetDlgItemText(hWnd, IDC_EDIT_LAMBDA, (LPCTSTR)buf);
		sprintf_s(buf, "%d", m_SOINN_parameter_ageMax);
		SetDlgItemText(hWnd, IDC_EDIT_AGEMAX, (LPCTSTR)buf);
		sprintf_s(buf, "%.2f", m_inputAdministrator_noise);
		SetDlgItemText(hWnd, IDC_EDIT_NOISE, (LPTSTR)buf);
		return TRUE;
	case WM_CLOSE:
		EndDialog(hWnd, IDOK);
		break;
	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			GetDlgItemText(hWnd, IDC_EDIT_LAMBDA, (LPTSTR)buf, sizeof(buf));
			tempInt = atoi(buf);
			if (tempInt > 0)
			{
				m_SOINN_parameter_lambda = tempInt;
			}
			GetDlgItemText(hWnd, IDC_EDIT_AGEMAX, (LPTSTR)buf, sizeof(buf));
			tempInt = atoi(buf);
			if (tempInt > 0)
			{
				m_SOINN_parameter_ageMax = tempInt;
			}
			GetDlgItemText(hWnd, IDC_EDIT_NOISE, (LPTSTR)buf, sizeof(buf));
			tempDouble = atof(buf);
			if (0.0 <= tempDouble && tempDouble < 1.0)
			{
				m_inputAdministrator_noise = tempDouble;
			}
			EndDialog(hWnd, IDOK);
			break;
		case IDCANCEL:
			EndDialog(hWnd, IDCANCEL);
			break;
		default:
			return FALSE;
		}
	default:
		return FALSE;
    }
    return TRUE;
}

bool COption::Read(void)
{
	TCHAR buf[256];
	
	if (m_iniFile == NULL) return false;
	
	GetPrivateProfileString("SOINN_parameter", "lambda", "NOT_FOUND", buf, sizeof(buf), m_iniFile);
	if (strcmp(buf, "NOT_FOUND") == 0)
	{
		m_SOINN_parameter_lambda = DEFAULT_SOINN_parameter_lambda;
	}
	else
	{
		m_SOINN_parameter_lambda = atoi(buf);
	}
	GetPrivateProfileString("SOINN_parameter", "ageMax", "NOT_FOUND", buf, sizeof(buf), m_iniFile);
	if (strcmp(buf, "NOT_FOUND") == 0)
	{
		m_SOINN_parameter_ageMax = DEFAULT_SOINN_parameter_ageMax;
	}
	else
	{
		m_SOINN_parameter_ageMax = atoi(buf);
	}
	GetPrivateProfileString("InputAdministrator", "noise", "NOT_FOUND", buf, sizeof(buf), m_iniFile);
	if (strcmp(buf, "NOT_FOUND") == 0)
	{
		m_inputAdministrator_noise = DEFAULT_inputAdministrator_noise;
	}
	else
	{
		m_inputAdministrator_noise = atof(buf);
	}
	GetPrivateProfileString("OutputWindow", "acnode", "NOT_FOUND", buf, sizeof(buf), m_iniFile);
	if (strcmp(buf, "NOT_FOUND") == 0)
	{
		m_outputWindow_showAcnode = false;
	}
	else
	{
		if (strcmp(buf, "show") == 0)
		{
			m_outputWindow_showAcnode = true;
		}
		else
		{
			m_outputWindow_showAcnode = false;
		}
	}
	
	return true;
}

bool COption::Write(void)
{
	char buf[256];

	if (m_iniFile == NULL) return false;

	sprintf_s(buf, "%d", m_SOINN_parameter_lambda);
	WritePrivateProfileString("SOINN_parameter", "lambda", buf, m_iniFile);
	sprintf_s(buf, "%d", m_SOINN_parameter_ageMax);
	WritePrivateProfileString("SOINN_parameter", "ageMax", buf, m_iniFile);
	sprintf_s(buf, "%.2f", m_inputAdministrator_noise);
	WritePrivateProfileString("InputAdministrator", "noise", buf, m_iniFile);
	if (m_outputWindow_showAcnode)
	{
		WritePrivateProfileString("OutputWindow", "acnode", "show", m_iniFile);
	}
	else
	{
		WritePrivateProfileString("OutputWindow", "acnode", "hide", m_iniFile);
	}
	
	return true;
}

bool COption::OpenDialog(HWND hParentWnd)
{
	HINSTANCE hInstance;
	int result;

	// for vs2005
	//hInstance = (HINSTANCE)GetWindowLong(hParentWnd, GWL_HINSTANCE);
	hInstance = (HINSTANCE)(LONG_PTR)GetWindowLongPtr(hParentWnd, GWL_HINSTANCE);
	// for vs2005
	//result = (int)DialogBoxParam(hInstance, MAKEINTRESOURCE(IDD_OPTION), hParentWnd, (DLGPROC)StaticDlgProc, (LONG)this);
	result = (int)DialogBoxParam(hInstance, MAKEINTRESOURCE(IDD_OPTION), hParentWnd, (DLGPROC)StaticDlgProc, (LPARAM)this);

	if (result != IDOK) return false;

	return true;
}

int COption::GetSOINN_parameter_lambda(void)
{
	return m_SOINN_parameter_lambda;
}

int COption::GetSOINN_parameter_ageMax(void)
{
	return m_SOINN_parameter_ageMax;
}

double COption::GetInputAdministrator_noise(void)
{
	return m_inputAdministrator_noise;
}

bool COption::SetOutputWindow_showAcnode(bool showAcnode)
{
	if (m_outputWindow_showAcnode == showAcnode) return false;

	m_outputWindow_showAcnode = showAcnode;

	return true;
}

bool COption::GetOutputWindow_showAcnode(void)
{
	return m_outputWindow_showAcnode;
}
