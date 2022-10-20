// ShowHZ.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
FILE* g_fpHZK=NULL;
unsigned char g_Mask[8]={0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01};
void HZKExit();



bool InitHZK(char* psHZFile)
{
	HZKExit();
	g_fpHZK=fopen(psHZFile,"rb");
	if ( psHZFile == NULL )
		return false;
	return true;

}

bool GetHZDot(char* psHZ,unsigned char* pcHZInfo)
{
	int nOffset=32*(((unsigned char)psHZ[0]-0xa0-1)*94+((unsigned char)psHZ[1]-0xa0-1));
	if ( fseek(g_fpHZK,nOffset,SEEK_SET) )
		return false;

	if ( fread(pcHZInfo,sizeof(unsigned char),32,g_fpHZK) == 0 )
		return false;
	return true;
}

void HZKExit()
{
	if ( g_fpHZK != NULL ){
		fclose(g_fpHZK);
		g_fpHZK=NULL;
	}
}

void ShowHZ(char* psHZ)
{
	unsigned char pcHZInfo[32];
	GetHZDot(psHZ,pcHZInfo);

	for( int i=0;i<32;i++ ){
		 for(int j=0;j<8;j++){
			 if ( (g_Mask[j]&pcHZInfo[i]) != 0 ){
				printf("#");
			 }else{
				printf(" ");
			 }
		 }
		 if(1==i%2)
		 {
			printf("\n");
		 }
 
	}

	

}


int main(int argc, char* argv[])
{

	InitHZK("hzk.dat");
	ShowHZ("´ó");
	HZKExit();

}


