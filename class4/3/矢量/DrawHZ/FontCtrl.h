// FontCtrl.h: interface for the CFontCtrl class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_FONTCTRL_H__37B51DC0_BCB7_4E40_97D2_BD0F45B9BD55__INCLUDED_)
#define AFX_FONTCTRL_H__37B51DC0_BCB7_4E40_97D2_BD0F45B9BD55__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#pragma warning(disable: 4786)
#pragma warning(disable: 4503)

#include<vector>
#include<string>
using namespace std;

#define LOCATEX 10
#define LOCATEY 350

#define CHARSIZE 400
#define CHARCOLOR RGB(128, 0, 128)
#define SELECTCOROR RGB(128, 0, 128)



struct ORDER{
	int nOrder;
	POINT pt;
};

struct STROKE{
	int nPoint;
	vector<POINT> pt;
	
};

struct FONTSTROKE{
	int nChar;
	int nStroke;
	vector<STROKE> stroke;

};

class CFontCtrl  
{
public:
	bool SetFont(long nFontSize);
	bool GetStroke(int nChar);
	
	CFontCtrl();
	virtual ~CFontCtrl();
private:
	FIXED FloatToFixed(double d);
	int MapFX(FIXED fx);
	int MapFY(FIXED fy);
	HFONT sysFont;
public:
	bool DrawStroke(CDC *pDc,int x,int y,int nNum);
	
	FONTSTROKE *m_pChar;
	

};

#endif // !defined(AFX_FONTCTRL_H__37B51DC0_BCB7_4E40_97D2_BD0F45B9BD55__INCLUDED_)
