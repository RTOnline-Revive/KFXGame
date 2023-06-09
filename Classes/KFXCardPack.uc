//-----------------------------------------------------------
//Íõð© & ôß»Ý wanghao2@kingsoft.com
//¿¨Æ¬°ü£¬ÔÝÊ±¹æ¶¨ÎªÓÉKFXPlayer³ÖÓÐ
//ÓÃÓÚ¶¯Ì¬×°ÔØËùÓÐÕâ¸öÈËÎï³ÖÓÐµÄ¿¨Æ¬¡£Ïàµ±ÓÚÒ»¸ö¿¨Æ¬µÄ¹ÜÀíÕß
//½«¿¨Æ¬´ÓKFXPropSystemÖÐ³éÈ¡³öÀ´£¬¶ÀÁ¢³ÉÒ»¸ö×ÓÏµÍ³
//TODO:ÊÇ·ñ¿¼ÂÇÒªÍÆ¹ãÕâ¸öÄ£ÐÍ£¬Ó¦µ±ÔÚÄ£ÐÍÆÀ¹ÀÖ®ºóÔÙ¾ö¶¨
//ÓÃÓÚÔÚÔËÐÐÊ±ÅÐ±ð¿¨Æ¬ÊÇ·ñ±»×°ÔØ£¬²¢Ë÷Òýµ½Ö¸¶¨µÄ¿¨Æ¬
//£¨Î´ÊµÏÖ£©ÔËÐÐÊ±Ð¶ÔØ¿¨Æ¬
//-----------------------------------------------------------

class KFXCardPack extends Actor;
//----------------Ë½ÓÐ³ÉÔ±ÔÚÕâÀï¶¨Òå-------------------------
const MAX_CARD_IN_PACKAGE_NUM = 30;
var protected KFXPlayer PlayerOwner;                //(ÔÝ¶¨)
var protected KFXGameInfo GameMode;                 //(ÔÝ¶¨)
var protected KFXCard KFXCardPackage[MAX_CARD_IN_PACKAGE_NUM];
var protected KFXAttributeCard KFXAttrCardPackage;  //´ò°üÊôÐÔ¿¨ 2009-12-29
var protected int KFXCardIndex;

//----------------Í¬²½ÔÚÕâÀï¶¨Òå------------------------------
replication
{
    reliable if(Role == Role_authority && bNetDirty && bNetOwner)// && bNetDirty
        KFXCardPackage,KFXCardIndex;
}


//----------------¹«¿ª½Ó¿ÚÐ´ÔÚÕâÀï-----------------------------
//Usage:×°ÔØ¿¨Æ¬µ½ÈËÎïµÄ±³°üÀï£¬Ö÷ÒªÊÇ´Ó·þÎñÆ÷»ñÈ¡ÎïÆ·µÄID£¬È»ºóÓÃÕâ¸öID¶Á±í
//param1: µ±Ç°Player£¬µÀ¾ß¿¨Æ¬°üµÄ³ÖÓÐÕß
//param2: µ±Ç°ÓÎÏ·Ä£Ê½£¬ÓÃÓÚÅÐ¶¨ÊÇ·ñÎª¸ÃÄ£Ê½×°ÔØÄ³¿¨Æ¬¡£
//Author:Hawk Wang 2009-12-28
//History:Ö±½ÓÐÞ¸Ä×ÔKFXGameInfo->KFXAddPropOnce(KFXPlayer P)
Function bool KFXInitCardPack(KFXPlayer inPlayerOwner,KFXGameInfo inGameInfo)
{
    local KFXFaeryAgent.KFXBagPropsInfo fxNetPlayerProps;
    local KFXPawn localPawn;
    local int loop;

    //¼ì²âplayer controllerµÄÓÐÐ§ÐÔ£¬²¢ÎªËû¸³Öµ
    if ( inPlayerOwner == none )
    {
        Log("[KFXCard] Player Controller accessed none!");
        return false;
    }
    else
    {
        PlayerOwner = inPlayerOwner;
        localPawn = KFXPawn(PlayerOwner.Pawn);
        GameMode = inGameInfo;
    }

    //¼ì²âPawnÓÐÐ§ÐÔ
    if ( localPawn == none )
    {
        Log("[KFXCard] Incorrect Pawn !");
        return false;
    }

    //¼ì²éÊÇ·ñ·þÎñÆ÷¶Ë¡£
    if ( localPawn.Role != ROLE_Authority )
    {
        Log("[KFXCard] Role != ROLE_Authority");
        return false;
    }

    //Á¬½ÓÊý¾Ý¿â
    fxNetPlayerProps = inPlayerOwner.fxDBPlayerPropsInfo;

    //TODO:Ôö¼Ó´´½¨Ò»´ÎÊôÐÔ¿¨µÄÂß¼­£¬ÅÐ¶ÏÊÇ·ñÒÑ¾­´´½¨¡£

    //Ñ­»·¶ÁÈ¡£¬³õÊ¼»¯¿¨Æ¬
    for ( loop = 0; loop < MAX_CARD_IN_PACKAGE_NUM; loop++ )
    {
        if ( fxNetPlayerProps.nBagProps[loop] != 0 )
        {
            KFXAddNewCard(fxNetPlayerProps.nBagProps[loop]);
        }
    }
}

