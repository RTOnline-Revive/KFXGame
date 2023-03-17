//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXRedSmokeEffect extends fx_effect_smokeRed;
simulated function PostBeginPlay()
{
	local KFXPawn P;
	KFXAffectActor();

	foreach DynamicActors(class 'KFXPawn', P)
	{
		if(P!=none)
		{
			if(P.KFXPawnCanHid() && P.DrivenVehicle == none  && P.bCanSmokeEffect)
			{
				P.ProcessMultiLevelHide(true);
			}
		}
	}
	self.SetTimer(0.1,true);
}
simulated function Timer()
{
	KFXAffectActor();
}


simulated function KFXAffectActor()
{
	local KFXPawn P;
	foreach DynamicActors(class 'KFXPawn', P)
	{
		if( P!=none )
		{
			if( P.KFXPawnCanHid()  && P.bCanSmokeEffect)
			{
				if(abs( VSize(P.Location - Location) )<1200)
				{
					P.KFXCurSmokeAffect = true;
				}
				else
				{
					P.KFXCurSmokeAffect = false;
				}
			}
		}
	}
}

defaultproperties
{
}
