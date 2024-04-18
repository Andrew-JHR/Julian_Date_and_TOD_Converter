
// JulianDataConvDlg.cpp : implementation file
//

#include "pch.h"
#include "framework.h"
#include "JulianDateConv.h"
#include "JulianDateConvDlg.h"
#include "afxdialogex.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg dialog used for App About

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CJulianDataConvDlg dialog



CJulianDateConvDlg::CJulianDateConvDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_JulianDateConv_DIALOG, pParent)
	, m_IDC_IN(_T("YYYYMMDD"))
	, m_IDC_Out()
	, m_IDC_CHK(FALSE)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CJulianDateConvDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_IN, m_IDC_IN);
	DDX_Control(pDX, IDC_Out, m_IDC_Out);
	DDX_Check(pDX, IDC_CHKJ2G, m_IDC_CHK);
}

BEGIN_MESSAGE_MAP(CJulianDateConvDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_EN_CHANGE(IDC_IN, &CJulianDateConvDlg::OnEnChangeEDITIN)
	ON_BN_CLICKED(IDC_CHKJ2G, &CJulianDateConvDlg::OnBnClickedCHKJ2G)
	ON_BN_CLICKED(IDC_BTNCONV, &CJulianDateConvDlg::OnBnClickedBTNCONV)
END_MESSAGE_MAP()


// CJulianDataConvDlg message handlers

BOOL CJulianDateConvDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != nullptr)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CJulianDateConvDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CJulianDateConvDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CJulianDateConvDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CJulianDateConvDlg::OnEnChangeEDITIN()
{
	// TODO:  If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialogEx::OnInitDialog()
	// function and call CRichEditCtrl().SetEventMask()
	// with the ENM_CHANGE flag ORed into the mask.

	// TODO:  Add your control notification handler code here
}


void CJulianDateConvDlg::OnBnClickedCHKJ2G()
{
	// TODO: Add your control notification handler code here
}


void CJulianDateConvDlg::OnBnClickedBTNCONV()
{
	
	UpdateData();
	
	// TODO: Add your control notification handler code here
	if (m_IDC_CHK == FALSE)
	{
		if (m_IDC_IN.GetLength() != 8) 
		{
			AfxMessageBox(_T("Invalid YYYYMMDD Format"));
		}
		CString yyyy = m_IDC_IN.Left(4);
		CString mm   = m_IDC_IN.Mid(4, 2);
		CString dd   = m_IDC_IN.Right(2);
		CString yy   = yyyy.Right(2);
	
		int i_yy = _wtoi(yyyy);
		int i_mm = _wtoi(mm);
		int i_dd = _wtoi(dd);
		
		if (i_yy < 1900) 
		{
			AfxMessageBox(_T("Invalid Year Number"));
		}
		else if (i_mm < 1 || i_mm > 12) 
		{
			AfxMessageBox(_T("Invalid Month Number"));
		}
		else if (i_dd < 1 || i_dd > 31)
		{
			AfxMessageBox(_T("Invalid Day Number"));
		}
		else if ((i_mm == 4 || i_mm ==6 || i_mm == 9 || i_mm == 11) && i_dd > 30)
		{
			AfxMessageBox(_T("Invalid Day Number"));
		}
		else if (i_mm == 2 && i_dd > 29)
		{
			AfxMessageBox(_T("Invalid Day Number"));
		}
		else if (i_mm == 2 && i_dd > 28)
		{
			if (i_yy % 4 != 0)
			{
				AfxMessageBox(_T("Invalid Day Number"));
			}
			else if (i_yy % 100 == 0 && i_yy % 400 != 0)
			{
				AfxMessageBox(_T("Invalid Day Number"));
			}
		}
		int jln1 = (1461 * (i_yy + 4800 + (i_mm - 14) / 12)) / 4      + 
			       (367 * (i_mm - 2 - 12 * ((i_mm - 14) / 12))) / 12  - 
			       (3 * ((i_yy + 4900 + (i_mm - 14) / 12) / 100)) / 4 + 
			       i_dd - 32075;
		int jln0 = (1461 * (i_yy + 4800 + (1 - 14) / 12)) / 4         + 
			       (367 * (1 - 2 - 12 * ((1 - 14) / 12))) / 12        - 
			       (3 * ((i_yy + 4900 + (1 - 14) / 12) / 100)) / 4    + 
			        1 - 32075;
		int jln2 = jln1 - jln0 + 1;
		
		CString julian;
		julian.Format(_T("%03d"), jln2);
		m_IDC_Out.SetWindowText(yy + julian);
	}
	else
	{
		if (m_IDC_IN.GetLength() != 5)
		{
			AfxMessageBox(_T("Invalid YYJJJ Format"));
		}
		CString yyyy;
		yyyy.Format(_T("20%s"),m_IDC_IN.Left(2));
		CString jjj = m_IDC_IN.Right(3);
		int i_yy = _wtoi(yyyy);
		int i_jjj = _wtoi(jjj);
		int jln0 = (1461 * (i_yy + 4800 + (1 - 14) / 12)) / 4 +
			(367 * (1 - 2 - 12 * ((1 - 14) / 12))) / 12 -
			(3 * ((i_yy + 4900 + (1 - 14) / 12) / 100)) / 4 +
			1 - 32075;
		int jln2 = jln0 + i_jjj - 1;
		int f = jln2 + 68569;
    	int e = (4 * f) / 146097;
		int g = f - (146097 * e + 3) / 4;
		int h = 4000 * (g + 1) / 1461001;
		int t = g - (1461 * h / 4) + 31;
		int u = (80 * t) / 2447;
		int v = u / 11;
		int year = 100 * (e - 49) + h + v;
		int	mon = u + 2 - 12 * v;
		int day = t - 2447 * u / 80;
		CString yy;
		yy.Format(_T("%d"), year);
		CString mm;
		mm.Format(_T("%02d"), mon);
		CString dd;
		dd.Format(_T("%02d"), day);
		m_IDC_Out.SetWindowText(yy + mm + dd);
	}
	
}