//Usage:ÓÃÓÚ²»¾­ÓÉÊý¾Ý¿â£¬ÊÖ¶¯Ç¿ÖÆÌí¼ÓÖ¸¶¨IDµÄµÀ¾ß
//param1: µ±Ç°Player£¬µÀ¾ß¿¨Æ¬°üµÄ³ÖÓÐÕß
//param2: µ±Ç°ÓÎÏ·Ä£Ê½£¬ÓÃÓÚÅÐ¶¨ÊÇ·ñÎª¸ÃÄ£Ê½×°ÔØÄ³¿¨Æ¬¡£
//Param3: Ò»¸ö×°ÔØµÀ¾ßIDµÄ¶¯Ì¬Êý×é
//Author:Hawk Wang 2009-12-28
//Call:ÔÚ KFXGameInfo ¼°Æä×ÓÀàµÄ AddDefaultInventory·½·¨ÖÐµ÷ÓÃ¡£
Function bool KFXInitCardPackList(KFXPlayer inPlayerOwner,KFXGameInfo inGameInfo,array<int> CardList)
{
    local int loop;

    //¼ì²âplayer controllerµÄÓÐÐ§ÐÔ£¬²¢ÎªËû¸³Öµ
    if ( inPlayerOwner == none )
    {
        Log("[KFXCardPack] Incorrect Player !");
        return false;
    }
    else
    {
        PlayerOwner = inPlayerOwner;
        GameMode = inGameInfo;
    }

    //TODO:Ôö¼Ó´´½¨Ò»´ÎÊôÐÔ¿¨µÄÂß¼­£¬ÅÐ¶ÏÊÇ·ñÒÑ¾­´´½¨¡£

    for ( loop = 0; loop < CardList.Length; loop++ )
    {
        if ( CardList[loop] != 0 )
        {
            KFXAddNewCard(CardList[loop]);
        }
    }
}

