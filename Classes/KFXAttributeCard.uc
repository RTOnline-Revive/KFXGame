//-----------------------------------------------------------
//Wanghao 2009-12-27
//Name�������� ��Ƭ
//Description�������࿨Ƭ����һ���Ա�����Բ�ʵ����Ч��
//����Ĳ��ֿ�Ƭ���ܿ���ת�Ƶ���װ��ȥ
//Wagnhao Hawk Wang 2009-12-29
//Ϊ�˼��ٶ���ͬ��������ֻ�ý�����һ��Ӧ�����ԵĿ�Ƭ��װ����
//-----------------------------------------------------------
class KFXAttributeCard extends KFXCard;
var Array<int> PropIDGroup;

//-------------������׷�����ԣ�������Ǳ���ģ��Ͳ�Ҫ��

//Usage:���һ����Ƭ��
//param:��ǰ����Ŀ�Ƭ�ģɣġ�
//Author��HawkWang 2009-12-29
//Modify:2009-12-30:�����������ֻ��¼Prop IDs
Function bool OnInitCard(int inPropID)
{
    local int index;
    super.OnInitCard(inPropID);
    //��һ����Ƭ���뿨Ƭ����
    index = PropIDGroup.Length;
    PropIDGroup.Insert(index,1);
    PropIDGroup[index] = inPropID;
    return true;
}

