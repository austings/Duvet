/*
*Programming by Austin Sierra
* For TempleOS Foundation
* Original song and video by Boa
*
*/
Cd(__DIR__);;
#include "Sprites.HC";

U8* currentLine;
U0 GrChar(CDC *dc=gr.dc,U8 ch,I64 x,I64 y,I64 scale)
{
 I64 i,j,k=0;
 for(i=0;i<FONT_HEIGHT;i++){
  for(j=0;j<FONT_WIDTH;j++){
   if(Bt(&text.font[ch],k++)){
    GrRect(dc,x+j*scale,y+i*scale,scale,scale);
   }
  }
 }
}
public U0 PrintPlay(U8 *st,U8 *words=NULL)
{
  U8 *word,*last_st;
  I64 note,octave,i=0,ona,timeout_val,timeout_val2;
  Bool tie;
  F64 d,on_jiffies,off_jiffies;
  music.play_note_num=0;
  while (*st) {
    timeout_val=cnts.jiffies;
    tie=FALSE;

    do {
      last_st=st;
      if (*st=='(') {
	tie=TRUE;
	st++;
      } else {
	st=MusicSetMeter(st);
	st=MusicSetOctave(st);
	st=MusicSetNoteLen(st);
      }
    } while (st!=last_st);

    if (!*st) break;
    note=*st++-'A';
    if (note<7) {
      note=music.note_map[note];
      octave=music.octave;
      if (*st=='b') {
	note--;
	if (note==2)
	  octave--;
	st++;
      } else if (*st=='#') {
	note++;
	if (note==3)
	  octave++;
	st++;
      }
      ona=Note2Ona(note,octave);
    } else
      ona=0;
    if (words && (word=LstSub(i++,words)) && StrCmp(word," "))
      currentLine = MStrPrint("%s%s",currentLine, word);

    d=JIFFY_FREQ*music.note_len/music.tempo;
    on_jiffies	=d*music.stacatto_factor;
    off_jiffies =d*(1.0-music.stacatto_factor);

    timeout_val+=on_jiffies;
    timeout_val2=timeout_val+off_jiffies;

    if (!music.mute)
      Snd(ona);
    SleepUntil(timeout_val);
    music.tM_correction+=on_jiffies-ToI64(on_jiffies);

    if (!music.mute && !tie)
      Snd;
    SleepUntil(timeout_val2);
    music.tM_correction+=off_jiffies-ToI64(off_jiffies);

    music.play_note_num++;
  }
}
I64 counter = 0;

U0 DrawIt(CTask *task,CDC*dc)
{
 I64 i;
 dc->color = BLACK;
 GrRect(dc,0,0,640,480);
 Sprite3(dc,0,0,0,GetBG);
 dc->color = WHITE;
 for(i=0;i<StrLen(currentLine);i++)
 {     
    GrChar(dc,currentLine[i],10+i*15,10,2);
 }
}

U0 Verse1()
{
 music.tempo = 3;
 music.stacatto_factor = .5;
 PrintPlay("q4DC#3B4C#DeE",
      "And \0you \0don't \0seem \0to \0under\0");
 Play("2GB3D");
 Play("qF#");
 Play("tte2GB3D..");
 PrintPlay("3qBAhBA",
      "stand.\0");
 Play("e3F#B3D");
 Play("e3F#B3D");
 currentLine = "";
 PrintPlay("4qDC#3B4C#4DEeF#EEC#qDhC#",
      "A \0shame \0you \0seemed \0an \0honest \0man.\0");
 currentLine = "";
 PrintPlay("4qDC#3B4C#DEF#3eBAhBA",
      "And \0all \0the \0fears \0you \0hold \0so \0dear,\0");
 currentLine = "";
 PrintPlay("4qDC#3B4C#DEeF#EEC#qDhC#",
      "Will \0turn \0to \0whis\0per \0in \0your \0ear.\0");
 currentLine = "";
 PrintPlay("3eBB4F#F#EF#EEF#qEE",
      "And \0you \0know \0what \0they \0say \0might \0hurt \0you;\0");
 currentLine = "";
 PrintPlay("3eBB4F#F#F#qF#eEF#AhE",
      "And \0you \0know \0that \0it \0means \0so \0much;\0");
 currentLine = "";
 PrintPlay("4qDC#3B4C#DeE3qBBe4F#EC#qDhC#",
      "And \0you \0don't \0even \0feel \0a \0thing.\0");
}

