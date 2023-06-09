//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXPlaneSomke extends Emitter
    native;


simulated native final function UpdateDamagedEffect( int DamageLevel);

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=是
         FadeIn=是
         UniformSize=是
         BlendBetweenSubdivisions=是
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
         FadeOutStartTime=2.000000
         FadeInEndTime=0.160000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-300.000000,Max=300.000000)
         StartSizeRange=(X=(Min=250.000000,Max=250.000000),Y=(Min=250.000000,Max=250.000000),Z=(Min=250.000000,Max=250.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'fx_effect_texs.Fire.Fire_026'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Max=350.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'KFXGame.KFXPlaneSomke.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=是
         FadeIn=是
         SpinParticles=是
         UseSizeScale=是
         UseRegularSizeScale=否
         UniformSize=是
         BlendBetweenSubdivisions=是
         ColorScale(0)=(Color=(B=81,G=98,R=136,A=255))
         ColorScale(1)=(RelativeTime=0.300000,Color=(B=64,G=64,R=64,A=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=24,G=24,R=24,A=255))
         FadeOutStartTime=2.000000
         FadeInEndTime=0.820000
         StartLocationOffset=(Z=300.000000)
         StartLocationRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-50.000000,Max=100.000000))
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.100000,Max=0.100000))
         SizeScale(0)=(RelativeSize=1.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=300.000000,Max=300.000000),Y=(Min=300.000000,Max=300.000000),Z=(Min=300.000000,Max=300.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'fx_effect_texs.Fire.Fire_025'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=200.000000,Max=450.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'KFXGame.KFXPlaneSomke.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=是
         FadeOut=是
         FadeIn=是
         SpinParticles=是
         UseSizeScale=是
         UseRegularSizeScale=否
         UniformSize=是
         UseRandomSubdivision=是
         ColorScale(0)=(Color=(B=85,G=85,R=85,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=90,G=90,R=90,A=255))
         FadeOutStartTime=1.240000
         FadeInEndTime=0.980000
         StartLocationOffset=(Z=900.000000)
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.100000,Max=0.100000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=400.000000,Max=400.000000),Y=(Min=400.000000,Max=400.000000),Z=(Min=400.000000,Max=400.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'fx_effect_texs.Explode.Explode_012'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Max=400.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(2)=SpriteEmitter'KFXGame.KFXPlaneSomke.SpriteEmitter2'

     AutoDestroy=是
     bNoDelete=否
}
