//-----------------------------------------------------------
//			战队臂章
//-----------------------------------------------------------
class FactionBadge extends Arming;

simulated function KFXInit(string Icon, string BackGround, int MeshID)
{
	local Combiner FactionIcon;

	if ( Level.NetMode == NM_DedicatedServer )
        return;

    FactionIcon = new class'Combiner';
	FactionIcon.Material1 = Material(DynamicLoadObject(BackGround, class'Material'));
	FactionIcon.Material2 = Material(DynamicLoadObject(Icon, class'Material'));
	FactionIcon.Mask = Material(DynamicLoadObject(Icon, class'Material'));
	FactionIcon.CombineOperation = CO_AlphaBlend_With_Mask;
	LinkMesh( Mesh(DynamicLoadObject("fx_prop_anims.mesh_levelbadge",class'Mesh')),false);
    Skins[0]= FactionIcon;
    KFXSetCoordinate(MeshID);
}

// 设置臂章坐标
simulated function KFXSetCoordinate(int MeshID)
{
    local KFXCSVTable Csv_DadgeLoc;
    local vector DadgeLoc;
    local rotator DadgeRot;

    Csv_DadgeLoc = class'KFXTools'.static.KFXCreateCSVTable("TeamDadgeLocation.csv");
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
    SetRelativeLocation(DadgeLoc);
    SetRelativeRotation(DadgeRot);
}

defaultproperties
{
}
