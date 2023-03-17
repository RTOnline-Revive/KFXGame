//-----------------------------------------------------------
//Wanghao 2009-12-27
//Name：属性类 卡片
//Description：该子类卡片可以一次性变更属性并实现其效果
//这里的部分卡片功能可以转移到服装中去
//Wagnhao Hawk Wang 2009-12-29
//为了减少对象同步开销，只好将可以一次应用属性的卡片，装备给
//-----------------------------------------------------------
class KFXAttributeCard extends KFXCard;
var Array<int> PropIDGroup;

//-------------在这里追加属性，如果不是必须的，就不要加

//Usage:添加一个卡片。
//param:当前加入的卡片的ＩＤ。
//Author：HawkWang 2009-12-29
//Modify:2009-12-30:这个函数现在只记录Prop IDs
Function bool OnInitCard(int inPropID)
{
    local int index;
    super.OnInitCard(inPropID);
    //将一个卡片加入卡片包组
    index = PropIDGroup.Length;
    PropIDGroup.Insert(index,1);
    PropIDGroup[index] = inPropID;
    return true;
}

//Usage:为复数的卡片装载属性效果
//Author:Hawk Wang 2009-12-29 WangHao2@kingsoft.com
//Implement:通过循环和Switch来应用卡片效果
//TODO:可能需要更多的参数，比如武器类。待扩展
//Comment:现在完全兼容了旧式的卡片系统。（属性类）
Function bool OnApplyCardEffect(KFXPawn inPawn, optional Actor inActor)
{
    local KFXCSVTable cfg_props;
    local KFXPlayer ctrl;
    local int Loop;
    local int HighID;
    local int LowID;


    cfg_props = class'KFXTools'.static.GetConfigTable(32);            //读取CSV表 “props.csv”。
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
            continue;               //卡片不存在，继续下一张。
        }
        else
        {
            HighID  = self.KFXGetHighID();
            LowID   = self.KFXGetLowID();
        }

        Switch(HighID)
        {
  //--------------------------------------------------------------//
 //        万恶的SWITCH：不用在判断ID是否存在了                  //
//--------------------------------------------------------------//
        case 11: // 鞋
            inPawn.KFXSpeedScale   = CFG_Props.GetFloat("Param1");
            inPawn.KFXFPSoundScale = CFG_Props.GetFloat("Param2");
            break;
        case 15: // 自动瞄准卡
            ctrl.KFXAutoAimMP = CFG_Props.GetInt("MP");
            break;
        case 16: // 捡枪卡
            inPawn.KFXCanPickupWeapon = true;
            break;
        case 17: // 弹夹卡：
            inPawn.KFXReloadAddon = byte(CFG_Props.GetINT("MP"));
            break;
        case 18: // 荣誉卡：
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bPropBonus = true;
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxPropBonusFactor = CFG_Props.GetFloat("MP");
            break;
        case 29:
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxGameCashFinalFactor = CFG_Props.GetFloat("MP");
            break;
        case 35: // 挂机卡
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bfxHanging = true;
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHangingInfo.fxHangingSPointSpeed  = CFG_Props.GetFloat("MP");
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHangingInfo.fxHangingExpSpeed     = CFG_Props.GetFloat("Param1");
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHangingInfo.fxHangingCashSpeed    = CFG_Props.GetFloat("Param2");
            inPawn.fxHangingLevel = 1;
            break;
        case 37:  // 爆头卡
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXHeadKill = true;
            break;
        case 38:  // 防爆头卡
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXHeadKillResist = true;
            break;
        case 39:  // 变身雷保护
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXAnimalResist = true;
            break;
        case 40:  // 变身恢复
            inPawn.KFXAnimalRecoverTime = CFG_Props.GetInt("Param1");
            break;
        case 41:  // C4工具钳
            inPawn.fxC4PliersReduceFactor = CFG_Props.GetFloat("Param1");
            inPawn.fxC4InstallReduceFactor = CFG_Props.GetFloat("Param2");
            break;
        case 42:  // 快速占领
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).KFXFastOccupyFactor = CFG_Props.GetFloat("Param1");
            break;
        case 43: //毒气防护
            inPawn.fxKFXGasArmourFactor = CFG_Props.GetFloat("Param1");
            break;
        case 44: //喷漆卡
            if( ctrl.KFXCurSelectDoodleCardID == 0 )
                ctrl.KFXCurSelectDoodleCardID = PropID;
            break;
        case 46:  // 爆头奖励经验值卡
        	KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHeadKillSpecial = CFG_Props.GetFloat("Param1");
        	KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxHeadKillExpCard = true;
            break;
        case 48:// 突击步枪弹夹卡
            inPawn.fxShockCartridgeClip = CFG_Props.GetInt("MP");
            break;
        case 49://轻机枪弹夹卡
            inPawn.fxLightCartridgeClip = CFG_Props.GetInt("MP");
		    break;
        case 50://RestartTimeCard
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxRestartCardTime = CFG_Props.GetFloat("Param1");
            break;
        case 51://地雷防护卡
        	inPawn.bKFXMinePrevent = true;
        	break;
        case 52:// 冲锋枪弹夹卡
            inPawn.fxChargeCartridgeClip = CFG_Props.GetInt("MP");
        	break;
	    case 53:// 狙击枪弹夹卡
            inPawn.fxSnipeCartridgeClip = CFG_Props.GetInt("MP");
        	break;
        case 54:// 重机枪弹夹卡
            inPawn.fxHeavyCartridgeClip = CFG_Props.GetInt("MP");
        	break;
        case 55:// 散弹枪弹夹卡
            inPawn.fxShotCartridgeClip = CFG_Props.GetInt("MP");
        	break;
        case 56:// 榴弹炮弹夹卡
            inPawn.fxHowitzerCartridgeClip = CFG_Props.GetInt("MP");
           	break;
        case 57:// 手枪弹夹卡
            inPawn.fxPistolCartridgeClip = CFG_Props.GetInt("MP");
    	    break;
    	case 58:
            inPawn.fxBazookaCartridgeClip = CFG_Props.GetInt("MP");
    	    break;
    	case 59:// 臂章
    	    if ( LowID == 1 ) // 等级臂章
    	    {
    		    inPawn.bKFXHasLevelDadge = true;
    	    }
        	else // 单身臂章
        	{
    	    	inPawn.KFXSingleBadge = CFG_Props.GetString("Param1");
        	}
		    break;
        case 60: //木乃伊2攻击力提升卡
            inPawn.RoleDamageAdjustFactor = CFG_Props.GetFloat("MP");
            break;
        case 61: //弹夹补给卡
            ctrl.AmmoCountAdjustBlock.Param1 = CFG_Props.GetFloat("MP");
            ctrl.AmmoCountAdjustBlock.MaxUseTimes = CFG_Props.GetInt("Param1");
            ctrl.AmmoCountAdjustBlock.CDTime = CFG_Props.GetFloat("Param2");
            break;
        case 62: //医疗包卡
            ctrl.HealthCountAdjustBlock.Param1 = CFG_Props.GetFloat("MP");
            ctrl.HealthCountAdjustBlock.MaxUseTimes = CFG_Props.GetInt("Param1");
            ctrl.HealthCountAdjustBlock.CDTime = CFG_Props.GetFloat("Param2");
            break;
        case 63: //木乃伊2角色HP上限提升卡
            inPawn.RoleHealthAdjuseFactor = CFG_Props.GetFloat("MP");
            break;
        case 64:
            inPawn.KFXFostSwitchWeapon.SwitchDown = CFG_Props.GetFloat("Param1");
            inPawn.KFXFostSwitchWeapon.BringUpDown = CFG_Props.GetFloat("Param2");
    	    break;
        case 65:
    		KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).bKFXHasFactionBadge = true;
    		break;
        case 68://快速换枪卡
            KFXPlayerReplicationInfo(inPawn.PlayerReplicationInfo).fxFastSwitchAmmoRate = CFG_Props.GetFloat("Param1");
            break;
        case 69://防毒卡
            inPawn.bKFXGasPrevent = true;
            break;
   	    case 71://无敌卡片
            ctrl.GodCountAdjustBlock.Param1 = CFG_Props.GetFloat("MP");
            ctrl.GodCountAdjustBlock.MaxUseTimes = CFG_Props.GetInt("Param1");
            ctrl.GodCountAdjustBlock.CDTime = CFG_Props.GetFloat("Param2");
            break;
//        case 72: // 木乃伊防击退卡
//	    	KFXCorpsePawn(inPawn).KFXDefendRepel.DefendTime = CFG_Props.GetInt("Param1");
//	    	KFXCorpsePawn(inPawn).KFXDefendRepel.CoolOffTime = CFG_Props.GetInt("Param2");
//		    break;
        case 73: // 爆炸伤害防护卡
	    	inPawn.KFXBombPrevent = CFG_Props.GetFloat("Param1");
		    break;
	    case 74:// 突击步枪穿甲卡
        	inPawn.KFXShockArmorPierce = CFG_Props.GetFloat("MP");
		    break;
        case 75:	// 微型冲锋步枪穿甲卡
	    	inPawn.KFXChargeArmorPierce = CFG_Props.GetFloat("MP");
            break;
        }
    }
    return true;
}

defaultproperties
{
}
