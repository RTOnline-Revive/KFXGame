//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCombatMessage_KillCorpse extends KFXInstCombatMessage;
var int KillCorpseCount;
static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    local string soundname;
    log("KillCorpse------RelatedPRI_1 "$RelatedPRI_1);
    log("KillCorpse------RelatedPRI_2 "$RelatedPRI_2);

    log("KillCorpse------RelatedPRI_1 == P.PlayerReplicationInfo"$RelatedPRI_1 == P.PlayerReplicationInfo);

   	if ( RelatedPRI_1 == P.PlayerReplicationInfo )
	{
        // 判断连杀
        if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//不是观查者？？？
        {
            // 不是自杀
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{

                PlayEncourageSound(P, ET_Corpse);
                log("KillCorpse------P "$P);

			}
		}
		// 观察者**目前和本人的逻辑相同
        else
        {
            //不是自杀
			if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
			    PlayEncourageSound(P, ET_Corpse);
			}
		}
	}
	else
	{
        log("KillCorpse------KillCorpseCount "$default.KillCorpseCount);

        if(default.KillCorpseCount == 0)
        {
           if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//不是观查者？？？
           {
               default.KillCorpseCount++;
               log("KillCorpse---2312---KillCorpseCount "$default.KillCorpseCount);
               log("KillCorpse---2312---KFXPlayer(P).IsBlueTeam() "$default.KillCorpseCount);

               log("KillCorpse--2121----KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0) "$KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0));
               log("KillCorpse--2121----KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0) "$KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));

               if(KFXPlayer(P).IsBlueTeam())
               {
                   	 soundname = "fx_shenghua_music.human.humankill_0"$(rand(2)+1);
                   	 log("KillCorpse---2312---soundname "$soundname);
                   	 log("KillCorpse---2323---sound(DynamicLoadObject(soundname, class'Sound')) "$sound(DynamicLoadObject(soundname, class'Sound')));
                        P.Pawn.PlaySound( sound(DynamicLoadObject(soundname, class'Sound')), SLOT_None,
                    		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), false,
                    		100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );
               }
               else if(KFXPlayer(P).IsRedTeam())
               {
                   	 soundname = "fx_shenghua_music.mutate.humankill_03";
                   	 log("KillCorpse---3232---sound(DynamicLoadObject(soundname, class'Sound')) "$sound(DynamicLoadObject(soundname, class'Sound')));
                     P.Pawn.PlaySound( sound(DynamicLoadObject(SoundName, class'Sound')), SLOT_None,
                    		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), false,
                    		100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );

               }

           }
        }

    }

}

defaultproperties
{
}
