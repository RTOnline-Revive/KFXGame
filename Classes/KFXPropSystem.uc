//-----------------------------------------------------------
//  Class:  KFXTools
//  Creator: Kevin Sun
//  Date: 2007.08.03
//  Description: KFXPropSystem for KFXGame
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
//-----------------------------------------------------------
class KFXPropSystem extends Object;

// Create Weapon
// Server or Standalone
// MagicItemID: 用于指定道具类型,为0则非道具
// AmmoMuti: 初始化武器的子弹是配表中的几倍
static function KFXWeapBase KFXCreateWeapon(KFXPawn p, int WeaponID, optional int MagicItemID,optional int AmmoMuti,
                                            optional int Component[6],optional bool bRepForceSwitch)
{
    local KFXCSVTable CFG_Weapon, CFG_Class;
    local KFXWeapBase weap;
    local int ClassID;
    local int WeapType,Limitparam;

    if(AmmoMuti<1)
        AmmoMuti=1;
    if ( p == none )
    {
        Log("[Weapon] KFXCreateWeapon: KFXPawn p accessed none!");
        return none;
    }

    if ( p.Role != ROLE_Authority )
    {
        Log("[Weapon] KFXCreateWeapon: p.Role != ROLE_Authority!");
        return none;
    }

    CFG_Weapon      = class'KFXTools'.static.GetConfigTable(11);
    CFG_Class       = class'KFXTools'.static.GetConfigTable(19);

    //<<李威国 机器人相关 兼容KFXBot
    if( PlayerController(p.Controller) != none )
    //>>
    Limitparam = KFXGameReplicationInfo(PlayerController(p.Controller).GameReplicationInfo).fxWeapLimit;

    if ( !CFG_Weapon.SetCurrentRow(WeaponID) )
    {
        Log("[Weapon] Can't Resolve The Weapon ID (Attribute Table): "$WeaponID);
        return none;
    }
    if(!P.CheckPawnCanHaveThisWeapon(WeaponID))
        return none;
    ClassID = CFG_Weapon.GetInt("Class");

    // Load Class, Spawn Weapon
    if ( ClassID != 0 && CFG_Class.SetCurrentRow(ClassID) )
    {

        WeapType = CFG_Weapon.GetInt( "WeaponGroup1" );
        if( KFXWeapLimitCheck( WeapType, Limitparam ) )
        {
            log("[KFXPropSystem] weapon limit type:"$WeapType$"fxWeapLimit:"$Limitparam);
            return none;
        }
        log("[CreateWeapon]  Name:"$CFG_Weapon.GetString("Name"));
        weap = p.Spawn(
            class<KFXWeapBase>(
                DynamicLoadObject("XXXWeapons.XXX_"$CFG_Weapon.GetString("Name"), class'Class',true)),
            p);
        log("  Weapon Owner Name Is "$P.PlayerReplicationInfo.PlayerName);
//        log("KFXPropSystem---------Weap "$weap);
        if( weap != none )
        {
            weap.bRepForceSwitch = bRepForceSwitch;
            weap.Instigator = p;
            weap.KFXServerInit(WeaponID, MagicItemID,Component,P.bIsFemale);
            weap.KFXSetAmmo(weap.KFXGetAmmo()*AmmoMuti);
            weap.KFXSetCartridgeClip(p);
            weap.KFXSetArmourPierce(p);
            weap.GiveTo(p);

            if ( weap != None )
                weap.PickupFunction(p);
            weap.AdjustWeapAttribute();     //--服务器根据模式不同进行对属性的设置
        }
    }
    else
    {
        Log("[Weapon] Can't Resolve The Weapon Class or Invalid Class ID : "$ClassID);
        return none;
    }
    return weap;
}

static function bool KFXWeapLimitCheck( int WeapGroup, int LimitParam )
{
    if( WeapGroup<1 )
        return false;
    if( ( (1<<(WeapGroup-1)) & LimitParam )==0 )
    {
        return false;
    }
    return true;
}


// 不依赖于Pawn的道具初始化接口
static function KFXApplyPropOnce(KFXPlayer p, int PropID)
{
    local KFXCSVTable CFG_Props;
    local int TypeID;
    local int Param1, Param2;

    if ( p == none )
    {
        Log("[KFXApplyPropOnce] p accessed none!");
        return;
    }

    if ( p.Role != ROLE_Authority )
    {
        Log("[KFXApplyPropOnce] p.Role != ROLE_Authority!");
        return;
    }

    CFG_Props = class'KFXTools'.static.GetConfigTable(32);

    TypeID = PropID >> 16;

    switch(TypeID)
    {
    case 31:// 语音变声卡片
        if ( CFG_Props.SetCurrentRow(PropID) )
        {
            Param1 = CFG_Props.GetInt("Param1");// 语音道具种类
            Param2 = CFG_Props.GetInt("Param2");// 具体参数
            if (Param1 == 1)// 变声道具
            {
                KFXPlayerReplicationInfo(p.PlayerReplicationInfo).KFXVoiceFont = Param2;
            }
        }
        break;
    case 32:// 语音3D环绕卡片
        log ("[Dolby Voice] ======== 3D Item ========");
        KFXPlayerReplicationInfo(p.PlayerReplicationInfo).bKFXSpatial = true;
        break;
    }
}
//<< 比较时间
// 比较当前时间是否在某个范围内(sBegin、sEnd为表中时间格式)
static function bool CheckTimeBound(string sBegin, string sEnd, array<int> nCurTime)
{
    local array<int> Begin, End;

    if( !static.DivideCsvTimeToArray(sBegin, Begin))
    {
        return false;
    }
    if( !static.DivideCsvTimeToArray(sEnd, End))
    {
        return false;
    }
    if( !static.CompareTimeArray(nCurTime, Begin) )
    {
        return false;
    }
    if( static.CompareTimeArray(nCurTime, End) )
    {
        return false;
    }
    return true;
}

// 转换表中时间（格式：2011-3-10 12:00:00）为整型数组
static function bool DivideCsvTimeToArray(string sTime, out array<int> nTime)
{
    sTime = Repl(sTime, "-", " ", false);
    sTime = Repl(sTime, ":", " ", false);
    if(!DivideTimeToArray(sTime, nTime))
    {
        return false;
    }
    return true;
}

// 转换时间（格式：年 月 日 时 分 秒）为整型数组
static function bool DivideTimeToArray(string sTime, out array<int> nTime)
{
    local int i;
    local array<string> sPart;
    if(Split(sTime, " ", sPart) != 6)
    {
        Log("[DivideTimeToArray]Failed : "$sTime);
        return false;
    }
    nTime.remove(0, nTime.length);
    nTime.insert(0, sPart.length);
    for(i = 0; i < sPart.length; i++)
    {
        nTime[i] = int(sPart[i]);
    }
    return true;
}

// 比较整型数组格式的时间的大小
static function bool CompareTimeArray(array<int> A, array<int> B)
{
    local int i;
    for(i = 0; i < 6; i++)
    {
        if(A[i] < B[i])
        {
            return false;
        }
        else if(A[i] > B[i])
        {
            return true;
        }
    }
    return true;
}

defaultproperties
{
}
