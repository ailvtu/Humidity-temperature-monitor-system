#include <reg52.h>
#define uchar unsigned char
#define uint unsigned int

uchar lcd_x,lcd_y,data_byte=0,count;
uchar TH_data,TL_data,RH_data,RL_data,CK_data;
uint TH_temp,TL_temp,RH_temp,RL_temp,CK_temp;
uchar num;
uint  DHTData1,DHTData2;    
uchar  outdata[6];  //
uchar  indata[5];
uchar  count, count_r=0;
uchar  str[6]={"RS232R"};

uchar code table[]="0123456789.";//显示汉字
uchar  data tab[6]={0x00,0x00,0x00,0x00,0x00,0x00};//ŽæŽ¢ÎÂÊª¶ÈÊýŸÝ
uchar code dis1[]={"湿度:       %RH"};
uchar code dis2[]={"温度:       ¡æ"};


sbit RW=P1^0;		//数据线
sbit EN=P1^1;		//时钟线
sbit io = P1^2;    //DHT21总线


/********************************************************************
延时函数100us * 
***********************************************************************/

void delay(unsigned int t)
{
	unsigned int i,j;
	for(i=0; i<t;  i++)
    for(j=0; j<12; j++);
}
void delay_s(uint j)
{   uchar i;
    for(;j>0;j--)
  {     
    for(i=0;i<27;i++);

  }
}
/********************************************************************
***********************************************************************/
void sendbyte(unsigned char zdata)
{
	unsigned int i;
	for(i=0; i<8; i++)
	{
		if((zdata << i) & 0x80)
		{
			RW = 1;
		}
		else 
		{
			RW = 0;
		}
		EN = 0;
		EN = 1;
	}
}

/********************************************************************
* 写命令
***********************************************************************/
void write_com(unsigned char cmdcode)
{
	sendbyte(0xf8);
	sendbyte(cmdcode & 0xf0);
	sendbyte((cmdcode << 4) & 0xf0);
	delay(2);
}

/********************************************************************
* 写数据
***********************************************************************/
void write_data(unsigned char Dispdata)
{

	sendbyte(0xfa);
	sendbyte(Dispdata & 0xf0);
	sendbyte((Dispdata << 4) & 0xf0);
	delay(2);
}

/********************************************************************
* Ãû³Æ : lcdinit()* ¹ŠÄÜ : ³õÊŒ»¯º¯Êý
***********************************************************************/
void lcdinit()
{ 
	delay(20000);
	write_com(0x30);
	delay(50);
	write_com(0x0c);
	delay(50);
}


/********************************************************************
* Ãû³Æ : hzkdis()* ¹ŠÄÜ : ÏÔÊŸ×Ö·ûŽ®
***********************************************************************/
void hzkdis(unsigned char code *s)
{  
	while(*s > 0)
    { 
		write_data(*s);
		s++;
		delay(50);
    }
}

/***************************************************

***************************************************/
SendData(uchar *a)
{
    outdata[0] = a[0]; 
    outdata[1] = a[1];
    outdata[2] = a[2];
    outdata[3] = a[3];
    outdata[4] = a[4];
	outdata[5] = a[5];
    count = 1;
    SBUF=outdata[0];
    while(!TI);
    TI = 0;
 
    SBUF=outdata[1];
    while(!TI);
    TI = 0;

    SBUF=outdata[2];
    while(!TI);
    TI = 0;

    SBUF=outdata[3];
    while(!TI);
    TI = 0;

    SBUF=outdata[4];
    while(!TI);
    TI = 0;
	SBUF=outdata[5];
    while(!TI);
    TI = 0;
}

void delay1()//ÑÓÊ±10us
{
	unsigned char i;
	for(i=0; i<4; i++);
}

/**********************DHT11Ä£¿é**********************/
void receive_byte()//œÓÊÕÒ»žö×ÖœÚ
{
	uchar i,temp;
	for(i=0;i<8; i++)
	{
		count = 2;
		while((!io)&&count++)//µÈŽý50usµÍµçÆœœáÊø£¬²¢·ÀÖ¹ËÀÑ­»·
		temp = 0;
		delay1();
		delay1();
		delay1();
		if (io==1)
		{ 
			temp = 1;
			count = 2;
			while(io && count++);
		}
if(count==1)break;
	
			data_byte<<=1;
			data_byte|=temp;			
	}

}

