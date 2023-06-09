//-----------------------------------------------------------
//Author£ºÍõð© µÀ¾ßÏµÍ³µÄ¸ÄÔì 2009-12-06
//Design£º½«µÀ¾ßÒÔÊµÌåµÄ·½Ê½ÊµÏÖ£¬¶ø²»ÊÇ³ÖÐøµÄÔÚpawnºÍplayerµÈ»ùÀàÖÐÌí¼ÓÊôÐÔ¡£
//Usage£º1=¿¨Æ¬ÀàµÄ»ùÀà£¬Ìá¹©»ù±¾µÄÊÂ¼þ£¬³éÏó½Ó¿Ú
//Usage£º2=ÊµÏÖ³£ÓÃ²Ù×÷
//Document£º\\storage\3-Fox1\1-Dev\Personal\WangHao\ÕýÊ½ÎÄµµ\µÀ¾ß¿¨Æ¬ÏµÍ³Éý¼¶Ìá°¸_ÕýÊ½.wps
//-----------------------------------------------------------
class KFXCard extends Actor;

replication
{
    reliable if(Role == Role_Authority)
        PropID;
}

//----------½á¹¹Ìå¶¨ÒåÉùÃ÷----------
//Usage:´¦ÀíHUD¼ÆÊ±ºÍÀäÈ´µÄÂß¼­
struct KFXCardTimer
{
    var float EffectStartTime;    //µÀ¾ßÊ¹ÓÃ¿ªÊ¼Ê±¼ä
    var float EffectDuration;     //µÀ¾ßÊ¹ÓÃÊ±¼ä
    var float CoolDownStartTime;  //µÀ¾ßÊ¹ÓÃÀäÈ´¿ªÊ¼£¨Í¨³£ºÍµÀ¾ßÊ¹ÓÃÍ¬Ê±¿ªÊ¼£¬Í¨³£ÊÇ£¬²»¾ø¶Ô£©
    var float CoolDownDuration;   //µÀ¾ßÀäÈ´Ê±¼ä
};

//Usage£º´¦Àí½ø¶ÈÌõ£¬¶ÁÌõµÄÂß¼­
struct KFXProgressBar
{
   var float ProgressBarStartTime; //¶ÁÌõ¿ªÊ¼
   var float progressBarDuration;  //¶ÁÌõ×ÜÊ±¼ä
   var float ProgressBarPercent;   //¶ÁÌõ°Ù·Ö±È
};

//----------Ë½ÓÐµÄ³ÉÔ±Ð´ÔÚÕâÀï ----------
var protected int PropID;            //¿¨Æ¬ID

//----------Common Functions----------
//Usage: Set PropID
//param1: µÀ¾ß×ÜID£¬ÊäÈë²ÎÊý
//Author: hawk Wang 2009-12-18
//Modify:2009-12-29 È¡ÏûFinalº¯Êý¡£
Function KFXSetPropID(int inPropID)
{
    self.PropID = inPropID;
}

//Usage: »ñÈ¡¸ßÎ»ID£¬´óÀàID
//Return: ¸ßÎ»ID
//Author: Hawk Wang 2009-12-18
Function Final int  KFXGetHighID()
{
    return (PropID >> 16);
}

//Usage: »ñÈ¡µÍÎ»ID£¬Ð¡ÀàID
//Return: µÍÎ»ID
//Author: Hawk Wang 2009-12-18
Function Final int  KFXGetLowID()
{
    return (PropID % 65536);
}

//----------Level 1 Functions---------
//----------For All SubClass----------

//Usage: Ê¹ÓÃ´ÓCSV±íÖÐ¶ÁÈ¡µÄÊý¾Ý£¬ÉèÖÃ¿¨Æ¬µÄÊôÐÔ
//param1£º´ò¿ªµÄCSV±í PropsµÄÒýÓÃ¡£
//return: ¿¨Æ¬ÊÇ·ñ³õÊ¼»¯³É¹¦¡£
//Author£ºHawk Wang 2009-12-18
//Call£º³õÊ¼»¯ÀíÂÛÉÏÓ¦¸ÃÖ»µ÷ÓÃÒ»´Î¡£¶þ´Îµ÷ÓÃÓ¦¸Ãµ÷ÓÃReset¶ø²»ÊÇinit
//Implement:´ÓCSVÖÐ»ñÈ¡Êý¾Ý£¬²¢³õÊ¼»¯¶¨ÒåµÄ²ÎÊý,Ö´ÐÐÆäËû¿¨Æ¬³õÊ¼»¯µÄ²Ù×÷
Function bool OnInitCard(int inPropID)
{
    PropID = inPropID;
    return true;
}