//Usage£ºÍ¨¹ýµÀ¾ßID£¬ÏòµÀ¾ß¿¨Æ¬°üÌí¼ÓÒ»¸öÐÂµÄµÀ¾ß¡£
//Param: µÀ¾ß¿¨Æ¬µÄÎ¨Ò»µÄID
//Author£ºHawk Wang 2009-12-11 wanghao2@kingsoft.com
function bool KFXAddNewCard(int PropID)
{
    local KFXCSVTable   CFG_PropLimit;     //PropLimit.csv
    local string        CardClassName;     //This Value Is Use To Spwan Object Dynamically
    local string        CurrentGameMode;   //This Value Use To Restore Current GameInfo Objrct`s Class Name

    CFG_PropLimit = class'KFXTools'.static.GetConfigTable(601);

    if( !CFG_PropLimit.SetCurrentRow(PropID))
    {   //Èç¹ûÕÒ²»µ½×Ö¶Î
        ;
        return false;
    }

    if(CFG_PropLimit.GetInt("AllMode") == -1)
    {
        //¸ÃµÀ¾ß¿¨Æ¬ÒÑ¾­ÏÂ¼Ü£¬»ò»¹Ã»ÓÐÉÏ¼Ü¡£
        return false;
    }

    CurrentGameMode = string(GameMode.Name);//»ñÈ¡µ±Ç°ÓÎÏ·Ä£Ê½µÄÃû×Ö

    if(CFG_PropLimit.GetInt("AllMode") == 1 ||      //È«Ä£Ê½Í¨ÓÃ
      CFG_PropLimit.GetInt(CurrentGameMode) == 1    //»òÕßµ±Ç°Ä£Ê½ÉúÐ§
    )
    {
        //Ó¦¸ÃÎª¸ÃÍæ¼Ò×°ÔØ¸ÃµÀ¾ß¿¨Æ¬
        CardClassName = CFG_PropLimit.GetString("ClassName");   //»ñÈ¡ÀàÃû
        CardClassName = "KFXGame."$CardClassName;

        if( CardClassName == "KFXAttributeCard")
        {
            //TODO:³õÊ¼»¯Ò»´ÎÊôÐÔ¿¨£¬Ï£Íû×îºó²»ÒªÕâÃ´×ö¡£
            self.KFXAttrCardPackage.OnInitCard(PropID);
        }
        else
        {
            KFXCardPackage[KFXCardIndex] =
            Spawn(
                class<KFXCard>(DynamicLoadObject(CardClassName,class'Class')),
                PlayerOwner
            );
            KFXCardPackage[KFXCardIndex].OnInitCard(PropID);
            KFXCardIndex++;
            ;
        }
    }
    return true;
}

//Usage£ºÖØÖÃÈ«²¿µÄ¿¨Æ¬£¬½øÐÐ¿¨Æ¬Ê¹ÓÃÌõ¼þµÄÅÐ¶¨
//return:ÊÇ·ñ×¼±¸¿¨Æ¬³É¹¦
//Author:Hawk Wang
//call:Ã¿´ÎÈËÎï×°ÔØÎäÆ÷µÄÊ±ºò£¬Ë³Â·µ÷ÓÃ£¿¡£¡£¡£
//Ôö¼Ó¶Ô´ò°üµÄ¼¯ºÏÊôÐÔ¿¨Æ¬µÄµ÷ÓÃ
function bool KFXReadyCard()
{
    local int index;
    local KFXPawn localPawn;

    //pawnÊÇÔÚ²»¶Ï±ä»¯µÄ£¬²»Òª°ÑËü×ö³É³ÉÔ±±äÁ¿£¬Ã¿´Î¼ÆËãËûlol
    //ÒòÎªÖ®Ç°µÄº¯Êý»áÖØÐÂ¸øPlayerControllerµÄPawn¸³Öµ£¬Òò´ËÕâ¸öpawnÊÇÓÐÐ§µÄPawn
    if(playerOwner!= none && playerOwner.Pawn != none)
    {
        localPawn = KFXPawn(playerOwner.Pawn);
    }

    if(localPawn == none)
    {
        return false;
    }

    for(index = 0;index < KFXCardPackageLength();index++ )
    {
        KFXCardPackage[index].OnResetCard();
    }

    //Hack£ºÓÐÃ»ÓÐ±ØÒªÎª£¬KFXAttriCardPackageµ÷ÓÃ OnResetCard·½·¨£¬ÏÖÔÚ¿´À´ÊÇÃ»ÓÐ±ØÒª¡£

    //2009-12-30 Ó¦ÓÃÒ»´ÎÐÔÓ¦ÓÃµÄÊôÐÔ¿¨Æ¬µÀ¾ßµÄÐ§¹û
    //2011-4-25  KFXAttrCardPackage Ã»ÓÐ³õÊ¼»¯ÔÝÊ±×¢µô
    //self.KFXAttrCardPackage.OnApplyCardEffect(localPawn);

    return true;
}

//Usage£ºÍ¨¹ý¿¨Æ¬ID»ñÈ¡¿¨Æ¬µÄÒýÓÃ
//Param1:¿¨Æ¬ID
//Author: Hawk Wang 2009-12-11 Wanghao2@kingsoft.com
//¿ÉÏ§Ã»×öhash»òÕßË÷Òý£¬Ö»ÄÜ°¤¸ö²éÕÒ¡£ºÃÔÚ¿¨Æ¬µÄÊýÁ¿²»¶à
function KFXCard KFXGetCard(int PropID)
{
    local int index;
    for(index = 0; index < KFXCardPackageLength(); index++)
    {
        if(KFXCardPackage[index].KFXGetPropID() == PropID)
        {
            ;
            return KFXCardPackage[index];
        }
    }
    return none;
}

