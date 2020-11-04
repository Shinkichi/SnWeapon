class KFWeapAttach_KVolt extends KFWeapAttach_SprayBase;

/** When the beam started charging*/
var float StartFireTime;
/** The amount of time spent charging*/
var float ChargeTime;
/** Whether the beam is at max charge*/
var bool bIsFullyCharged;
/** Whether the beam is currently charging*/
var bool bIsCharging;

var transient ParticleSystemComponent ChargingPSC;
var ParticleSystem ChargingEffect;

/** Muzzle flash effects per level */
var const ParticleSystem MuzzleFlashEffectL1;
var const ParticleSystem MuzzleFlashEffectL2;
var const ParticleSystem MuzzleFlashEffectL3;

/** Color for the weapon center when charging/firing*/
var LinearColor DefaultFireModeColor;
var LinearColor EnergyColorL0;
var LinearColor EnergyColorL1;
var LinearColor EnergyColorL2;
var LinearColor EnergyColorL3;

/** Extra materials on the laser cutter*/
var int WeaponMaterialCount;
var array<MaterialInstanceConstant>	WeaponMICs;

/** Names of the charging/firing animations specific to the laser cutter*/
const WeaponChargeAnim = 'Charge_Beam';
const WeaponBeamAnim = 'Shoot_Beam';

const PawnChargeAnim		= 'ADD_Charge_Beam';
const PawnChargeAnimCrouch  = 'ADD_CH_Charge_Beam';
const PawnChargeAnimIron	= 'ADD_Iron_Charge_Beam';
const PawnBeamAnim			= 'ADD_Shoot_Beam';
const PawnBeamAnimCrouch	= 'ADD_CH_Shoot_Beam';
const PawnBeamAnimIron		= 'ADD_Iron_Shoot_Beam';

/** Used to gate the beam firing muzzle flash to only play once after the beam starts */
var bool bPlayMuzzleFlash;

simulated function PlayWeaponFireAnim()
{
	local float Duration;

	if (bIsCharging) // charging the lazer
	{
		Duration = WeapMesh.GetAnimLength(WeaponChargeAnim);
		WeapMesh.PlayAnim(WeaponChargeAnim, Duration / ThirdPersonAnimRate, true, false);
	}
	else if (Instigator.FiringMode == 6) // firing the lazer
	{
		Duration = WeapMesh.GetAnimLength(WeaponBeamAnim);
		WeapMesh.PlayAnim(WeaponBeamAnim, Duration / ThirdPersonAnimRate, , false);
	}
	else
	{
		super.PlayWeaponFireAnim();
	}
}

/** Plays fire animation on pawn */
simulated function PlayPawnFireAnim(KFPawn P, EAnimSlotStance AnimType)
{
	if (bIsCharging) // charging the lazer
	{
		if (P.bIsCrouched)
		{
			P.PlayBodyAnim(PawnChargeAnimCrouch, AnimType, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime, true,false);
		}
		else if (P.bIsWalking)
		{
			P.PlayBodyAnim(PawnChargeAnimIron, AnimType, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime, true, false);
		}
		else
		{
			P.PlayBodyAnim(PawnChargeAnim, AnimType, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime, true, false);
		}
	}
	else if (Instigator.FiringMode == 6) // firing the lazer
	{
		if (P.bIsCrouched)
		{
			P.PlayBodyAnim(PawnBeamAnimCrouch, AnimType, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime,, false);
		}
		else if (P.bIsWalking)
		{
			P.PlayBodyAnim(PawnBeamAnimIron, AnimType, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime,, false);
		}
		else
		{
			P.PlayBodyAnim(PawnBeamAnim, AnimType, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime,, false);
		}
	}
	else
	{
		super.PlayPawnFireAnim(P, AnimType);
	}
}

simulated function StartFire()
{
	StartFireTime = WorldInfo.TimeSeconds;
	ChargeTime = 0.0f;

	// start the beam charging
	bIsFullyCharged = false;
	bIsCharging = true;

	// setup and play the beam charge particle system
	if (ChargingPSC == none)
	{
		ChargingPSC = new(self) class'ParticleSystemComponent';

		if (WeapMesh != none)
		{
			WeapMesh.AttachComponentToSocket(ChargingPSC, 'MuzzleFlash');
		}
		else
		{
			AttachComponent(ChargingPSC);
		}
	}
	else
	{
		ChargingPSC.ActivateSystem();
	}

	if (ChargingPSC != none)
	{
		ChargingPSC.SetTemplate(ChargingEffect);
	}
}

