class KFXBotJumpPoint extends JumpPad
	placeable;

event Touch(Actor Other)
{
	if ((KFXAIBotPawnBase(Other) == none) || (Pawn(Other) == None) || (Other.Physics == PHYS_None) || (Vehicle(Other) != None) )
		return;

	PendingTouch = Other.PendingTouch;
	Other.PendingTouch = self;
}

event PostTouch(Actor Other)
{
	local Pawn P;

	P = Pawn(Other);
	if ( (P == None) || (P.Physics == PHYS_None) || (Vehicle(Other) != None) || (P.DrivenVehicle != None)
		|| KFXAIBotPawnBase(Other) == none )
		return;

	if( AIController(P.Controller) != none )
	{
		log("KFXBotJumPoint---AIController(P.Controller).MoveTarget"$AIController(P.Controller).MoveTarget);
		log("KFXBotJumPoint---self:"$self);
        //if(AIController(P.Controller).MoveTarget == self)
//		{
//			return;
//		}
//		if(AIController(P.Controller).RouteGoal == none || AIController(P.Controller).RouteGoal == self)
//		{
//			return;
//		}
//		else
//		{
//			if(AIController(P.Controller).MoveTarget != JumpTarget)
//			{
//				return;
//			}
//		}
        log("KFXBotJumPoint---6---");
		P.SetRotation(rotator(JumpTarget.Location - P.Location));
		AIController(P.Controller).MoveTarget = JumpTarget;
	}

	if ( AIController(P.Controller) != None )
	{
		P.Controller.Movetarget = JumpTarget;
		P.Controller.Focus = JumpTarget;
		if ( P.Physics != PHYS_Flying )
			P.Controller.MoveTimer = 2.0;
		P.DestinationOffset = JumpTarget.CollisionRadius;
	}
	if ( P.Physics == PHYS_Walking )
		P.SetPhysics(PHYS_Falling);
	P.Velocity =  JumpVelocity;
	P.Acceleration = vect(0,0,0);
	if ( JumpSound != None )
		P.PlaySound(JumpSound);

}

defaultproperties
{
     JumpVelocity=(Z=600.000000)
}
