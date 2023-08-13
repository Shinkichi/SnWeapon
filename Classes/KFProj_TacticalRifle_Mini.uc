
class KFProj_TacticalRifle_Mini extends KFProj_FlashBangGrenade
    hidedropdown;

var array<Actor> ImpactList;

//==============
/*  Touching
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if (Other != Instigator && !Other.bWorldGeometry)
	{
		// Don't hit teammates
		if (Other.GetTeamNum() == GetTeamNum())
		{
			return;
		}
		if (!bHasExploded && !bHasDisintegrated)
		{
			GetExplodeEffectLocation(HitLocation, HitNormal, Other);
			TriggerExplosion(HitLocation, HitNormal, Other);
		}
	}

	super.ProcessTouch(Other, HitLocation, HitNormal);
}*/

//==============
// Touching
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    //local bool bWantsClientSideDudHit;
	local float TraveledDistance;

    // If we collided with a Siren shield, let the shield code handle touches
    if( Other.IsA('KFTrigger_SirenProjectileShield') )
    {
        return;
    }

	// Don't hit teammates
	if( Other.GetTeamNum() == GetTeamNum() )
	{
        return;
	}

    // Need to do client side dud hits if this is a client
    //if( Instigator != none && Instigator.Role < ROLE_Authority )
	//{
    //    bWantsClientSideDudHit = true;
    //}

	TraveledDistance = (`TimeSince(CreationTime) * Speed);
	TraveledDistance *= TraveledDistance;

	// Process impact hits
    if (Other != Instigator && !Other.bStatic)
    {
		// check/ignore repeat touch events
		if( !CheckRepeatingTouch(Other) && Other.GetTeamNum() != GetTeamNum())
		{
			ProcessBulletTouch(Other, HitLocation, HitNormal);
		}
    }

    if( WorldInfo.NetMode == NM_Standalone ||
        (WorldInfo.NetMode == NM_ListenServer && Instigator != none && Instigator.IsLocallyControlled()) )
    {
        Super.ProcessTouch( Other, HitLocation, HitNormal );
		if (!bHasExploded && !bHasDisintegrated)
		{
			GetExplodeEffectLocation(HitLocation, HitNormal, Other);
			TriggerExplosion(HitLocation, HitNormal, Other);
		}
        return;
    }

    if( Owner != none && KFWeapon( Owner ) != none && Instigator != none )
    {
    	if( Instigator.Role < ROLE_Authority && Instigator.IsLocallyControlled() )
    	{
            KFWeapon(Owner).HandleClientProjectileExplosion(HitLocation, self);
			Super.ProcessTouch( Other, HitLocation, HitNormal );
			if (!bHasExploded && !bHasDisintegrated)
			{
				GetExplodeEffectLocation(HitLocation, HitNormal, Other);
				TriggerExplosion(HitLocation, HitNormal, Other);
			}
            return;
        }
    }

}

/** Handle bullet collision and damage */
simulated function ProcessBulletTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if (ImpactList.Find(Other) != INDEX_NONE)
	{
		return;
	}
	if (Other != none)
	{
		ImpactList.AddItem(Other);
	}

	super.ProcessBulletTouch(Other, HitLocation, HitNormal);
}

/** Blow up on impact */
simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	if( StaticMeshComponent(WallComp) != none && StaticMeshComponent(WallComp).CanBecomeDynamic() )
	{
		// pass through meshes that can move (like those little coffee tables in biotics)
		return;
	}

	Explode( Location, HitNormal );
}

defaultproperties
{
    Physics=PHYS_Falling
    Speed=4000
    MaxSpeed=4000
    TerminalVelocity=4000
    TossZ=150
    GravityScale=0.5
    MomentumTransfer=50000.0
    LifeSpan=25.0f

    bWarnAIWhenFired=true

    ProjFlightTemplate=ParticleSystem'WEP_Medic_GrenadeLauncher_EMIT.FX_Medic_GrenadeLauncher_Projectile'
    ProjFlightTemplateZedTime=ParticleSystem'WEP_Medic_GrenadeLauncher_EMIT.FX_Medic_GrenadeLauncher_Projectile_ZEDTIME'
    GrenadeBounceEffectInfo=KFImpactEffectInfo'FX_Impacts_ARCH.DefaultGrenadeImpacts'
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'
    AltExploEffects=KFImpactEffectInfo'WEP_M79_ARCH.M79Grenade_Explosion_Concussive_Force'

    // Grenade explosion light
    //Begin Object Class=PointLightComponent Name=ExplosionPointLight
	Begin Object Name=ExplosionPointLight
        LightColor=(R=252,G=218,B=171,A=255)
        Brightness=4.f
        Radius=2000.f
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
		Damage=125  //300
		DamageRadius=700  //800
		DamageFalloffExponent=2.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_TacticalRifle'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0	
		ExplosionEffects=KFImpactEffectInfo'WEP_M84_ARCH.M84_Explosion'
		ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Frag.Play_WEP_Flashbang'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=900
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
    End Object
    ExplosionTemplate=ExploTemplate0

    AmbientSoundPlayEvent=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Projectile_Loop'
    AmbientSoundStopEvent=AkEvent'WW_WEP_SA_M79.Stop_WEP_SA_M79_Projectile_Loop'
}

