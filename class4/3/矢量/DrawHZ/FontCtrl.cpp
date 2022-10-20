// FontCtrl.cpp: implementation of the CFontCtrl class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "FontCtrl.h"
#include<stdio.h>
#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CFontCtrl::CFontCtrl()
{
	sysFont = NULL;
	m_pChar = NULL;
}

CFontCtrl::~CFontCtrl()
{
	
}


bool CFontCtrl::GetStroke(int nChar)
{
	DWORD dwSize;
	HDC  hdcGlyph;
	GLYPHMETRICS gm;
	MAT2 m2;    
	LPTTPOLYGONHEADER lpph;
	long   cbOutline, cbTotal;
	LPBYTE lpb;
	
	if( m_pChar != NULL ){
		delete m_pChar;
	}
	m_pChar = new FONTSTROKE;
    
	m2.eM11 = FloatToFixed(1.0);
	m2.eM12 = FloatToFixed(0.0);
	m2.eM21 = FloatToFixed(0.0);
	m2.eM22 = FloatToFixed(1.0);
	
	hdcGlyph = CreateDC("DISPLAY",NULL,NULL,NULL);
	if (sysFont != NULL)
		SelectObject(hdcGlyph, sysFont);
	else 
        return false;
	
	dwSize = GetGlyphOutline(hdcGlyph,nChar,GGO_NATIVE,&gm,0L,NULL,&m2);
	lpph = (LPTTPOLYGONHEADER)new char[dwSize];
	GetGlyphOutline(hdcGlyph,nChar,GGO_NATIVE,&gm,dwSize,lpph,&m2);
	cbTotal = dwSize;
	
	while( cbTotal > 0 ){
		      STROKE stroke;
			  POINT pt;
			  stroke.nPoint = 0;
			  
			  pt.x = MapFX(lpph->pfxStart.x);
			  pt.y = MapFX(lpph->pfxStart.y);
			  stroke.pt.push_back(pt);
			  stroke.nPoint++;
			  lpb   = (LPBYTE)lpph + sizeof(TTPOLYGONHEADER);
			  // Calculate size of data needed
              cbOutline = (long)lpph->cb - sizeof(TTPOLYGONHEADER);
			  
			  
			  while( cbOutline > 0 ){
				  int i, n;
				  
				  LPTTPOLYCURVE lpc;
				  lpc = (LPTTPOLYCURVE)lpb;
				  for( i = 0; i < (int)lpc->cpfx; i++ ){
					  pt.x = MapFX(lpc->apfx[i].x);
					  pt.y = MapFX(lpc->apfx[i].y);
					  stroke.pt.push_back(pt);
					  stroke.nPoint++;
				  }
				  n = sizeof(TTPOLYCURVE) + sizeof(POINTFX) * (lpc->cpfx - 1);
				  lpb += n;
				  cbOutline -= n;
				  
			  }   
			  
			  cbTotal -= lpph->cb;
			  lpph     = (LPTTPOLYGONHEADER)lpb;
			  m_pChar->stroke.push_back(stroke);
			  m_pChar->nStroke = m_pChar->stroke.size();
			  m_pChar->nChar = nChar;
			  
			  
	}
	
	return false;
	
}



FIXED CFontCtrl::FloatToFixed(double d)
{
	long l;
	
	l = (long)(d * 65536L);
	return *(FIXED *)&l;
}

bool CFontCtrl::SetFont(long nFontSize)
{
	LOGFONT lf;
	
	// Let's fill out a LOGFONT structure so that we can have an initial font.
	lf.lfHeight=nFontSize;
	lf.lfWidth=0;
	lf.lfEscapement=lf.lfOrientation=0;
	lf.lfWeight=FW_NORMAL;
	lf.lfItalic=0;
	lf.lfUnderline=0;
	lf.lfStrikeOut=0;
	lf.lfCharSet=GB2312_CHARSET;
	lf.lfOutPrecision=OUT_TT_ONLY_PRECIS;
	lf.lfClipPrecision=CLIP_DEFAULT_PRECIS;
	lf.lfQuality=DEFAULT_QUALITY;
	lf.lfPitchAndFamily=FF_DONTCARE;
	lstrcpy(lf.lfFaceName,"¿¬Ìå_GB2312");
	
	sysFont = CreateFontIndirect(&lf);
	return false;
	
}

int CFontCtrl::MapFX(FIXED fx)
{
	long   lx;
	
	lx = *(LONG *)&fx;
	return (int)((double)(lx)/65536.0);
}

int CFontCtrl::MapFY(FIXED fy)
{
	long   ly;
	
	ly = *(LONG *)&fy;
	return (int)((double)(ly) / 65536.0);
}


bool CFontCtrl::DrawStroke(CDC *pDc,int x,int y,int nNum)
{
	int xOld=m_pChar->stroke[nNum].pt[0].x;
	int yOld=m_pChar->stroke[nNum].pt[0].y;
	int xNew,yNew;
	HPEN	hpen = CreatePen(PS_SOLID, 2, CHARCOLOR);
	HPEN	hpenOld = (HPEN)pDc->SelectObject(hpen);
	for(int i=0;i<m_pChar->stroke[nNum].pt.size();i++){
		xNew = m_pChar->stroke[nNum].pt[i].x;
		yNew = m_pChar->stroke[nNum].pt[i].y;
		pDc->Ellipse(x+xOld-5,y-yOld-5,x+xOld+5,y-yOld+5);
		pDc->MoveTo( x+xOld, y-yOld);
		pDc->LineTo( x+xNew, y-yNew );
		xOld = xNew;
		yOld = yNew;
	}
	pDc->Ellipse(x+xOld-5,y-yOld-5,x+xOld+5,y-yOld+5);
	xNew=m_pChar->stroke[nNum].pt[0].x;
	yNew=m_pChar->stroke[nNum].pt[0].y;
	pDc->MoveTo( x+xOld, y-yOld);
	pDc->LineTo( x+xNew, y-yNew );

	pDc->SelectObject(hpenOld);
	DeleteObject(hpen);
	return true;
}