/** Spawn tracer effects for this weapon */
simulated function SpawnTracer(vector EffectLocation, vector HitLocation)
{
	local ParticleSystemComponent E;
	local vector Dir;
	local float DistSQ;
	local float TracerDuration;
	local KFTracerInfo TracerInfo;

	if ( Instigator == None || Instigator.FiringMode >= TracerInfos.Length )
	{
		return;
	}

	// only show tracers for the full auto mode (not the laser charge/firing)
	if (Instigator.FiringMode != 0)
	{
		return;
	}

	// since the tracers only happen in full-auto mode, make sure this isn't set to charging
	bIsCharging = false;
	ChargeTime = 0.0f;

	TracerInfo = TracerInfos[Instigator.FiringMode];
    if( ((`NotInZedTime(self) && TracerInfo.bDoTracerDuringNormalTime)
        || (`IsInZedTime(self) && TracerInfo.bDoTracerDuringZedTime))
        && TracerInfo.TracerTemplate != none )
    {
        Dir = HitLocation - EffectLocation;
		DistSQ = VSizeSq(Dir);
    	if ( DistSQ > TracerInfo.MinTracerEffectDistanceSquared )
    	{
    		// Lifetime scales based on the distance from the impact point. Subtract a frame so it doesn't clip.
			TracerDuration = fMin( (Sqrt(DistSQ) - 100.f) / TracerInfo.TracerVelocity, 1.f );
			if( TracerDuration > 0.f )
			{
	    		E = WorldInfo.MyEmitterPool.SpawnEmitter( TracerInfo.TracerTemplate, EffectLocation, rotator(Dir) );
				E.SetVectorParameter('Shotend', HitLocation);
	 			E.SetFloatParameter( 'Tracer_Lifetime', TracerDuration );
	 		}
    	}
	}
}

simulated function SetBeamColor(int ChargeLevel)
{
	local LinearColor BeamColor;
	local int i;

	// create the reset of the weapon material instances if they don't already exist
	if (WeaponMICs.Length == 0)
	{
		for (i = 1; i < WeaponMaterialCount; i++)
		{
			WeaponMICs.AddItem(WeapMesh.CreateAndSetMaterialInstanceConstant(i));
		}
	}

	// always the default firemode color if in that state
	if (Instigator.FiringMode == 0)
	{
		BeamColor = DefaultFireModeColor;
	}
	else
	{
		switch (ChargeLevel)
		{
		case 3:
			BeamColor = EnergyColorL3;
			break;
		case 2:
			BeamColor = EnergyColorL2;
			break;
		case 1:
			BeamColor = EnergyColorL1;
			break;
		default:
			BeamColor = EnergyColorL0;
			break;
		}
	}
	// set the beam color based on the charge level
	WeaponMIC.SetVectorParameterValue('Energy_Color', BeamColor);
	for (i = 0; i < WeaponMICs.Length; i++)
	{
		WeaponMICs[i].SetVectorParameterValue('Energy_Color', BeamColor);
	}
}

simulated event Tick(float DeltaTime)
{
	// if the beam is charging, reset the charge time
	if (bIsCharging && !bIsFullyCharged)
	{
		ChargeTime = WorldInfo.TimeSeconds - StartFireTime;
	}

	// if the beam has just reached max charge level
	if (bIsCharging && !bIsFullyCharged && GetChargeFXLevel() == class'KFWeap_AssaultRifle_LazerCutter'.default.MaxChargeLevel)
	{
		bIsFullyCharged = true;
	}

	if (bIsCharging)
	{
		SetBeamColor(GetChargeFXLevel());
	}
	// the default firemode now has a separate color
	else if (Instigator.FiringMode == 0)
	{
		SetBeamColor(0);
	}

	Super.Tick(DeltaTime);
}

simulated function bool ThirdPersonFireEffects(vector HitLocation, KFPawn P, byte ThirdPersonAnimRateByte)
{
	local bool bResult;

	// Overriding the KFWeapAttach_SprayBase portion of this function, so call the base Super directly
	bResult = Super(KFWeaponAttachment).ThirdPersonFireEffects(HitLocation, P, ThirdPersonAnimRateByte);

	// Lazer fire mode turns on the spray
	// CUSTOM_FIREMODE == 6
	if (P.FiringMode == 6 && P.ActorEffectIsRelevant(P, false, 15000, 2000))
	{
		if (!bFireSpraying)
		{
			// play the muzzle flash on the first flash
			bPlayMuzzleFlash = true;
		}

		// turn off the charging effect
		if (ChargingPSC != none)
		{
			ChargingPSC.DeactivateSystem();
		}

		TurnOnFireSpray();

		// no longer charging now that it's firing the beam
		bIsCharging = false;
		bResult = true;
	}

	return bResult;
}

