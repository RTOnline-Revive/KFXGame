//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXBotChatMessage extends LocalMessage;

// A BotDialog.
struct KFXBotDialog
{
 var  array<string>   DialogArray;         //读取的实际长度 array.length
 var  int             DialogAskNumber;    //要求的对话长度
 var  int             DialogCurNumber;     //当前使用长度
};
// csv use
const MAXCHATLINK=3;
const CHATBEGINROW = 0;
 var localized string LINKDIALOG1;
 var localized string LINKDIALOG2;
 var localized string LINKDIALOG3;
 var localized string CHATMEG;
 //error string
 var localized string ERRORSTRING;
 //save the current dialog;
 var   KFXBotDialog curDialog; //Cache

static function bool InitADialog(int dlgnum )
{
    local KFXCSVTable CFG_BotDialog;
    local int currow;
    local int tmprowid[MAXCHATLINK];
    local int i;
    local string tmpstr;

    if(dlgnum<=0)
       return false;

    ClearDialogCache();
    default.curDialog.DialogAskNumber=dlgnum;
    default.curDialog.DialogCurNumber=0;
    currow= 0  ;
    CFG_BotDialog = class'KFXTools'.static.GetConfigTable(900);

     for(i=0;i<=dlgnum;i++)
     {
          if ( !CFG_BotDialog.SetCurrentRow(currow) )
       {
         Log("[KFXBotChatMessage] InitAttachmentData Can't Resolve the Chat ID(Attachment Table) :");
          return false;
       }

        tmprowid[0] = CFG_BotDialog.GetInt("IDr1");
        tmprowid[1] = CFG_BotDialog.GetInt("IDr2");
        tmprowid[2] = CFG_BotDialog.GetInt("IDr3");
        currow=tmprowid[Rand(3)];
        if(i!=0)
        {
        default.curDialog.DialogArray.Insert( default.curDialog.DialogArray.Length, 1 );
        tmpstr=  CFG_BotDialog.GetString("chatcontent");
         Log("[KFXBotChatMessage] jinxinw------ :"$tmpstr);
		default.curDialog.DialogArray[default.curDialog.DialogArray.Length-1] = tmpstr;
		 }
     }
      Log("[KFXBotChatMessage] jinxin1------InitADialog over");
}
static function bool IsDialogInuse()
{
    //  return   (default.curDialog.DialogArray.Length>0)&& (default.curDialog.DialogArray.Length > default.curDialog.DialogCurNumber )?true:false;
    if((default.curDialog.DialogArray.Length>0)&& (default.curDialog.DialogArray.Length > default.curDialog.DialogCurNumber ))
       return true;
    else
       return false;
}
static function  int GetDialogActualityLen()
{
       return    default.curDialog.DialogArray.Length;
}
static function  int GetDialogAskLen()
{
       return    default.curDialog.DialogAskNumber;
}
static function  ClearDialogCache()
{
    default.curDialog.DialogArray.Remove(0,default.curDialog.DialogArray.Length);
    default.curDialog.DialogAskNumber=0;
    default.curDialog.DialogCurNumber=0;
}
static function string GetFirstChat()
{
       default.curDialog.DialogCurNumber=1;
       return    default.curDialog.DialogArray[0];

}
static function string GetChatByNum(int num)
{
                 default.curDialog.DialogCurNumber = num+1;
       return    default.curDialog.DialogArray[num];

}
static function string GetANewDialogFirstChat(int num)
{
     local bool b;
       b = InitADialog(num);
      if(!b)
            return default.ERRORSTRING;
            default.curDialog.DialogCurNumber++;
       return    default.curDialog.DialogArray[0];

}
static function string GetNext()
{
    if(default.curDialog.DialogCurNumber<=default.curDialog.DialogArray.Length)
    {
           default.curDialog.DialogCurNumber++;
           return  default.curDialog.DialogArray[default.curDialog.DialogCurNumber-1];

    }
       return default.ERRORSTRING;
}

defaultproperties
{
     LINKDIALOG1="IDr1"
     LINKDIALOG2="IDr2"
     LINKDIALOG3="IDr3"
     CHATMEG="聊天内容"
     ERRORSTRING="errorstr"
     DrawColor=(R=100)
}
