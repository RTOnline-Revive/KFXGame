//-----------------------------------------------------------
//��ɫ�Ҽ�/װ��
//-----------------------------------------------------------
class KFXDecoration extends DecorationActor;


var KFXDecoration	NextDecoration;

var int GrenadeEx;      //�װ�
var float ArmorExBody;        //���ף�Ҫ��Ϊ��ͷ�׺ͻ���ף���ͷ����ͷ������ͻ
var float ArmorExHead;
var int	  ArmorValue;			//����ֵ
var float ChangeSpeedEx;  //��ǹ�ٶ�
var float WeaponBrightUpDown;	//��ǹ��ȴ
var float MoveSpeedEx;    //�ƶ��ٶ�
var float C4Ex;           //c4����ǯ�����İ���ʱ��
var float AntiFlashEx;    //�����۾�
var float HonorPointEx;   //��������ֵ����
var float SilverEx;       //������������
var float StepSoundVolumeEx;	//�Ų�������ϵ��
var float StepSoundRadiusEx;	//�Ų�����Χϵ��
var float FallDownHurtEx;	//�����˺�
var float HoldBreathEx;		//�������
var int BackAmmoForRifle;   	//ͻ��
var int BackAmmoForSubMachine;	//΢��
var int BackAmmoForSniper;		//�ѻ�
var int BackAmmoForShotgun;		//����
var int BackAmmoForPistol;	//��ǹ
var int BackAmmoForMachinegun;	//��ǹ
var int BombLevel;
var name BindBone[4];
var string TeamSkins[4];
var vector RelLocor[4];  	//λ��
var rotator RelRotor[4];    //����
var vector RelScale[4];     //��С
var int modelid[4];




//����������pawn�ĹҼ��ṩ�����ж�������
static function int GetTotalGrenadeEx(KFXPawn p)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.GrenadeEx;
	}
	p.TotalGrenadeEx = tmp;
	return tmp;
}
static function int GetTotalArmorEx(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	local float tmp1;
	local int	tmp2;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.ArmorExBody;
		tmp1 += de.ArmorExHead;

		//��������ȡ����
		if(de.ArmorValue > tmp2)
			tmp2 = de.ArmorValue;
	}
	p.TotalArmorExBody = tmp;
	p.TotalArmorExHead = tmp1;
	p.KFXArmorPoints = tmp2;
	return tmp;
}

static function int GetTotalChangeSpeedEx(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.ChangeSpeedEx;
	}
	p.TotalChangeSpeedEx = tmp;
	return tmp;
}
static function int GetTotalWeaponBrightUpDown(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.WeaponBrightUpDown;
	}
	p.TotalWeaponBrightUpDown = tmp;
	return tmp;
}
static function float GetTotalMoveSpeed(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.MoveSpeedEx;
	}
	p.TotalMoveSpeedEx = tmp;
	return tmp;
}
static function float GetTotalC4Ex(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.C4Ex;
	}
	p.TotalC4Ex = tmp;
	return tmp;
}
static function float GetTotalAntiFlashEx(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.AntiFlashEx;
	}
	p.TotalAntiFlashEx = tmp;
	return tmp;

}
static function float GetTotalHonorPointEx(KFXPawn p, out float value)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.HonorPointEx;
	}
	value = tmp;
	return tmp;

}
static function float GetTotalSilverEx(KFXPawn p, out float value)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.SilverEx;
	}
	value = tmp;
	return tmp;

}
static function float GetTotalStepSoundVolumeEx(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.StepSoundVolumeEx;
	}
	p.TotalStepSoundVolumeEx = tmp;
	return tmp;
}
static function float GetTotalStepSoundRadiusEx(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.StepSoundRadiusEx;
	}
	p.TotalStepSoundRadiusEx = tmp;
	return tmp;
}
static function float GetTotalFallDownHurtEx(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.FallDownHurtEx;
	}
	p.TotalFallDownHurtEx = tmp;
	return tmp;
}
static function float GetTotalHoldBreathEx(KFXPawn p)
{
	local KFXDecoration de;
	local float tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.HoldBreathEx;
	}
	p.TotalHoldBreathEx = tmp;
	return tmp;
}
static function int GetTotalBackAmmoForRifle(KFXPawn p)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.BackAmmoForRifle;
	}
	p.TotalBackAmmoForRifle = tmp;
	return tmp;
}
static function int GetTotalBackAmmoForSubMachine(KFXPawn p)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.BackAmmoForSubMachine;
	}
	p.TotalBackAmmoForSubMachine = tmp;
	return tmp;
}
static function int GetTotalBackAmmoForSniper(KFXPawn p)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.BackAmmoForSniper;
	}
	p.TotalBackAmmoForSniper = tmp;
	return tmp;
}
static function int GetTotalBackAmmoForShotgun(KFXPawn p)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.BackAmmoForShotgun;
	}
	p.TotalBackAmmoForShotgun = tmp;
	return tmp;
}
static function int GetTotalBackAmmoForMachinegun(KFXPawn p)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.BackAmmoForMachinegun;
	}
	p.TotalBackAmmoForMachinegun = tmp;
	return tmp;
}
static function int GetTotalBackAmmoForPistol(KFXPawn p)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		tmp += de.BackAmmoForPistol;
	}
	p.TotalBackAmmoForPistol = tmp;
	return tmp;
}
static function int GetTotalBombLevel(KFXPawn p, out int value)
{
	local KFXDecoration de;
	local int tmp;
	for(de = p.MyDecorations; de != none; de = de.NextDecoration)
	{
		if(de.BombLevel > tmp)
			tmp = de.BombLevel;
	}
	value = tmp;
	return value;
}


