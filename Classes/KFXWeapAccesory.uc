// ====================================================================
//  Class:  KFXGame.KFXWeapAccesory
//  Creator: Kevin Sun
//  Date: 2007.07.02
//  Description: ÎäÆ÷Åä¼þ
//  Log:
// (c) 2007, kingsoft, Inc - All Rights Reserved
// ====================================================================
class KFXWeapAccesory extends Inventory
    native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var KFXWeapBase WeapBase;
var private int KFXAccessoryID;

simulated function KFXInit(int AccessoryID, Actor BaseActor, bool bFirstPerson)
{
    local string MeshName, SkelName, MatName;
    local KFXCSVTable CFG_Accessory;

    KFXAccessoryID = AccessoryID;

    // Client Only
    if ( Level.NetMode == NM_DedicatedServer )
    {
        Log("[Kevin] Can't Spawn KFXWeapAccesory in DedicatedServer!");
        Destroy();
        return;
    }

    // Load Config Table
    CFG_Accessory  = class'KFXTools'.static.GetConfigTable(13);

    if ( !CFG_Accessory.SetCurrentRow(AccessoryID) )
    {
        Log("[Kevin] Unknow Accessory ID : "$AccessoryID);
        Destroy();
        return;
    }

    if ( bFirstPerson )
    {
        MeshName = CFG_Accessory.GetString("FPMesh");
        SkelName = CFG_Accessory.GetString("FPSkeleton");
        MatName  = CFG_Accessory.GetString("FPMaterial");

        LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')) );

        if ( !(SkelName ~= "null" ))
            LinkSkelAnim(
                MeshAnimation(DynamicLoadObject(SkelName, class'MeshAnimation'))
                );

        BoneRefresh();
    }
    else
    {
        MeshName = CFG_Accessory.GetString("TPMesh");
        SkelName = CFG_Accessory.GetString("TPSkeleton");
        MatName  = CFG_Accessory.GetString("TPMaterial");

        LinkMesh( Mesh(DynamicLoadObject(MeshName, class'Mesh')) );
        BoneRefresh();
    }

    WeapBase = KFXWeapBase(BaseActor);
}

function Destroyed()
{
}

// defaultproperties
// {
//      AttachmentClass=None
//      bSkipActorPropertyReplication=是
// }