void read_io()//¿ªÊŒÐÅºÅ£¬¶ÁÊýŸÝ²¢Ð£Ñé
{
	io = 0;
	delay(18);//Ö÷»úÀ­µÍ18ms
	io = 1;//DATA×ÜÏßÓÉÉÏÀ­µç×èÀ­žß Ö÷»úÑÓÊ±20us
	delay1();
	delay1();
	delay1();
	delay1();
	io = 1;//Ö÷»úÉèÖÃÎªÊäÈëžßµçÆœ£¬ÅÐ¶ÏŽÓ»úÏìÓŠÐÅºÅ
	if(!io)
	{	
		count = 2;
		while((!io)&&count++);//ÅÐ¶ÏDHT11·¢³ö80usµÍµçÆœÏìÓŠÐÅºÅÊÇ·ñœáÊø
		count = 2;
		while(io && count++);//ÅÐ¶ÏDHT11À­žß×ÜÏß80usžßµçÆœÊÇ·ñœáÊø
		receive_byte();
		RH_temp = data_byte; 
		receive_byte();
		RL_temp = data_byte; 
		receive_byte();
		TH_temp = data_byte; 
		receive_byte();
		TL_temp = data_byte; 
		receive_byte();
		CK_temp = data_byte;
		io = 1;
		num = (RH_temp + RL_temp + TH_temp + TL_temp);//ÊýŸÝÐ£Ñé

		if(num == CK_temp)
		{
			RH_data = RH_temp;
       		RL_data = RL_temp;
		    DHTData1  = RH_data;
		    DHTData1<<= 8;
		    DHTData1 |= RL_data;//»ñµÃÍêÕûµÄÊª¶È
	   	    tab[0]=DHTData1/100+0x30;  //Êª¶È°ÙÎ»
		    tab[1]=DHTData1%100/10+0x30;//Êª¶ÈÊ®Î»
		    tab[2]=DHTData1%10+0x30;	 //Êª¶ÈžöÎ»


			TH_data = TH_temp; 
       		TL_data = TL_temp;
       		CK_data = CK_temp;	
			DHTData2  = TH_data;
			DHTData2<<=8;
		  	DHTData2 |= TL_data;//»ñµÃÍêÕûµÄÎÂ¶È
	        tab[3]=DHTData2/100+0x30;
		    tab[4]=DHTData2%100/10+0x30;
			tab[5]=DHTData2%10+0x30;
		}
	}
}
/**********************E N D**********************/  

void display_wenshu()
{
  uchar m;
  m = 0 ;
  read_io();
 write_com(0x80);  
hzkdis(" MATLAB TO MCU");
 write_com(0x92); 
hzkdis("ÏÂÎ»»ú");
 //=====ÏÔÊŸÎÂ¶È=====*/
  m = 0 ;
   write_com(0x88);  
   while(dis2[m] != '\0')//ÏÔÊŸ×Ö·û
     {                         
        write_data(dis2[m]) ;
         m++ ;
     }
 
   write_com(0x8B);
   write_data(tab[3]);
   write_data(tab[4]);
   write_data('.');
   write_data(tab[5]);

	m=0;
write_com(0x98);  
    while(dis1[m] != '\0')//ÏÔÊŸ×Ö·û
     {                         
        write_data(dis1[m]) ;
       m++ ;
     }
   write_com(0x9B);
   write_data(tab[0]);
   write_data(tab[1]);
   write_data('.');
   write_data(tab[2]);
}

/*³õÊŒ»¯*/
void serialinit()
{
    TMOD = 0x20;      //¶šÊ±Æ÷T1Ê¹ÓÃ¹€×÷·œÊœ2
    TH1 = 253;        // ÉèÖÃ³õÖµ
    TL1 = 253;
    TR1 = 1;          // ¿ªÊŒŒÆÊ±
    SCON = 0x50;      //¹€×÷·œÊœ1£¬²šÌØÂÊ9600bps£¬ÔÊÐíœÓÊÕ   
    ES = 1;
    EA = 1;           // Žò¿ªËùÒÔÖÐ¶Ï   
    TI = 0;
    RI = 0;
SendData(str) ;   //·¢ËÍµœŽ®¿Ú 
	}
void main()
{    
    serialinit();
	lcdinit();	
	write_com(0x01);
	while(1)
	{
		read_io();//¶ÁÈ¡ÎÂÊª¶ÈÊýŸÝ
		display_wenshu();
          
        str[0]=DHTData1/100+0x30;
        str[1]=DHTData1%100/10+0x30;
        str[2]=DHTData1%10+0x30;
        str[3]=DHTData2/100+0x30;
        str[4]=DHTData2%100/10+0x30;
        str[5]=DHTData2%10+0x30;

       SendData(str) ;  //·¢ËÍµœŽ®¿Ú  
    delay_s(20000);
	}		
}
void RSINTR() interrupt 4 using 2
{
  
    if(RI==1)    //œÓÊÕÖÐ¶Ï       
    {   
        RI = 0;
    }
}