//Usage:Ϊ�����Ŀ�Ƭװ������Ч��
//Author:Hawk Wang 2009-12-29 WangHao2@kingsoft.com
//Implement:ͨ��ѭ����Switch��Ӧ�ÿ�ƬЧ��
//TODO:������Ҫ����Ĳ��������������ࡣ����չ
//Comment:������ȫ�����˾�ʽ�Ŀ�Ƭϵͳ���������ࣩ
Function bool OnApplyCardEffect(KFXPawn inPawn, optional Actor inActor)
{
    local KFXCSVTable cfg_props;
    local KFXPlayer ctrl;
    local int Loop;
    local int HighID;
    local int LowID;


    cfg_props = class'KFXTools'.static.GetConfigTable(32);            //��ȡCSV�� ��props.csv����
    ;

    if(inPawn == none)
    {
        return false;
    }

    ctrl = KFXPlayer(inPawn.Controller);

    if(ctrl == none)
    {
        return false;
    }

    for( Loop=0 ; Loop<PropIDGroup.Length; Loop++)
    {
        PropID = PropIDGroup[Loop];

        if( !cfg_props.SetCurrentRow(PropIDGroup[loop]) )
        {
            ;
            continue;               //��Ƭ�����ڣ�������һ�š�
        }
        else
        {
            HighID  = self.KFXGetHighID();
            LowID   = self.KFXGetLowID();
        }

        Switch(HighID)
        {
  //--------------------------------------------------------------//
 //        ����SWITCH���������ж�ID�Ƿ������                  //
//--------------------------------------------------------------//
        case 11: // Ь
            inPawn.KFXSpeedScale   = CFG_Props.GetFloat("Param1");
            inPawn.KFXFPSoundScale = CFG_Props.GetFloat("Param2");
            break;
        case 15: // �Զ���׼��
            ctrl.KFXAutoAimMP = CFG_Props.GetInt("MP");
            break;
        case 16: // ��ǹ��
            inPawn.KFXCanPickupWeapon = true;
            break;
        case 17: // ���п���
            inPawn.KFXReloadAddon = byte(CFG_Props.GetINT("MP"));
            break;
        case 18: // ��������
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bPropBonus = true;
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxPropBonusFactor = CFG_Props.GetFloat("MP");
            break;
        case 29:
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxGameCashFinalFactor = CFG_Props.GetFloat("MP");
            break;
        case 35: // �һ���
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bfxHanging = true;
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHangingInfo.fxHangingSPointSpeed  = CFG_Props.GetFloat("MP");
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHangingInfo.fxHangingExpSpeed     = CFG_Props.GetFloat("Param1");
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHangingInfo.fxHangingCashSpeed    = CFG_Props.GetFloat("Param2");
            inPawn.fxHangingLevel = 1;
            break;
        case 37:  // ��ͷ��
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXHeadKill = true;
            break;
        case 38:  // ����ͷ��
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXHeadKillResist = true;
            break;
        case 39:  // �����ױ���
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXAnimalResist = true;
            break;
        case 40:  // ����ָ�
            inPawn.KFXAnimalRecoverTime = CFG_Props.GetInt("Param1");
            break;
        case 41:  // C4����ǯ
            inPawn.fxC4PliersReduceFactor = CFG_Props.GetFloat("Param1");
            inPawn.fxC4InstallReduceFactor = CFG_Props.GetFloat("Param2");
            break;
        case 42:  // ����ռ��
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).KFXFastOccupyFactor = CFG_Props.GetFloat("Param1");
            break;
        case 43: //��������
            inPawn.fxKFXGasArmourFactor = CFG_Props.GetFloat("Param1");
            break;
        case 44: //���Ῠ
            if( ctrl.KFXCurSelectDoodleCardID == 0 )
                ctrl.KFXCurSelectDoodleCardID = PropID;
            break;
        case 46:  // ��ͷ��������ֵ��
        	KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHeadKillSpecial = CFG_Props.GetFloat("Param1");
        	KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHeadKillExpCard = true;
            break;
        case 48:// ͻ����ǹ���п�
            inPawn.fxShockCartridgeClip = CFG_Props.GetInt("MP");
            break;
        case 49://���ǹ���п�
            inPawn.fxLightCartridgeClip = CFG_Props.GetInt("MP");
		    break;
        case 50://RestartTimeCard
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxRestartCardTime = CFG_Props.GetFloat("Param1");
            break;
        case 51://���׷�����
        	inPawn.bKFXMinePrevent = true;
        	break;
        case 52:// ���ǹ���п�
            inPawn.fxChargeCartridgeClip = CFG_Props.GetInt("MP");
        	break;
	    case 53:// �ѻ�ǹ���п�
            inPawn.fxSnipeCartridgeClip = CFG_Props.GetInt("MP");
        	break;
        case 54:// �ػ�ǹ���п�
            inPawn.fxHeavyCartridgeClip = CFG_Props.GetInt("MP");
        	break;
        case 55:// ɢ��ǹ���п�
            inPawn.fxShotCartridgeClip = CFG_Props.GetInt("MP");
        	break;
        case 56:// ���ڵ��п�
            inPawn.fxHowitzerCartridgeClip = CFG_Props.GetInt("MP");
           	break;
        case 57:// ��ǹ���п�
            inPawn.fxPistolCartridgeClip = CFG_Props.GetInt("MP");
    	    break;
    	case 58:
            inPawn.fxBazookaCartridgeClip = CFG_Props.GetInt("MP");
    	    break;
    	case 59:// ����
    	    if ( LowID == 1 ) // �ȼ�����
    	    {
    		    inPawn.bKFXHasLevelDadge = true;
    	    }
        	else // �������
        	{
    	    	inPawn.KFXSingleBadge = CFG_Props.GetString("Param1");
        	}
		    break;
        case 60: //ľ����2������������
            inPawn.RoleDamageAdjustFactor = CFG_Props.GetFloat("MP");
            break;
        case 61: //���в�����
            ctrl.AmmoCountAdjustBlock.Param1 = CFG_Props.GetFloat("MP");
            ctrl.AmmoCountAdjustBlock.MaxUseTimes = CFG_Props.GetInt("Param1");
            ctrl.AmmoCountAdjustBlock.CDTime = CFG_Props.GetFloat("Param2");
            break;
        case 62: //ҽ�ư���
            ctrl.HealthCountAdjustBlock.Param1 = CFG_Props.GetFloat("MP");
            ctrl.HealthCountAdjustBlock.MaxUseTimes = CFG_Props.GetInt("Param1");
            ctrl.HealthCountAdjustBlock.CDTime = CFG_Props.GetFloat("Param2");
            break;
        case 63: //ľ����2��ɫHP����������
            inPawn.RoleHealthAdjuseFactor = CFG_Props.GetFloat("MP");
            break;
        case 64:
            inPawn.KFXFostSwitchWeapon.SwitchDown = CFG_Props.GetFloat("Param1");
            inPawn.KFXFostSwitchWeapon.BringUpDown = CFG_Props.GetFloat("Param2");
    	    break;
        case 65:
    		KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXHasFactionBadge = true;
    		break;
        case 68://���ٻ�ǹ��
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxFastSwitchAmmoRate = CFG_Props.GetFloat("Param1");
            break;
        case 69://������
            inPawn.bKFXGasPrevent = true;
            break;
   	    case 71://�޵п�Ƭ
            ctrl.GodCountAdjustBlock.Param1 = CFG_Props.GetFloat("MP");
            ctrl.GodCountAdjustBlock.MaxUseTimes = CFG_Props.GetInt("Param1");
            ctrl.GodCountAdjustBlock.CDTime = CFG_Props.GetFloat("Param2");
            break;
//        case 72: // ľ���������˿�
//	    	KFXCorpsePawn(inPawn).KFXDefendRepel.DefendTime = CFG_Props.GetInt("Param1");
//	    	KFXCorpsePawn(inPawn).KFXDefendRepel.CoolOffTime = CFG_Props.GetInt("Param2");
//		    break;
        case 73: // ��ը�˺�������
	    	inPawn.KFXBombPrevent = CFG_Props.GetFloat("Param1");
		    break;
	    case 74:// ͻ����ǹ���׿�
        	inPawn.KFXShockArmorPierce = CFG_Props.GetFloat("MP");
		    break;
        case 75:	// ΢�ͳ�沽ǹ���׿�
	    	inPawn.KFXChargeArmorPierce = CFG_Props.GetFloat("MP");
            break;
        }
    }
    return true;
}

defaultproperties
{
}
