//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCombatMessage_CorpseKiller extends KFXInstCombatMessage;

var int CorpseKillerCount;
static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{

    local string soundname;
    log("CorpseKiller------RelatedPRI_1 "$RelatedPRI_1);
    log("CorpseKiller------RelatedPRI_1 == P.PlayerReplicationInfo "$(RelatedPRI_1 == P.PlayerReplicationInfo));
   	if ( RelatedPRI_1 == P.PlayerReplicationInfo )
	{
        // 判断连杀
        if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//不是观查者？？？
        {
            // 不是自杀
            if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{

                PlayEncourageSound(P, ET_CorpseKiller);
                log("CorpseKill------P "$P);

			}
		}
		// 观察者**目前和本人的逻辑相同
        else
        {
            //不是自杀
			if ( RelatedPRI_1 != RelatedPRI_2 && RelatedPRI_2 != none )
			{
			    PlayEncourageSound(P, ET_CorpseKiller);
			}
		}
	}
	else
	{
	    log("CorpseKiller------CorpseKillerCount "$default.CorpseKillerCount);
        if(default.CorpseKillerCount == 0)
        {
           if ( (!RelatedPRI_1.bOnlySpectator) && (P.Pawn != none) )//不是观查者？？？
           {
               default.CorpseKillerCount++;
               log("CorpseKiller---2323---CorpseKillerCount "$default.CorpseKillerCount);
               log("CorpseKiller---KFXPlayer(P).IsBlueTeam() "$KFXPlayer(P).IsBlueTeam());
               log("CorpseKiller---KFXPlayer(P).IsRedTeam() "$KFXPlayer(P).IsRedTeam());

               log("KillCorpse--1212----KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0) "$KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0));
               log("KillCorpse--1212----KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0) "$KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0));

               if(KFXPlayer(P).IsBlueTeam())
               {
                   	 soundname = "fx_shenghua_music.human.mutatekill_01";
                   	 log("CorpseKiller---2323---sound(DynamicLoadObject(soundname, class'Sound')) "$sound(DynamicLoadObject(soundname, class'Sound')));
                        P.Pawn.PlaySound( sound(DynamicLoadObject(soundname, class'Sound')), SLOT_None,
                    		1.0*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundVolumeFactor(0), false,
                    		100*KFXPlayer(P.Pawn.Level.GetLocalPlayerController()).GetSoundRadiusFactor(0), 1.0, false );
               }
               else if(KFXPlayer(P).IsRedTeam())
               {
                   	 soundname = "fx_shenghua_music.mutate.mutatekill_02";
                   	 log("CorpseKiller---3232---sound(DynamicLoadObject(soundname, class'Sound')) "$sound(DynamicLoadObject(soundname, class'Sound')));
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