// stop looping weapon anim states or longer animations trying to play out their duration
simulated function ResetAnimationState()
{
	local KFPawn P;

	P = KFPawn(Instigator);
	if (P != None)
	{
		P.StopBodyAnim(EAS_FullBody, 0.1f);
	}

	InterruptWeaponAnim();
}

simulated function StopThirdPersonFireEffects(optional bool bForce)
{
	if (bFireSpraying)
	{
		ResetAnimationState();
	}

	// beam is over, return to default color
	SetBeamColor(0);

	Super.StopThirdPersonFireEffects(bForce);
}

simulated function FirstPersonFireEffects(Weapon W, vector HitLocation)
{
	super.FirstPersonFireEffects(W, HitLocation);

	if (Instigator.FiringMode == 6)
	{
		bIsCharging = false;
	}

	if (ChargingPSC != none)
	{
		ChargingPSC.DeactivateSystem();
	}
}

simulated function CauseMuzzleFlash(byte FiringMode)
{
	// ALTFIRE_FIREMODE == 1, used for the charging state
	if (FiringMode != 1)
	{
		// if firing the charge mode, set the muzzle flash based on the charge level
		if (FiringMode == 6)
		{
			if (MuzzleFlash == None && MuzzleFlashTemplate != None)
			{
				AttachMuzzleFlash();
			}

			if (bPlayMuzzleFlash)
			{
				switch (GetChargeFXLevel())
				{
				case 0:
				case 1:
					MuzzleFlash.MuzzleFlash.ParticleSystemTemplate = MuzzleFlashEffectL1;
					MuzzleFlash.MuzzleFlash.PSC.SetTemplate(MuzzleFlashEffectL1);
					break;
				case 2:
					MuzzleFlash.MuzzleFlash.ParticleSystemTemplate = MuzzleFlashEffectL2;
					MuzzleFlash.MuzzleFlash.PSC.SetTemplate(MuzzleFlashEffectL2);
					break;
				case 3:
					MuzzleFlash.MuzzleFlash.ParticleSystemTemplate = MuzzleFlashEffectL3;
					MuzzleFlash.MuzzleFlash.PSC.SetTemplate(MuzzleFlashEffectL3);
					break;
				}

				bPlayMuzzleFlash = false;
				// setting to 0 so that the muzzle flash doesn't get turned off based on a timer
				MuzzleFlash.MuzzleFlash.Duration = 0.0f;
				super.CauseMuzzleFlash(FiringMode);
			}
		}
		// otherwise use the default
		else
		{
			MuzzleFlash.MuzzleFlash.ParticleSystemTemplate = MuzzleFlashTemplate.MuzzleFlash.ParticleSystemTemplate;
			MuzzleFlash.MuzzleFlash.PSC.SetTemplate(MuzzleFlashTemplate.MuzzleFlash.ParticleSystemTemplate);
			MuzzleFlash.MuzzleFlash.Duration = MuzzleFlashTemplate.MuzzleFlash.Duration;
			super.CauseMuzzleFlash(FiringMode);
		}
	}
}

function int GetChargeFXLevel()
{
	return Min(ChargeTime / class'KFWeap_AssaultRifle_LazerCutter'.default.ChargeTimePerLevel, class'KFWeap_AssaultRifle_LazerCutter'.default.MaxChargeLevel);
}

defaultproperties
{
	PilotLightPlayEvent=AkEvent'WW_WEP_Lazer_Cutter.Play_WEP_LazerCutter_Idle_LP'
	PilotLightStopEvent=AkEvent'WW_WEP_Lazer_Cutter.Stop_WEP_LazerCutter_Idle_LP'

	MuzzleFlashEffectL1=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Cutter_Beam_Muzzleflash_01'
	MuzzleFlashEffectL2=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Cutter_Beam_Muzzleflash_02'
	MuzzleFlashEffectL3=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Cutter_Beam_Muzzleflash_03'
	ChargingEffect=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Cutter_Beam_Charge_00'

	DefaultFireModeColor=(R=5.f,G=1.f,B=20.f)
	EnergyColorL0=(R=5.f,G=1.f,B=20.f)
	EnergyColorL1=(R=20.f,G=5.f,B=200.f)
	EnergyColorL2=(R=5.f,G=25.f,B=200.f)
	EnergyColorL3=(R=20.f,G=50.f,B=200.f)

	WeaponMaterialCount=5;
}