static function int GetDecorationType(int id)
{
	//�ֳɼ�����
	//�����֡������������ȡ����ȡ���
	//��Ӧ�ı�ʶΪ��1,2,3,4,5,6,7
	//0Ϊ����

	id = id >> 16;
	if(id == 251)
		return 1;
	else if(id == 252)
		return 2;
	else if(id == 253)
		return 3;
	else if(id == 254)
		return 4;
	else if(id == 255)
		return 5;
	else if(id == 256)
		return 6;
	else if(id == 257)
		return 7;
	else if(id == 0)
		return 8;		//��ɫ�Ҽ�
	else if(id == 258)	//�ؼ�
		return 9;
	else
		return 0;

}

//�������id���ṩ���ⲿ�ӿڣ���ں���
static function KFXDecoration KFXCreateDecoration(int id, Pawn p)
{
	local KFXCSVTable csvDA;
	local KFXDecoration de;
	csvDA = class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationAttribute.csv");
	if(id <= 0)
		return none;
	if(csvDA == none || !csvDA.SetCurrentRow(id))
	{
		log("#### WARNING #### can't create decoration!did="$id);
		return none;
	}
	de = p.spawn(class<KFXDecoration>( DynamicLoadObject( "XXXWeapons.XXX_DecDecoration"$id, class'Class',true ) ), p);
	de.Instigator = p;
	if(de != none)
	{
		de.KFXInit(id, KFXPawn(p));
		de.NextDecoration = KFXPawn(p).MyDecorations;
		KFXPawn(p).MyDecorations = de;
	}
	else
	{
     	log("#### WARNING #### can't create decoration!");
	}
	return de;
}
static function KFXReplaceSelf(int ReplaceId, int NewID, Pawn p)
{
	//����һ��
	class'KFXDecoration'.static.KFXDeleteSelf(replaceID, p);
	KFXCreateDecoration(NewID, p);
}
static function KFXDeleteSelf(int ReplaceID, Pawn p)
{
	local KFXDecoration di;
	local KFXDecoration dself;
	local int find;
	//���������Ƴ��ɵ�
	for(di=KFXPawn(p).MyDecorations; di != none; di = di.NextDecoration)
	{
		if(di.NextDecoration != none && di.NextDecoration.did == ReplaceID)
		{
			dself = di.NextDecoration;
			di.NextDecoration = dself.NextDecoration;
			dself.DestroyDecoration();
			find = 1;
			break;
		}
	}
	if(find == 0 && KFXPawn(p).MyDecorations != none &&
		KFXPawn(p).MyDecorations.did == replaceID)
	{
		dself = KFXPawn(p).MyDecorations;
		KFXPawn(p).MyDecorations = KFXPawn(p).MyDecorations.NextDecoration;
		dself.DestroyDecoration();
		find = 1;
	}
	if(find > 0)
	{

	}
	else
	{

	}
}
function CSVConfig(array<int> ids)
{
    local int id;
    id = ids[0];
    csvKFXinit(id);
}
function KFXinit(int id, KFXPawn p)
{
	local KFXCSVTable csvDA;
	local KFXCSVTable csvDeModel;
	local int TeamID;
	csvDeModel = class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationModel.csv");
	//�󶨵�������
	if(p.IsRedRole == 255)
	{
		if(KFXPlayerReplicationInfo(p.PlayerReplicationInfo).IsRedTeam())
    	{
			TeamID = 1;
		}
		else
		{
			TeamID = 0;
		}
	}
	else
	{
		if(p.IsRedRole == 1)
		{
			TeamID = 1;
		}
		else
		{
			TeamID = 0;
		}
	}

	//Ů�Խ�ɫ��id
	if(p.bIsFemale)
		TeamID = 2+TeamID;

	log("[LABOR]--------------decoration info:"$TeamID@did@p.bIsFemale
			@modelid[TeamID]
			@TeamSkins[TeamID]
			@BindBone[TeamID]
			@"loc="$RelLocor[TeamID]
			@"rot="$RelRotor[TeamID].Roll@RelRotor[TeamID].Yaw@RelRotor[TeamID].Pitch
			@P.PlayerReplicationInfo.PlayerName);

	if(!csvDeModel.SetCurrentRow(modelid[TeamID]))
	{
        log("csvDeModel SetCurrentRow modelid error  "$modelid[TeamID]);
    }

	//����ʾvip��ɫ�Ҽ���ģ��
	if(p.CanShowDecoration())
	{
		if(DecorationType == 2)
		{
	    	p.Skins.Length = 2;
	        p.Skins[1] = Material(DynamicLoadObject(TeamSkins[TeamID], class'Material'));
	        P.RequestRecord(""$"6 "$TeamSkins[TeamID]); //RDN_Texture1
	    }
		else if(DecorationType == 7)
		{
			//p.Skins[1] = Material(DynamicLoadObject(csvDeModel.GetString("ViewSkin"), class'Material'));
			if(p.Level.NetMode != NM_DedicatedServer)
			{
				p.AvatarLegs = p.spawn(class'KFXAvatarPart');
				p.AvatarLegs.Instigator = p;
				p.KFXIsAvatar = true;
				p.AvatarLegs.KFXInitialize(TeamSkins[TeamID], csvDeModel.GetString("ViewMesh"), p);
	            p.AvatarLegs.NotifyInitEnd();
				p.AvatarLegs.modeid = modelid[TeamID];

				if(p.Controller != none)
					PlayerController(p.Controller).bBehindView = false;
				p.AvatarLegs.bHidden = p.IsFirstPerson();
			}
		}
		else if(DecorationType == 8 || DecorationType == 9)
		{
	    	//��ɫ�Ҽ�û��ģ��
		}
		else
		{
	        RequestRecord(""$"5 "$TeamSkins[TeamID]); //RDN_Texture1

			LinkMesh(Mesh(dynamicLoadObject(csvDeModel.GetString("ViewMesh"), class'Mesh')));
	        //Skins[0] = Material(DynamicLoadObject(csvDeModel.GetString("ViewSkin"), class'Material'));
			//LinkMesh(Mesh(dynamicLoadObject(TeamMesh[TeamID], class'Mesh')));
			Skins[0]= Material(DynamicLoadObject(TeamSkins[TeamID], class'Material'));
			p.AttachToBone(self, BindBone[TeamID]);

			//��������
	    	AttachToPawn(TeamID);
	    	//��������
			SetDrawScale3D(RelScale[TeamID]);
		}
	}

    NotifyInitEnd();
}

