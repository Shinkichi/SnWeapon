class KFProj_Thrown_E4 extends KFProjectile;

var KFImpactEffectInfo ImpactEffectInfo;

/** "beep" sound to play (on an interval) when instigator is within blast radius */
var() AkEvent ProximityAlertAkEvent;
/** Time between proximity beeps */
var() float ProximityAlertInterval;
/** Time between proximity beeps when the instigator is within "fatal" radius */
var() float ProximityAlertIntervalClose;
/** Time until next alert */
var transient float ProximityAlertTimer;

/** Visual component of this projectile (we don't use ProjEffects particle system because we need to manipulate the MIC) */
var StaticMeshComponent ChargeMesh;
/** Mesh MIC, used to make LED blink */
var MaterialInstanceConstant ChargeMIC;
/** Dynamic light for blinking */
var PointLightComponent BlinkLightComp;
/** Blink colors */
var LinearColor BlinkColorOn, BlinkColorOff;
/** How long LED and dynamic light should stay lit for */
var float BlinkTime;

var ParticleSystem BlinkFX;
var ParticleSystemComponent BlinkPSC;

/** Id for skin override */
var repnotify int WeaponSkinId;

replication
{
	if(bNetDirty)
		WeaponSkinId;
}

simulated function PostBeginPlay()
{
	if( WorldInfo.NetMode != NM_Client )
	{
		if( InstigatorController != none )
		{
			class'KFGameplayPoolManager'.static.GetPoolManager().AddProjectileToPool( self, PPT_C4 );
		}
		else
		{
			Destroy();
			return;
		}
	}

	super.PostBeginPlay();

	ProximityAlertTimer = ProximityAlertInterval;

	AdjustCanDisintigrate();

	ChargeMIC = ChargeMesh.CreateAndSetMaterialInstanceConstant(0);
}

/** Used to check current status of StuckTo actor (to figure out if we should fall) */
simulated event Tick( float DeltaTime )
{
	super.Tick(DeltaTime);

	StickHelper.Tick(DeltaTime);

	if (StuckToActor != none)
	{
		UpdateAlert(DeltaTime);
	}
}

/** Checks if deployed charge should play a warning "beep" for the instigator. Beeps faster if the instigator is within "lethal" range. */
simulated function UpdateAlert( float DeltaTime )
{
	local vector ToInstigator, BBoxCenter;
	local float DistToInstigator, DamageScale;
	local Actor TraceActor;
	local Box BBox;

	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if( bHasExploded || bHasDisintegrated )
	{
		return;
	}

	if( ProximityAlertTimer <= 0 )
	{
		return;
	}

	ProximityAlertTimer -= DeltaTime;

	if( ProximityAlertTimer > 0 )
	{
		return;
	}

	ProximityAlertTimer = ProximityAlertInterval;

	// only play sound for instigator (based on distance)
	if( Instigator != none && Instigator.IsLocallyControlled() )
	{
		ToInstigator = Instigator.Location - Location;
		DistToInstigator = VSize( ToInstigator );
		if( DistToInstigator <= ExplosionTemplate.DamageRadius )
		{
			Instigator.GetComponentsBoundingBox(BBox);
			BBoxCenter = (BBox.Min + BBox.Max) * 0.5f;
			TraceActor = class'GameExplosionActor'.static.StaticTraceExplosive(BBoxCenter, Location + vect(0,0,20), self);
			if( TraceActor == none || TraceActor == Instigator )
			{
				DamageScale = FClamp(1.f - DistToInstigator/ExplosionTemplate.DamageRadius, 0.f, 1.f);
				DamageScale = DamageScale ** ExplosionTemplate.DamageFalloffExponent;

				if( ExplosionTemplate.Damage * DamageScale > Instigator.Health )
				{
					ProximityAlertTimer = ProximityAlertIntervalClose;
				}

				PlaySoundBase( ProximityAlertAkEvent, true );
			}
		}
	}

	// blink for everyone to see
	BlinkOn();
}