U0 Verse2()
{
 currentLine = "";
 PrintPlay("4qDC#3B4C#DEF#3eBAhBA",
      "And \0you \0don't \0seem \0the \0lying \0kind. \0");
 currentLine = "";
 PrintPlay("4qDC#3B4C#4DEeF#EEC#qDhC#", 
      "A \0shame \0that \0I \0can \0read \0your \0mind. \0");
 currentLine = "";
 PrintPlay("4qDC#3B4C#DEF#3eBAhBA", 
     "And \0all \0the \0things \0that \0I \0read \0there, \0");
 currentLine = "";
 PrintPlay("4qDC#3B4C#DEeF#EEC#qDhC#", 
      "Candle\0lit \0smile \0that \0we \0both \0share. \0");
 currentLine = "";
 PrintPlay("3eBB4F#F#EF#EEF#qEE",
      "And \0you \0know \0I \0don't \0mean \0to \0hurt \0you, \0");
 currentLine = "";
 PrintPlay("3eBB4F#F#F#qF#eEF#AhE", 
      "But \0you \0know \0that \0it \0means \0so \0much, \0");
 currentLine = "";
 PrintPlay("4qDC#3B4C#DeE3qBBe4F#EC#qDhC#", 
      "And \0you \0don't \0even \0feel \0a \0thing.\0");

}

U0 PreChorus()
{
 currentLine = "";
 PrintPlay("4hBqAE.EtqE","\nI am \0falling,\0");
 currentLine = "";
 PrintPlay("4hBqBAE.EtqE.F#t","I am \0fading.\0");
 currentLine = "";
 PrintPlay("4qBAE.EtE.EtD.Eth3B","I have \0lost \0it \0all.\0");

}

U0 Chorus()
{

 currentLine = "";
 PrintPlay("4qBAEhEqE","I \0am \0fall\0ing, \0");
 currentLine = "";
 PrintPlay("4qBBAEhEqEhF#","I \0am \0fad\0ing.\0");
 currentLine = "";
 PrintPlay("4qBBAqEhEqEhF#","I \0am \0drown\0ing.\0");
 currentLine = "";
 PrintPlay("4qDDDGAhF#", "Help \0me \0to \0breathe. \0");
 currentLine = "";
 PrintPlay("4qBAqEhEqEF#", "I \0am \0hurting,\0");
 currentLine = "";
 PrintPlay("4qBAqEhEqEEF#", "I \0have \0lost \0it \0all,\0");
 currentLine = "";
 PrintPlay("4qBAqEhEqEF#", "I \0am \0losing,\0");
 currentLine = "";
 PrintPlay("4qDDDGAwF#", "Help \0me \0to \0breathe.\0");


}

U0 Bridge()
{
 currentLine = "";
 Play("4qAAAAA5C#DC#4B5C#ED");
 Play("5qF#EDC#DC#DC#BB");
 Play("4qAAAAA5C#DC#4B5C#ED");
 Play("5qF#EF#EF#EF#");
 Play("BBB");

 Play("4eF#GF#GAF#ABAB5C#4B");
 Play("5eDEF#GwF#");
 Play("5eF#GF#DED4ABwA");

 Play("3qB4AF#DE");
 Play("4eF#GF#GAGABAB5C#4B5C#DEGwF#");
 Play("5eF#HG#DED4ABAABqAeBABhA");
}

U0 Outro()
{
 currentLine = "";
 PrintPlay("4..wAttrqF#ADD3wB", 
      "Oh\0-\0oh, \0ye\0ah \0");
 currentLine = "";
 PrintPlay("wArqBwArqAeF#qAeF#qAeF#qAeF#hAqBF#hAeF#ED4BAwB", 
      "Oh-\0oh-\0oh-\0oh, \0ye\0ah.\0");

}

U0 Run(){
 WinMax;
 WinBorder;
 DocCursor;
 DocClear;

 Fs->draw_it=&DrawIt; 

 Verse1;
 PreChorus;
 Verse2;
 Chorus;
 Bridge;
 Chorus;
 Outro;
 Chorus;
 Play("4qDhEwD");
 currentLine = "";
 currentLine = MStrPrint("%s%s",currentLine, "H");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "e");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "l");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "l");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "o");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, " ");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "L");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "a");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "i");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "n");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, ".");Sleep(2500);
 currentLine = "";

 currentLine = MStrPrint("%s%s",currentLine, "N");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "o");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, " ");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "n");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "e");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "w");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, " ");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "m");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "a");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "i");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, "l");Sleep(500);
 currentLine = MStrPrint("%s%s",currentLine, ".");Sleep(2500);

} Run;