//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXWeapon extends KFXWeapBase;

var bool bForbidAddonAmmo;

function KFXSetupAddonAmmo(KFXPawn p)
{
	if(!bForbidAddonAmmo)
	{
		super.KFXSetupAddonAmmo(P);
	}
}

defaultproperties
{
     SoundRadius=40.000000
     TransientSoundRadius=200.000000
}