/** Turns on LED and dynamic light */
simulated function BlinkOn()
{
	if( BlinkPSC == none )
	{
		BlinkPSC = WorldInfo.MyEmitterPool.SpawnEmitter(BlinkFX, Location + (vect(0,0,4) + vect(8,0,0) >> Rotation),, self,,, true);
	}

	BlinkPSC.SetFloatParameter('Glow', 1.0);

	ChargeMIC.SetVectorParameterValue('Vector_GlowColor', BlinkColorOn);
	BlinkLightComp.SetEnabled( true );
	SetTimer( BlinkTime, false, nameof(BlinkOff) );
}

/** Turns off LED and dynamic light */
simulated function BlinkOff()
{
	if( BlinkPSC != none )
	{
		BlinkPSC.SetFloatParameter('Glow', 0.0);
	}

	ChargeMIC.SetVectorParameterValue('Vector_GlowColor', BlinkColorOff);
	BlinkLightComp.SetEnabled( false );
}

simulated function SetStickOrientation(vector HitNormal)
{
	local rotator StickRot;

	StickRot = CalculateStickOrientation(HitNormal);
    SetRotation(StickRot);
}

/** Causes charge to explode */
function Detonate()
{
	local KFWeap_Thrown_E4 E4WeaponOwner;
	local vector ExplosionNormal;

	if( Role == ROLE_Authority )
    {
    	E4WeaponOwner = KFWeap_Thrown_E4( Owner );
    	if( E4WeaponOwner != none )
    	{
    		E4WeaponOwner.RemoveDeployedCharge(, self);
    	}
    }

	ExplosionNormal = vect(0,0,1) >> Rotation;
	Explode( Location, ExplosionNormal );
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		BlinkOff();
	}

	super.Explode( HitLocation, HitNormal );
}

simulated function Disintegrate( rotator InDisintegrateEffectRotation )
{
	local KFWeap_Thrown_E4 E4WeaponOwner;

	if( Role == ROLE_Authority )
    {
    	E4WeaponOwner = KFWeap_Thrown_E4( Owner );
    	if( E4WeaponOwner != none )
    	{
    		E4WeaponOwner.RemoveDeployedCharge(, self);
    	}
    }

    if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		BlinkOff();
	}

    super.Disintegrate( InDisintegrateEffectRotation );
}

// for nukes && concussive force
/*simulated protected function PrepareExplosionTemplate()
{
	class'KFPerk_Demolitionist'.static.PrepareExplosive( Instigator, self );

    super.PrepareExplosionTemplate();
}

simulated protected function SetExplosionActorClass()
{
   local KFPlayerReplicationInfo InstigatorPRI;

    if( WorldInfo.TimeDilation < 1.f && Instigator != none )
    {
       InstigatorPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
        if( InstigatorPRI != none )
        {
            if( InstigatorPRI.bNukeActive && class'KFPerk_Demolitionist'.static.ProjectileShouldNuke( self ) )
            {
                ExplosionActorClass = class'KFPerk_Demolitionist'.static.GetNukeExplosionActorClass();
            }
        }
    }

    super.SetExplosionActorClass();
}*/

/** Blows up on a timer */
function Timer_Explode()
{
	Detonate();
}

/** Remove C4 from pool */
simulated event Destroyed()
{
	if( WorldInfo.NetMode != NM_Client )
	{
		if( InstigatorController != none )
		{
			class'KFGameplayPoolManager'.static.GetPoolManager().RemoveProjectileFromPool( self, PPT_C4 );
		}
	}

	super.Destroyed();
}

/** Called when the owning instigator controller has left a game */
simulated function OnInstigatorControllerLeft()
{
	if( WorldInfo.NetMode != NM_Client )
	{
		SetTimer( 1.f + Rand(5) + fRand(), false, nameOf(Timer_Explode) );
	}
}

