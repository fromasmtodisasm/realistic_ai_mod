#ifndef _OPTION_HEADER_
#define _OPTION_HEADER_

#include <windows.h>

class COption
{
public:
	COption(const char *iniFile);
	~COption();
	static LRESULT CALLBACK StaticDlgProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	LRESULT CALLBACK DlgProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	bool Read(void);
	bool Write(void);
	bool OpenDialog(HWND hParentWnd);
	int GetSOINN_parameter_lambda(void);
	int GetSOINN_parameter_ageMax(void);
	double GetInputAdministrator_noise(void);
	bool SetOutputWindow_showAcnode(bool showAcnode);
	bool GetOutputWindow_showAcnode(void);

private:
	char *m_iniFile;
	int m_SOINN_parameter_lambda;
	int m_SOINN_parameter_ageMax;
	double m_inputAdministrator_noise;
	bool m_outputWindow_showAcnode;

	static const int DEFAULT_SOINN_parameter_lambda;
	static const int DEFAULT_SOINN_parameter_ageMax;
	static const double DEFAULT_inputAdministrator_noise;
	static const char* PROPNAME;
};

#endif