//Usage£ºÖØÖÃ¿¨Æ¬ £¬×¢Òâ¶ÁÈ¡CSVµÄÖµÊÇ²»Ó¦¸ÃÔÚ ResetÖÐÖØÖÃµÄ¡£
//Usage:ÕâÀïÖ÷ÒªÖØÖÃ¼ÆÊ±Æ÷
//return:¿¨Æ¬ÊÇ·ñÖØÖÃ³É¹¦£¬Ò»°ã¶¼ÊÇtrue¡£Ô¤ÁôÎ»¡£
//Author:Hawk Wang 2009-12-18
//Call: ÔÚÃ¿´ÎPawnÖØÉúµÄÊ±ºò£¬Ó¦¸ÃReset¿¨Æ¬¡£¶ø²»ÊÇ·´¸´´´½¨¶ÔÏó
//Implement:ÖØÖÃ¼ÆÊ±Æ÷£¬bCardReady£¬µÈÖµ¡£
Function bool OnResetCard();

//Usage: ÔÚ¿¨Æ¬×°±¸ºóÒ»´ÎÐÔ¸Ä±äÈËÎïµÄÄ³¸öÊôÐÔÖµ£¬ÈçÑªÁ¿ÉÏÏÞ¡£
//Param1:ÓÎÏ·Õß
//Param2:¿ÉÑ¡£¬actor£¬À©Õ¹ÓÃ
//return:ÊÇ·ñ³É¹¦Ó¦ÓÃÊôÐÔ
//Author:Hawk Wang 2009-12-18
//Call:1=ÔÚ×°ÔØPawnµÄÎäÆ÷µÄÊ±ºòµ÷ÓÃ£¬Òò´Ë´©½øÈ¥µÄÊÇinPawn±È½ÏºÏÊÊ¡£
//Implement:Ê¹ÓÃÕâÐ©»ùÅÌÌá¹©µÄ½Ó¿Ú£¬ÊµÏÖ¿¨Æ¬¹¦ÄÜ
//Diffe:Õâ¸öÍ¨³£ÊÇ×°±¸¿¨Æ¬ºóÒ»´ÎÐÔÉúÐ§µÄ£¬¿ÉÒÔ×Ô¶¯µ÷ÓÃ£¬OnTriggerÏµÍ¨³£ÊÖ¶¯µ÷
Function bool OnApplyCardEffect(KFXPawn inPawn,optional Actor inActor);

//-----Level 2 Functions--------------
//-----For Trigger And Complex Card---

//Usage:¿ÉÄÜÔÚÄ³¸öº¯ÊýÖÐ£¬´¥·¢Õâ¸ö¹¦ÄÜ£¬Èç±¬Õ¨¼ÆÉËº¦Ê±
//Param2:¿ÉÑ¡£¬pwan£¬ÓÐ¿ÉÄÜ»áÓÃËüÀ´ÅÐ¶Ï¿¨Æ¬Ê¹ÓÃÌõ¼þ
//Param3:¿ÉÑ¡£¬ÎäÆ÷£¬ÓÐ¿ÉÄÜ»áÓÃËüÀ´ÅÐ¶Ï¿¨Æ¬Ê¹ÓÃÌõ¼þ
//return:ÊÇ·ñ³É¹¦Ó¦ÓÃÊôÐÔ
//Author:Hawk Wang 2009-12-18
//call:1=ÔÙÓÃ»§°´ÏÂÄ³¸ö¼üµÄÊ±ºòµ÷ÓÃËû¡£
//Implement:1=¿ªÊ¼¼ÆÊ±£»¿¨Æ¬ÉúÐ§Âß¼­¡£
//call:2=ÔÚÄ³¸öº¯ÊýÖÐ´¥·¢²¢µ÷ÓÃ,Ã¿´Îµ÷ÓÃÕâ¸öº¯Êý£¬¶¼ÒâÎ¶×ÅÒªÔÚ»ùÅÌÖÐÌí¼ÓÒ»ÐÐ
//call:2=µ÷ÓÃ´úÂë¡£¿´ÔÚÉÏµÛµÄ·ÝÉÏ£¬¾¡Á¿±ÜÃâÕâ¸öº¯ÊýµÄµ÷ÓÃ°É
//Implement:1=ÅÐ¶Ï¿¨Æ¬µÄÊ¹ÓÃÌõ¼þ£¬Èç¹ûÐèÒªµÄ»°¡£
//Implement:2=Ê¹ÓÃ»ùÅÌµÄÊôÐÔ£¬ÊµÏÖº¯Êý¹¦ÄÜ£¬ÈçÉËº¦¹«Ê½Ìæ»»
Function bool OnTriggerCardEffect(KFXPlayer inPlayer,optional Actor inActor);