simulated function SetWeaponSkin(int SkinId)
{
	local array<MaterialInterface> SkinMICs;
	local int i;

	if (SkinId > 0)
	{
		SkinMICs = class'KFWeaponSkinList'.static.GetWeaponSkin(SkinId, WST_FirstPerson);
		for (i = 0; i < SkinMICs.length; i++)
		{
			ChargeMesh.SetMaterial(i, SkinMICs[i]);
		}
	}

	ChargeMIC = ChargeMesh.CreateAndSetMaterialInstanceConstant(0);
}

defaultproperties
{
	StuckToBoneIdx=INDEX_NONE

	Physics=PHYS_Falling
	MaxSpeed=1200.0
	Speed=1200.0
	TossZ=100
	GravityScale=1.0

	LifeSpan=0

	bBounce=true
	GlassShatterType=FMGS_ShatterDamaged

	ExplosionActorClass=class'KFExplosionActorC4'

	DamageRadius=0

	bCollideComplex=true

	bIgnoreFoliageTouch=true

	bBlockedByInstigator=false
	bAlwaysReplicateExplosion=true

	bNetTemporary=false

	bCanBeDamaged=true
	bCanDisintegrate=true
	Begin Object Name=CollisionCylinder
		BlockNonZeroExtent=false

		// for siren scream
		CollideActors=true
	End Object

	AlwaysRelevantDistanceSquared=6250000 // 25m, same as grenade

	AltExploEffects=none//KFImpactEffectInfo'WEP_C4_ARCH.C4_Explosion_Concussive_Force'

	// blink light
	Begin Object Class=PointLightComponent Name=BlinkPointLight
	    LightColor=(R=255,G=63,B=63,A=255)
		Brightness=4.f
		Radius=300.f
		FalloffExponent=10.f
		CastShadows=False
		CastStaticShadows=FALSE
		CastDynamicShadows=False
		bCastPerObjectShadows=false
		bEnabled=FALSE
		LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
		Translation=(X=8, Z=4)
	End Object
	BlinkLightComp=BlinkPointLight
	Components.Add(BlinkPointLight)

	// projectile mesh (use this instead of ProjEffects particle system)
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'WEP_3P_C4_MESH.Wep_C4_Projectile'
		bCastDynamicShadow=FALSE
		CollideActors=false
		LightingChannels=(bInitialized=True,Dynamic=True,Indoor=True,Outdoor=True)
	End Object
	ChargeMesh=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	// explosion light
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
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
		Damage=820
	    DamageRadius=400
		DamageFalloffExponent=2.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_EMP_E4'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
        ExplosionEffects=KFImpactEffectInfo'ZED_Matriarch_ARCH.Lightning_Storm_Explosion_Arch'
        ExplosionSound=AkEvent'WW_ZED_Matriarch.Play_Matriarch_Storm_Attack_01'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
        CamShakeInnerRadius=450
        CamShakeOuterRadius=900
        CamShakeFalloff=1.f
        bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0

	ImpactEffectInfo=KFImpactEffectInfo'WEP_C4_ARCH.C4_Projectile_Impacts'

	ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'

	ProximityAlertAkEvent=AkEvent'WW_WEP_EXP_C4.Play_WEP_EXP_C4_Prox_Beep'
	ProximityAlertInterval=1.0
	ProximityAlertIntervalClose=0.5

	BlinkTime=0.2f
	BlinkColorOff=(R=0, G=0, B=0)
	BlinkColorOn=(R=1, G=0, B=0)

	BlinkFX=ParticleSystem'WEP_C4_EMIT.FX_C4_Glow'

	bCanStick=true
	Begin Object Class=KFProjectileStickHelper Name=StickHelper0
		StickAkEvent=AkEvent'WW_WEP_EXP_C4.Play_WEP_EXP_C4_Handling_Place'
	End Object
	StickHelper=StickHelper0
}