//Usage: Í¨¹ýË÷Òý»ñÈ¡¿¨Æ¬µÄÒýÓÃ
//Param1: ¿¨Æ¬Ë÷Òý
//Author: Hawk Wang 2009-12-11 Wanghao2@kingsoft.com
function KFXCard KFXGetCardByIndex(int index)
{
    //Ë÷ÒýÔ½½ç
    if(index < 0 || index >= KFXCardPackageLength())
    {
        return none;
    }
    return KFXCardPackage[index];
}

//Usage£º»æÖÆÍ³Ò»µÄHUDµÄÂß¼­£¬ÌØÊâµÄHUD»æÖÆ²»ÒªÔÚÕâÀïµ÷ÓÃ
//param1£º»­²¼Àà
//Author: Hawk Wang 2009-12-11 Wanghao2@kingsoft.com
simulated Function KFXDrawGameHUD(Canvas Canvas,KFXPlayer inPlayer)
{
    local int Loop;

    //TODO:¶ÔÏó¿ÉÒÔ´«¹ýÈ¥ÁË£¬KFXCardIndexÒ²Í¬²½¹ýÈ¥ÁË£¬ÕâÀï¿ÉÒÔ¸Ä³ÉKFXCardIndexÁË
    //for (loop=0 ; loop < MAX_CARD_IN_PACKAGE_NUM ; loop++)
    for(loop = 0; loop < self.KFXCardIndex ; loop++ )
    {
        //LOG("PropID is:"$KFXCardPackage[loop].KFXGetPropID()$"at:"$Loop$"and:"$KFXCardPackage[loop]);

        if(KFXCardPackage[loop] == none)
        {
            continue;
        }
        else
        {
            //KFXCardPackage[loop].OnDrawGameHUD(Canvas,inPlayer);
            //LOG("[KFXCard] TextInt "$KFXComplexCard(KFXCardPackage[loop]).TestInt);
            KFXComplexCard(KFXCardPackage[loop]).OnDrawGameHUD(Canvas,inPlayer);
        }
    }
}

//usage£»²âÊÔ×¨ÓÃ£¬²»ÒªÔÚÕýÊ½·¢²¼Ê±Ê¹ÓÃÕâ¸öº¯Êý
Function bool TestInitCardPack(KFXPlayer inPlayerOwner,KFXGameInfo inGameInfo)
{
    local int simulate_pack[MAX_CARD_IN_PACKAGE_NUM];
    local int loop;

    simulate_pack[0] = 4980737;//ÓÄÁé×¨ÓÃ¼ÓËÙ¿¨

    //¼ì²âplayer controllerµÄÓÐÐ§ÐÔ£¬²¢ÎªËû¸³Öµ
    if ( inPlayerOwner == none )
    {
        Log("[KFXCardPack] Incorrect Player !");
        return false;
    }
    else
    {
        PlayerOwner = inPlayerOwner;
        GameMode = inGameInfo;
    }

    for ( loop = 0; loop < MAX_CARD_IN_PACKAGE_NUM; loop++ )
    {
        if ( simulate_pack[loop] != 0 )
        {
            KFXAddNewCard(simulate_pack[loop]);
            ;
        }
    }
}

//Usage:·µ»Ø¿¨Æ¬°üµÄ³¤¶È.×¢Òâ²»ÊÇ·µ»Ø¿¨Æ¬µÄ×ÜÊý£¬¶øÖ»ÊÇ°üÖÐµÄÊýÁ¿
//Author£ºHawkWang 2009-12-30
Function int KFXCardPackageLength()
{
    return self.KFXCardIndex;
}

//----------------ÊÂ¼þÐ´ÔÚÕâÀï---------------------------------
simulated event Tick(float DeltaTime){}                  //hack:¼ÆÊ±µÄÂß¼­£¬ÊÇ·ñÓ¦¸ÃÍ³Ò»ÔÚÕâÀï¼ÆÊ±£¬´ýÌÖÂÛ

defaultproperties
{
     bHidden=是
     RemoteRole=ROLE_SimulatedProxy
}
