//-----------------------------------------------------------
//		角色的徽章
//-----------------------------------------------------------
class Arming extends Actor;

// Client Only
// 初始化徽章;模型、贴图、坐标
simulated function KFXInitLevelDadge(int UpGrade, int MeshID)
{
    local KFXCSVTable Csv_Level;
    local string sIcon;

    if ( Level.NetMode == NM_DedicatedServer )
        return;


	Csv_Level = class'KFXTools'.static.KFXCreateCSVTable("LevelUpgradeTable.csv");
    if( Csv_Level == none )
    {
        return;
    }

    if( !Csv_Level.SetCurrentRow(UpGrade) )
    {
    	log("[Arming] error: Wrong Grade with UpGrade:" @ UpGrade);
        return;
    }

	sIcon = Csv_Level.GetString("LevelbadgeIcon");

	LinkMesh( Mesh(DynamicLoadObject("fx_prop_anims.mesh_levelbadge",class'Mesh')),false);
   	Skins[0]= Material( DynamicLoadObject(sIcon,class'Material') );
   	KFXSetCoordinate(MeshID);
}

// 初始化单身臂章
simulated function KFXInitSingleBadge(int MeshID, string BadgeMat)
{
    local string sIcon;

    if ( Level.NetMode == NM_DedicatedServer )
        return;

   if ( BadgeMat != "" )
	{
		sIcon = BadgeMat;
	}
	LinkMesh( Mesh(DynamicLoadObject("fx_prop_anims.mesh_levelbadge",class'Mesh')),false);
   	Skins[0]= Material( DynamicLoadObject(sIcon,class'Material') );
    KFXSetCoordinate(MeshID);
}

// 设置臂章坐标
simulated function KFXSetCoordinate(int MeshID)
{
    local KFXCSVTable Csv_DadgeLoc;
    local vector DadgeLoc;
    local rotator DadgeRot;

    Csv_DadgeLoc = class'KFXTools'.static.KFXCreateCSVTable("LevelDadgeLocation.csv");
    if( Csv_DadgeLoc == none )
    {
        return;
    }

    if ( !Csv_DadgeLoc.SetCurrentRow(MeshID) )
    {
        log("[Arming] error: Wrong mesh ID with MeshID:" @ MeshID);
		return;
    }
    DadgeLoc.X = Csv_DadgeLoc.GetFloat("LocationX");
    DadgeLoc.Y = Csv_DadgeLoc.GetFloat("LocationY");
    DadgeLoc.Z = Csv_DadgeLoc.GetFloat("LocationZ");
    DadgeRot.Roll = Csv_DadgeLoc.GetFloat("RotRoll");
    DadgeRot.Yaw = Csv_DadgeLoc.GetFloat("RotYaw");
    DadgeRot.Pitch = Csv_DadgeLoc.GetFloat("RotPitch");
    ;
    SetRelativeLocation(DadgeLoc); // 0 0 10   vect(LocationX, LocationY, LocationZ)
    SetRelativeRotation(DadgeRot);     //rot(0,16384,49152)
}

defaultproperties
{
     DrawType=DT_Mesh
}