//Usage:Ô¤·ÀÉÏÃæÎÞ·¨Óö¼ûµÄÐèÇó,À©Õ¹ÓÃ
Function bool OnTriggerCardEffectEX(object inObj,optional object inObj2);

//Usage:ÐÞ¸Ä¹«Ê½ÓÃ
//Param1-4:Êä³ö²ÎÊý£¬ÐÞ¸Ä¹«Ê½ÓÃ¡£
//Author£ºHawk Wang 2009-12-18
//call:1=ÏÈÅÐ¶ÏÊÇ·ñ×°±¸¿¨Æ¬£¬µ÷ÓÃ²¢ÐÞ¸Ä¹«Ê½£¬×ß¿¨Æ¬µÄ¹«Ê½Ìæ´úÔ­¹«Ê½
//call:2=µ÷ÓÃÕâ¸öº¯Êý¶àÉÙÒâÎ¶×Å»ùÅÌ²»ÍêÃÀ......
Function bool OnTriggerCardEffectFloat(out float param1,out optional float param2,out optional float param3,out optional float param4);

//Usage:ÐÞ¸ÄStringÓÃ£¬Èç×ÊÔ´ID£¬Ò²¿ÉÒÔ°Ñ String×ª³ÉÊýÖµÓÃ
//Param1-4:Êä³ö²ÎÊý£¬ÐÞ¸Ä¹«Ê½ÓÃ¡£
//Author£ºHawk Wang 2009-12-18
//call:1=ÏÈÅÐ¶ÏÊÇ·ñ×°±¸¿¨Æ¬£¬µ÷ÓÃ²¢ÐÞ¸Ä¹«Ê½£¬×ß¿¨Æ¬µÄ¹«Ê½Ìæ´úÔ­¹«Ê½
//call:2=µ÷ÓÃÕâ¸öº¯Êý¶àÉÙÒâÎ¶×Å»ùÅÌ²»ÍêÃÀ......
Function bool OnTriggerCardEffectString(out string str1,out optional string str2,out optional string str3,out optional string str4);

//-----level 3 Functions--------------
//-----Only For Complex Card----------

//Usage:Í¨ÓÃµÄHUD»æÖÆÂß¼­
//Param1:»æ»­°åÀà
//param2:Æ«ÒÆÁ¿ x
//param3:Æ«ÒÆÁ¿ y
//Param4:»æÖÆË÷Òý£¬±íÊ¾Õâ¸öHUDÊÇµÚ¼¸¸ö»æÖÆµÄ¡£
//Author:Hawk Wang 2009-12-11
//call:ÔÚKFXCardPack->KFXDrawGameHUD·½·¨ÖÐÍ³Ò»µ÷ÓÃ
//implement:Ìí¼Ó»æÖÆÓÎÏ·HUDµÄÂß¼­£¬
Simulated Function OnDrawGameHUD(Canvas Canvas,KFXPlayer inPlayerOwner, optional int x_shift,optional int y_shift,optional int index);

//Usage:»æÖÆÌæ»»µÄHUDÍ¼±ê
//Param1:»æ»­°åÀà
//param2:Æ«ÒÆÁ¿ x
//param3:Æ«ÒÆÁ¿ y
//Author:Hawk Wang 2009-12-11
//Call:µ±¿¨Æ¬»æÖÆµÄHUDÍ¼±ê£¬»áÌæ»»µôÔ­±¾ÐèÒªÏÔÊ¾µÄHUDÍ¼±êÊ±µ÷ÓÃ¡£
Simulated Function OnDrawAlternativeHUD(Canvas Canvas,KFXPlayer inPlayerOwner, optional int x_shift,optional int y_shift);


//----------ÊÂ¼þº¯Êý----------------
simulated event Tick( float DeltaTime );

function int KFXGetPropID()
{
    return PropID;
}

defaultproperties
{
     bHidden=是
     RemoteRole=ROLE_SimulatedProxy
}
