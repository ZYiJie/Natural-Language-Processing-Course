// DrawHZ.h : main header file for the DRAWHZ application
//

#if !defined(AFX_DRAWHZ_H__86612B21_BFD0_4B57_B2CE_AA3340DDDFE4__INCLUDED_)
#define AFX_DRAWHZ_H__86612B21_BFD0_4B57_B2CE_AA3340DDDFE4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CDrawHZApp:
// See DrawHZ.cpp for the implementation of this class
//

class CDrawHZApp : public CWinApp
{
public:
	CDrawHZApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDrawHZApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CDrawHZApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DRAWHZ_H__86612B21_BFD0_4B57_B2CE_AA3340DDDFE4__INCLUDED_)
