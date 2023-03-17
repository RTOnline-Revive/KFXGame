//=============================================================================
// KFXliteRule.
//=============================================================================
class KFXLiteRule extends Info
    abstract;

var KFXLiteRule NextGameLiteRules;


function AddGameLiteRules(KFXLiteRule GR)
{
	if ( NextGameLiteRules == None )
		NextGameLiteRules = GR;
	else
		NextGameLiteRules.AddGameLiteRules(GR);
}
function bool  bIsneedTick()
{
   return false;
}
function doBeforeGame() ;

defaultproperties
{
}