function csvKFXInit(int id)
{
	local KFXCSVTable csvDA;
	local KFXCSVTable csvDeModel;
	local int typ;
	local int i;

	csvDA = class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationAttribute.csv");
	csvDeModel = class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationModel.csv");
	if(csvDA != none && csvDeModel != none && csvDA.SetCurrentRow(id))
	{
		did = id;

		//�������
    	GrenadeEx = csvDA.GetInt("GrenadeEx");

		ArmorExBody = csvDA.GetFloat("ArmorExBody");
		ArmorExHead = csvDA.GetFloat("ArmorExHead");
		ArmorValue = csvDA.GetInt("ArmorValue");
    	ChangeSpeedEx = csvDA.GetFloat("ChangeSpeedEx");
    	MoveSpeedEx = csvDA.GetFloat("MoveSpeedEx");
    	C4Ex = csvDA.GetFloat("C4Ex");
    	AntiFlashEx = csvDA.GetFloat("AntiFlashEx");
    	HonorPointEx = csvDA.GetFloat("HonorPointEx");
    	SilverEx = csvDA.GetFloat("SilverEx");
        WeaponBrightUpDown = csvDA.GetInt("WeaponBrightUpDown");

        StepSoundVolumeEx = csvDA.GetFloat("StepSoundVolume");
        StepSoundRadiusEx = csvDA.GetFloat("StepSoundRadius");
        FallDownHurtEx = csvDA.GetFloat("FallDownHurt");
        HoldBreathEx = csvDA.GetFloat("HoldBreath");

        BackAmmoForRifle = csvDA.GetInt("BackAmmoForRifle");
        BackAmmoForSubMachine = csvDA.GetInt("BackAmmoForSubMachine");
        BackAmmoForSniper = csvDA.GetInt("BackAmmoForSniper");
        BackAmmoForShotgun = csvDA.GetInt("BackAmmoForShotgun");
        BackAmmoForMachinegun = csvDA.GetInt("BackAmmoForMachinegun");
        BackAmmoForPistol = csvDA.GetInt("BackAmmoForPistol");

        BombLevel = csvDA.GetInt("BombLevel");
        typ = class'KFXDecoration'.static.GetDecorationType(id);
        DecorationType = EDecorationType(typ);

    	modelid[0] = csvDA.GetInt("BlueModel");
    	modelid[1] = csvDA.GetInt("RedModel");
    	modelid[2] = csvDA.GetInt("BlueModel_Female");
    	modelid[3] = csvDA.GetInt("RedModel_Female");

        //��ɫ�Ҽ�û��ģ��
        for(i=0; i<4; i++)
        {
			if(csvDeModel.SetCurrentRow(modelid[i]))
			{
	            typ = class'KFXDecoration'.static.GetDecorationType(id);
	            DecorationType = EDecorationType(typ);
				if(typ == 2)
				{
	            	TeamSkins[i] = csvDeModel.GetString("ViewSkin");
	            }
	            else if(typ == 7||typ == 8 || typ == 9)
	            {
					TeamSkins[i] = csvDeModel.GetString("ViewSkin");
	            }
				else
				{
					//LinkMesh(Mesh(dynamicLoadObject(csvDeModel.GetString("ViewMesh"), class'Mesh')));
					TeamSkins[i] = csvDeModel.GetString("ViewSkin");
	                Skins[0] = Material(DynamicLoadObject(TeamSkins[i], class'Material'));
				}
				BindBone[i] = csvDeModel.GetName("BindBone");
				csvAttachToPawn(i,modelid[i]);
			}
	        else
	        {
	            log("#### WARNING #### csvDeModel SetCurrentRow failed "$modelid[0]);
	        }
		}
	}
	else
	{
		log("#### WARNING #### can't initilize decoration!");
	}
}
//function string TrimString(string sorg)
//{
//	sorg = Mid(sorg, 1, len(sorg)-2);
//}
function name TransName(string s)
{
	if(s == "none")
		return '';
	else
		return class'DataTable'.static.StringToName(s);
}
function AttachToPawn(int modelid)
{
 	SetRelativeLocation(RelLocor[modelid]);
 	SetRelativeRotation(RelRotor[modelid]);
 	log("[LABOR]----------this decoration: "@"loc="$Location
	 				@"Rot="$Rotation);
}
function csvAttachToPawn(int TeamID, int modelID)
{
	local KFXCSVTable csvDA;
	local vector	vscale;
	local float		fscale;
	if(did > 0)
	{
		csvDA = class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationModel.csv");
		if(csvDA != none && csvDA.SetCurrentRow(modelID))
		{
			//set decoration scale:
			fscale = csvDA.GetFloat("Scale");
			if(fscale <= 0)
				fscale = 1.0;
			if(fscale != 1)
			{
				vscale.X = fscale;
				vscale.Y = fscale;
				vscale.Z = fscale;
				//SetDrawScale3D(vscale);
				RelScale[TeamID] = vscale;
			}
			//Instigator = p;
			ChangeCoordinate(TeamID,csvDA.GetFloat("LocationX"),
						csvDA.GetFloat("LocationY"),
						csvDA.GetFloat("LocationZ"),
						csvDA.GetInt("RotRoll"),
						csvDA.GetInt("RotYaw"),
						csvDA.GetInt("RotPitch"));
		}
		else
		{
			log("#### WARNING #### attach Decoration failed!");
		}

	}

}
//exec
function ChangeCoordinate(int TeamID, float x, float y, float z, int roll, int yaw, int pitch)
{
	local vector locor;
	local rotator rotor;
//	if(Instigator == none)
//		return;
	RelLocor[TeamID].X = x;
	RelLocor[TeamID].Y = y;
	RelLocor[TeamID].Z = z;
	RelRotor[TeamID].Roll = roll;
	RelRotor[TeamID].Yaw = yaw;
	RelRotor[TeamID].Pitch = pitch;
	log("[LABOR]----------TeamID="$TeamID
				@"loc="$RelLocor[TeamID]
				@"rot="$RelRotor[TeamID]);
}
function DoChangeCoordinate(float x, float y, float z, int roll, int yaw, int pitch)
{
	local vector locor;
	local rotator rotor;
	locor.X = x;
	locor.Y = y;
	locor.Z = z;
	rotor.Roll = roll;
	rotor.Yaw = yaw;
	rotor.Pitch = pitch;
 	SetRelativeLocation(locor);
 	SetRelativeRotation(rotor);
}
simulated function ReShow(KFXPawn p, int ForceRedTeam)
{
	local KFXCSVTable csvDeModel;
	local KFXCSVTable csvDA;
	local int mid;
	local int typ;

	//�������ʾ��ɫ�Ҽ�����ôֱ�ӷ���
	if(!p.CanShowDecoration())
		return;

	bhidden = true;
	//����ǽţ���ô�ý���������
	csvDA = class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationAttribute.csv");
	csvDeModel = class'KFXTools'.static.KFXCreateCSVTable("KFXDecorationModel.csv");
	if(csvDA == none || csvDeModel == none)
		return;
	if(csvDA.SetCurrentRow(did))
	{
		if(p.IsRedRole == 255)
		{
			//�������pawn��ʱû��PlayerReplicationInfo
			if(KFXPlayerReplicationInfo(p.PlayerReplicationInfo).IsRedTeam())
	    	{
				mid = 1;
			}
			else
			{
				mid = 0;
			}
		}
		else
		{
			if(p.IsRedRole == 1)
			{
				mid = 1;
			}
			else
			{
				mid = 0;
			}
		}

	}

	if(ForceRedTeam == 1)
		mid = 1;

	if(P.bIsFemale)
		mid = 2+mid;
	if(mid == 0)
	{
		mid = csvDA.GetInt("BlueModel");
	}
	else if(mid == 1)
	{
		mid = csvDA.GetInt("RedModel");
	}
	else if(mid == 2)
	{
		mid = csvDA.GetInt("BlueModel_Female");
	}
	else if(mid ==3)
	{
		mid = csvDA.GetInt("RedModel_Female");
	}
	log("[LABOR]-----------reshow mid="$mid@"female="$P.bIsFemale);
	if(!csvDeModel.SetCurrentRow(mid))
	{
		log("#### WARNING #### can't find this mode="$mid@"for decoration="$did);
		return;
	}

    typ = GetDecorationType(did);
	if(7 == typ)
	{
    	if(p.Level.NetMode == NM_Client)
    	{
			if(p.AvatarLegs != none)
			{
				p.AvatarLegs.KFXInitialize(csvDeModel.GetString("ViewSkin"), csvDeModel.GetString("ViewMesh"), p);
				p.AvatarLegs.bHidden = p.IsFirstPerson();
			}
			else
			{
				log("#### WARNING #### this's pawn doesn't have an avatar leg!");
			}

		}
	}
	else if(typ == 2)//�ֵĹҼ�
	{
		//�����ĹҼ�Ҫ������ͼ
		    p.Skins.Length = 2;
            p.Skins[1] = Material(DynamicLoadObject(csvDeModel.GetString("ViewSkin"), class'Material'));
            P.RequestRecord(""$"6 "$csvDeModel.GetString("ViewSkin")); //RDN_Texture1
	}
	else if(typ == 8 || typ == 9)	//��ɫ�Ҽ�
	{

	}
    else
    {
		Skins.Length = 1;
		Skins[0] = Material(DynamicLoadObject(csvDeModel.GetString("ViewSkin"), class'Material'));
		bHidden = false;
	}
}
simulated function DestroyDecoration()
{
	if(GetDecorationType(did) == 7 && KFXPawn(Instigator).AvatarLegs != none)
	{
		KFXPawn(Instigator).AvatarLegs.Destroy();
	}
	DetachFromBone(self);
	destroy();
}
simulated event BeginPlay()
{

}

defaultproperties
{
     DrawType=DT_Mesh
     RemoteRole=ROLE_None
}
