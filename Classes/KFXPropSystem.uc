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
// MagicItemID: ����ָ����������,Ϊ0��ǵ���
// AmmoMuti: ��ʼ���������ӵ�������еļ���
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

    //<<������ ��������� ����KFXBot
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
            weap.AdjustWeapAttribute();     //--����������ģʽ��ͬ���ж����Ե�����
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


// ��������Pawn�ĵ��߳�ʼ���ӿ�
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
    case 31:// ����������Ƭ
        if ( CFG_Props.SetCurrentRow(PropID) )
        {
            Param1 = CFG_Props.GetInt("Param1");// ������������
            Param2 = CFG_Props.GetInt("Param2");// �������
            if (Param1 == 1)// ��������
            {
                KFXPlayerReplicationInfo(p.PlayerReplicationInfo).KFXVoiceFont = Param2;
            }
        }
        break;
    case 32:// ����3D���ƿ�Ƭ
        log ("[Dolby Voice] ======== 3D Item ========");
        KFXPlayerReplicationInfo(p.PlayerReplicationInfo).bKFXSpatial = true;
        break;
    }
}
//<< �Ƚ�ʱ��
// �Ƚϵ�ǰʱ���Ƿ���ĳ����Χ��(sBegin��sEndΪ����ʱ���ʽ)
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

// ת������ʱ�䣨��ʽ��2011-3-10 12:00:00��Ϊ��������
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

// ת��ʱ�䣨��ʽ���� �� �� ʱ �� �룩Ϊ��������
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

// �Ƚ����������ʽ��ʱ��Ĵ�С
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
