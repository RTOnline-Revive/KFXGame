//=============================================================================
// KFXRandPickupRule.
//=============================================================================
class KFXRandPickupRule extends KFXLiteRule
    dependson(NavigationPoint);

enum eRandPickupRuleType     //����������Ĳ�������
{
	PR_NONE,         //������
	PR_BEFOREGAME,   //��Ϸ֮ǰ�Ͳ���
	PR_RANDOMGENERATEINGAME  //��Ϸ���������
};

enum eRandPickupTimeRuleType    //����������ʱ�����
{
	PRT_ONECE,   //��Ϸ�в���һ��
	PRT_TICK  //ͬһ�ص���Զ�β�����
};
enum eWeaponFadeOutRuleType    //��������ص��Ƿ����������   //��ͣ��
{
	WR_NO,   //������
	WR_YES  //������
};
var array<NavigationPoint> WeapStartLoc;    //bot AI ֧�֡�
var eRandPickupRuleType   epr;
var eRandPickupTimeRuleType   eprt;
var int   tiemrsecond;  //���������������

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
			pickupfactory.Remove(randombox,1);      //��Ϊ�� PRT_ONECE ,�����Ƴ�
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
