//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AnimNotify_FireRisk extends AnimNotify_Scripted;

event Notify( Actor Owner )
{
    local Actor FlashEffect;
    local Actor DBFlashEffect;
    local int  i;


    if(KFXWeapBase(Owner)!=none && !KFXWeapBase(Owner).bIsDoubleComponent  && KFXWeapBase(Owner).KFXWeapComponent[0]!=none &&
        KFXWeapBase(Owner).KFXWeapComponent[0].FireFlashClass!=none)
    {
        FlashEffect = Owner.Level.Spawn(KFXWeapBase(Owner).KFXWeapComponent[0].FireFlashClass,KFXWeapBase(Owner).KFXWeapComponent[0]);
        log("AnimNotify_FireRisk----111--FlashEffect "$FlashEffect);
        KFXWeapBase(Owner).KFXWeapComponent[0].AttachToBone(FlashEffect,'BONE_FLASH');
    }
    else if(KFXWeapBase(Owner)!=none && KFXWeapBase(Owner).bIsDoubleComponent && KFXWeapBase(Owner).KFXWeapComponent[0]!=none &&
        KFXWeapBase(Owner).KFXWeapComponent[0].FireFlashClass!=none)
    {
        FlashEffect = Owner.Level.Spawn(KFXWeapBase(Owner).KFXWeapComponent[0].FireFlashClass,KFXWeapBase(Owner).KFXWeapComponent[0]);
        DBFlashEffect = Owner.Level.Spawn(KFXWeapBase(Owner).KFXWeapComponent[0].FireFlashClass,KFXWeapBase(Owner).KFXWeapComponent[0]);

        log("AnimNotify_FireRisk----111--FlashEffect "$FlashEffect);
        KFXWeapBase(Owner).KFXWeapComponent[0].AttachToBone(FlashEffect,'BONE_FLASH');
        KFXWeapBase(Owner).KFXWeapComponent[0].DoubleComponent.AttachToBone(DBFlashEffect,'BONE_FLASH01');
    }
    else if(KFXWeapAttachment(Owner)!=none && KFXWeapAttachment(Owner).ComAttachment[0]!=none &&
        KFXWeapAttachment(Owner).ComAttachment[0].FireFlashClass!=none)
    {
        FlashEffect = Owner.Level.Spawn(KFXWeapAttachment(Owner).ComAttachment[0].FireFlashClass,KFXWeapAttachment(Owner).ComAttachment[0]);
        log("AnimNotify_FireRisk----222--FlashEffect "$FlashEffect);
        KFXWeapAttachment(Owner).ComAttachment[0].AttachToBone(FlashEffect,'BONE_FLASH');
    }
    else if(KFXSpectateWeap(Owner)!=none && KFXSpectateWeap(Owner).Component[0]!=none &&
        KFXSpectateWeap(Owner).Component[0].FireFlashClass!=none)
    {
        FlashEffect = Owner.Level.Spawn(KFXSpectateWeap(Owner).Component[0].FireFlashClass,KFXSpectateWeap(Owner).Component[0]);
        log("AnimNotify_FireRisk---333---FlashEffect "$FlashEffect);
        KFXSpectateWeap(Owner).Component[0].AttachToBone(FlashEffect,'BONE_FLASH');
    }
    else if ( RecordActor( Owner ) != none )
    {
        if ( FPWeaponCanvasActor(RecordActor( Owner ).LinkActor) != none )
        {
            return;
        }

        for ( i = 0; i<RecordActor( Owner ).FireFlashActor.Attached.Length; i++ )
        {
            if ( RecordActor( Owner ).FireFlashActor.Attached[i].Class == RecordActor( Owner ).FireFlashClass )
                RecordActor( Owner ).FireFlashActor.Attached[i].Destroy();
        }

        FlashEffect = Owner.Level.Spawn(RecordActor( Owner ).FireFlashClass,
            RecordActor( Owner ).FireFlashActor);
        //FlashEffect.SetLocation(RecordActor( Owner ).FireFlashActor.Location);
        RecordActor( Owner ).FireFlashActor.AttachToBone(FlashEffect,'BONE_FLASH');

        if ( FPWeaponCanvasActor(Owner) != none )
        {
            log("AnimNotify_FireRisk  FlashEffect Owner "$FPWeaponCanvasActor(Owner ).ResourcName$"FireFlashClass:"$RecordActor( Owner ).FireFlashClass$"FireFlashActor"$RecordActor( Owner ).FireFlashActor.ResourcName);
            log("AnimNotify_FireRisk FlashEffect Loc:"$FlashEffect.Location$
            "RecordActor( Owner ).Location:"$RecordActor( Owner ).Location$
            "FireFlashActor:"$RecordActor( Owner ).FireFlashActor.Location);
        }
    }
}

defaultproperties
{
}
