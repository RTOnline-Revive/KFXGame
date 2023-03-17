//=============================================================================
// KFXRandPickupRule.
//=============================================================================
class KFXRandPickupRule extends KFXLiteRule
    dependson(NavigationPoint);

enum eRandPickupRuleType     //武器补给箱的产生规则
{
	PR_NONE,         //不处理
	PR_BEFOREGAME,   //游戏之前就产生
	PR_RANDOMGENERATEINGAME  //游戏中随机产生
};

enum eRandPickupTimeRuleType    //武器补给箱时间规则
{
	PRT_ONECE,   //游戏中产生一次
	PRT_TICK  //同一地点可以多次产生。
};
enum eWeaponFadeOutRuleType    //武器掉落地点是否产生补给箱   //先停用
{
	WR_NO,   //不产生
	WR_YES  //产生。
};
var array<NavigationPoint> WeapStartLoc;    //bot AI 支持。
var eRandPickupRuleType   epr;
var eRandPickupTimeRuleType   eprt;
var int   tiemrsecond;  //多少秒产生补给箱

var array<KFXPickupFactory> pickupfactory;
function bool bIsneedTick()
{
     if(epr==PR_RANDOMGENERATEINGAME || eprt ==PRT_TICK)
         return true;
     else
         return false;
}
function doBeforeGame()
{
   if(epr==PR_BEFOREGAME && eprt ==PRT_ONECE)
   {
     InitAllKFXPickupFactory()  ;
   } else if(epr==PR_RANDOMGENERATEINGAME)
   {
     FindPickupFactory();
     SetTimer(tiemrsecond,true);
   }

}
function Timer()
{
   local  KFXPickupFactory tmp;
   local int randombox;
   local KFXRandPickup K;
   if(epr==PR_RANDOMGENERATEINGAME && eprt ==PRT_ONECE)
   {
       if(pickupfactory.length==0)
          SetTimer(0,false);
       randombox=Rand(pickupfactory.length);
       if(pickupfactory[randombox]==none)
        return;
       pickupfactory[randombox].PickupClass = class'KFXGame.KFXRandPickup';
		if(pickupfactory[randombox].PickUpItem == none)
		{
			pickupfactory[randombox].KFXSpawnPickup();
			KFXRandPickup(pickupfactory[randombox].PickUpItem).PickupTypeValue = PickWeap;
			KFXRandPickup(pickupfactory[randombox].PickUpItem).PickupID = KFXRandPickup(pickupfactory[randombox].PickUpItem).RandomAWeaponId();
			pickupfactory.Remove(randombox,1);      //因为是 PRT_ONECE ,所以移除
		}

   }   else if(epr==PR_RANDOMGENERATEINGAME && eprt ==PRT_TICK)
   {
        if(pickupfactory.length==0)
          SetTimer(0,false);
       randombox=Rand(pickupfactory.length);
       if(pickupfactory[randombox]==none)
        return;
       pickupfactory[randombox].PickupClass = class'KFXGame.KFXRandPickup';
		if(pickupfactory[randombox].PickUpItem == none)
		{
			pickupfactory[randombox].KFXSpawnPickup();
			KFXRandPickup(pickupfactory[randombox].PickUpItem).PickupTypeValue = PickWeap;
			KFXRandPickup(pickupfactory[randombox].PickUpItem).PickupID = KFXRandPickup(pickupfactory[randombox].PickUpItem).RandomAWeaponId();
		}
   }
}
function FindPickupFactory()
{
	local KFXPickupFactory A;
	local int i;
	i=0;
	foreach AllActors(class'KFXPickupFactory',A)
	{
		pickupfactory[i]=A;
		i++;
	}
}
function InitAllKFXPickupFactory()
{

   local   KFXPickupFactory   A;
   local   Pickup   P;
	foreach AllActors(class'KFXPickupFactory',A)
	{
		A.PickupClass = class'KFXGame.KFXRandPickup';
		if(A.PickUpItem == none)
		{
			A.KFXSpawnPickup();
			KFXRandPickup(A.PickUpItem).PickupTypeValue = PickWeap;
			KFXRandPickup(A.PickUpItem).PickupID = KFXRandPickup(A.PickUpItem).RandomAWeaponId();
		}

	}
	;
}

defaultproperties
{
     epr=PR_BEFOREGAME
     tiemrsecond=20
}
