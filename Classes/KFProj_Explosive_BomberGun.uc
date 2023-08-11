
class KFProj_Explosive_BomberGun extends KFProj_BallisticExplosive
	hidedropdown;

/** Cached reference to owner weapon */
var protected KFWeapon OwnerWeapon;

var bool bCanNuke;

/** Initialize the projectile */
function Init( vector Direction )
{
	super.Init( Direction );

	OwnerWeapon = KFWeapon( Owner );
	if( OwnerWeapon != none )
	{
		OwnerWeapon.LastPelletFireTime = WorldInfo.TimeSeconds;
	}
}

/** Don't allow more than one pellet projectile to perform this check in a single frame */
function bool ShouldWarnAIWhenFired()
{
	return super.ShouldWarnAIWhenFired() && OwnerWeapon != none && OwnerWeapon.LastPelletFireTime < WorldInfo.TimeSeconds;
}

/**
 * Force the fire not to burn the instigator, since setting it in the default props is not working for some reason - Ramm
 */
simulated protected function PrepareExplosionTemplate()
{
	ExplosionTemplate.bIgnoreInstigator = true;

    super.PrepareExplosionTemplate();
}

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
    // For some reason on clients up close shots with this projectile
    // get HitWall calls instead of Touch calls. This little hack fixes
    // the problem. TODO: Investigate why this happens - Ramm
    // If we hit a pawn with a HitWall call on a client, do touch instead
    if( WorldInfo.NetMode == NM_Client && Pawn(Wall) != none )
    {
        Touch( Wall, WallComp, Location, HitNormal );
        return;
    }

    Super.HitWall(HitNormal, Wall, WallComp);
}

/** Only allow this projectile to cause a nuke if there hasn't been another nuke very recently */
simulated function bool AllowNuke()
{
	return bCanNuke;
}

defaultproperties
{
	Physics=PHYS_Falling
    bBounce=false
	MaxSpeed=7000.0
	Speed=7000.0
	TerminalVelocity=7000.0
	TossZ=150
	GravityScale=1
    MomentumTransfer=50000.0
    ArmDistSquared=0 //87500 //2.5 meters - //122500 // 3.5 meters

	bWarnAIWhenFired=true

	ProjFlightTemplate=ParticleSystem'WEP_HRG_Kaboomstick_EMIT.FX_HRG_Kaboomstick_Projectile'
	ProjFlightTemplateZedTime=ParticleSystem'WEP_HRG_Kaboomstick_EMIT.FX_HRG_Kaboomstick_Projectile_ZEDTIME'
	ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
	AltExploEffects=KFImpactEffectInfo'WEP_HRG_Kaboomstick_ARCH.WEP_HRG_Kaboomstick_Explosion_Concussive_Force'
	
	AssociatedPerkClass(0)=class'KFPerk_Demolitionist'

	// Grenade explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
	    LightColor=(R=252,G=218,B=171,A=255)
		Brightness=0.5f
		Radius=400.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=FALSE
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
	End Object

	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=57//38	//30
		DamageRadius=200	//150
		DamageFalloffExponent=1.0f
		DamageDelay=0.f

		MomentumTransferScale=22500

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_BomberGun'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		//ExplosionEffects=KFImpactEffectInfo'WEP_HX25_Pistol_ARCH.HX25_Pistol_Submunition_Explosion'
		ExplosionSound=AkEvent'ww_wep_hrg_kaboomstick.WEP_HRG_Kaboomstick_Projectile_Explo'
		ExplosionEffects=KFImpactEffectInfo'WEP_HRG_Kaboomstick_ARCH.WEP_HRG_Kaboomstick_Explosion'
		//ExplosionSound=AkEvent'WW_WEP_Seeker_6.Play_WEP_Seeker_6_Explosion'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.3

		bIgnoreInstigator=true

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=0
		CamShakeOuterRadius=300
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	AmbientSoundPlayEvent=none
    AmbientSoundStopEvent=none

	bCanNuke = true
}