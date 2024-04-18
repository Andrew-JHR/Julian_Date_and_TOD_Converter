
// JulianDateConvDlg.h : header file
//

#pragma once


// CJulianDateConvDlg dialog
class CJulianDateConvDlg : public CDialogEx
{
// Construction
public:
	CJulianDateConvDlg(CWnd* pParent = nullptr);	// standard constructor

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_JulianDateConv_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnEnChangeEDITIN();
	afx_msg void OnBnClickedCHKJ2G();
	afx_msg void OnBnClickedBTNCONV();
	CString m_IDC_IN;
	CEdit m_IDC_Out;
	BOOL m_IDC_CHK;
};
