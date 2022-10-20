// DrawHZDlg.h : header file
//

#if !defined(AFX_DRAWHZDLG_H__1319EEE0_2BE1_4EA1_A3D9_0485202321D9__INCLUDED_)
#define AFX_DRAWHZDLG_H__1319EEE0_2BE1_4EA1_A3D9_0485202321D9__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CDrawHZDlg dialog

class CDrawHZDlg : public CDialog
{
// Construction
public:
	CDrawHZDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CDrawHZDlg)
	enum { IDD = IDD_DRAWHZ_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDrawHZDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CDrawHZDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnShow();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DRAWHZDLG_H__1319EEE0_2BE1_4EA1_A3D9_0485202321D9__INCLUDED_)
