//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXWeapFlame extends KFXWeapon;

simulated event StopFire(int Mode)
{
	super.StopFire(Mode);
    if ( KFXFireFlame(FireMode[0]).FlameEffect != none )
        KFXFireFlame(FireMode[0]).FlameEffect.Destroy();
    if ( KFXFireFlame(FireMode[0]).FlameCollideFogEffect != none )
        KFXFireFlame(FireMode[0]).FlameCollideFogEffect.Destroy();
    if ( KFXFireFlame(FireMode[0]).FlameNormalFogEffect != none )
        KFXFireFlame(FireMode[0]).FlameNormalFogEffect.Destroy();
}

simulated function Destroyed()
{
    super.Destroyed();

    if ( KFXFireFlame(FireMode[0]).FlameEffect != none )
        KFXFireFlame(FireMode[0]).FlameEffect.Destroy();
    if ( KFXFireFlame(FireMode[0]).FlameCollideFogEffect != none )
        KFXFireFlame(FireMode[0]).FlameCollideFogEffect.Destroy();
    if ( KFXFireFlame(FireMode[0]).FlameNormalFogEffect != none )
        KFXFireFlame(FireMode[0]).FlameNormalFogEffect.Destroy();

}

//// client only ////
simulated event ClientStartFire(int Mode)
{
	// Fixme!!!!!!!
	// ÓÐ¼«Ð¡µÄ¼¸ÂÊÔÚ·þÎñÆ÷¶Ë»¹Ã»ÓÐ½«µ¯Ò©ÊýÁ¿Í¬²½¹ýÀ´µÄÇé¿öÏÂ
	// ´¥·¢¸ÃÂß¼­£¬Òò´Ë¿Í»§¶Ë¿ÉÄÜ¿ª»ðÊ§°Ü£¬¶ø·þÎñÆ÷¶Ë¿ª»ð³É¹¦¡£
	// ÓÉÓÚ¶Ô×Óµ¯ÊýÁ¿½øÐÐÄ£Äâ£¬ËùÒÔÎÞ·¨¾«È·ÒÔ×Óµ¯ÊýÁ¿ÏÞÖÆ¿ª»ð
	// Ìõ¼þ ¡£AllowFireÐèÒªÖØÐÂÊµÏÖ£¡
	KFXSetSimReload(KFXGetReload());
	super(weapon).ClientStartFire(Mode);
}

defaultproperties
{
     bClientSimuFire=否
}
