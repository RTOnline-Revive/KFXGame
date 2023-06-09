// ====================================================================
//  Class:  KFXGame.KFXAvatarPart
//  Creator: Kevin Sun
//  Date: 2007.12.18
//  Description: Avatar
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXAvatarPart extends AvatarPart
    native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var private KFXPawnBase KFXBasePawn;
var private int KFXAvatarID;
var private byte KFXTeamID;  // ÓÃÀ´¾ö¶¨ÌùÍ¼ÑÕÉ«
var int modeid;     //avatarÄ£ÐÍÏà¹ØÊý¾ÝµÄid

simulated function KFXAvatarInitialize( KFXPawnBase BasePawn, byte TeamID, int AvatarID, MeshAnimation SkelAnim, optional bool PartitionTeam )
{
    KFXBasePawn = BasePawn;
    // Really necessry ?
    //LinkSkelAnim(SkelAnim);
    KFXAvatarChangeMesh(AvatarID, TeamID, true, PartitionTeam);
}

simulated function KFXAvatarChangeMesh(int AvatarID, byte TeamID, optional bool NoKeepAnim, optional bool PartitionTeam )
{
    local KFXCSVTable CFG_Avatar, CFG_Skel;
    local string MeshName;
    local string Skin1, Skin2;
    local string SkeletonName;

    KFXAvatarID = AvatarID;
    KFXTeamID   = TeamID;

    CFG_Avatar = class'KFXTools'.static.GetConfigTable(44);
    CFG_Skel  = class'KFXTools'.static.GetConfigTable(45);

    if ( CFG_Avatar == none ) return;

    if ( !CFG_Avatar.SetCurrentRow(KFXAvatarID) )
    {
        log("KFXAvatarChangeMesh SetCurrentRow failed!!!!!!!");
        Destroy();
        return;
    }

    MeshName = CFG_Avatar.GetString("mesh");
    LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')), !NoKeepAnim );
    SkeletonName = CFG_Skel.GetString("Res");
    LinkSkelAnim(MeshAnimation(DynamicLoadObject(SkeletonName, class'MeshAnimation')));
    SkeletonName = CFG_Skel.GetString("Res2");   // ¶ÁÈ¡Ë«³ÖÎäÆ÷¶¯»­°ü
    LinkSkelAnim(MeshAnimation(DynamicLoadObject(SkeletonName, class'MeshAnimation')));

    BoneRefresh();

    // Set Skins
    Skin1 = CFG_Avatar.GetString("skin1");
    Skin2 = CFG_Avatar.GetString("skin2");
    KFXChangeSkin(Skin1,Skin2,TeamID, PartitionTeam);
}
simulated function KFXChangeSkin(string Skin1,string Skin2,optional int TeamID, optional bool PartitionTeam)
{

    if((Skin1 == "none"&&Skin2=="none")||(Skin1 == ""&&Skin2==""))
    {
        Log("[AvatarPart] There is no Skin1 and Skin2");
        return;
    }
    if(Skins.Length==0)
    {
        Skins.Insert(0,2);
    }

//    if(KFXGhostPawn(KFXBasePawn)!=none&& KFXGhostPawn(KFXBasePawn).KFXPawnCanHid())
//    {
//        return;
//    }

    Skins[0] = none;
    Skins[1] = none;

    if ( Skin1 != "none" )
    {
        //Skin1 = KFXBasePawn.KFXGetTeamColoredString(Skin1, TeamID);
        Skins[0]= Material(DynamicLoadObject(Skin1, class'Material'));
        log("avatar has  change skin1 "$Skins[0]);
    }

    if ( Skin2 != "none" )
    {
        //Skin2 = KFXBasePawn.KFXGetTeamColoredString(Skin2, TeamID);
        Skins[1]= Material(DynamicLoadObject(Skin2, class'Material'));
    }
}
function KFXInitialize(string skin1, string meshstr, KFXPawn p)
{
	LinkMesh(Mesh(DynamicLoadObject(meshstr, class'Mesh')));
	if(Skins.Length < 1)
		Skins.Length = 1;
	Skins[0] = Material(DynamicLoadObject(skin1, class'Material'));
    RequestRecord(""$"5 "$skin1); //RDN_Texture1

	p.AttachToBone(self, '');
	log("KFXAvatartPart   KFXInitialize");
	log("KFXAvatartPart Pawn In state :"$GetStateName());
	if(P.IsInState('Dying'))
	{
        log("KFXAvatartPart Pawn  In Dying State");
    }
    else
    {
         BoneRefresh();
    }

}

defaultproperties
{
     CullDistance=0.000000
     bUseDynamicLights=是
     bSkipActorPropertyReplication=是
}
