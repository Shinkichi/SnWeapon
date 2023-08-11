class KFWeapAttach_TauCannon extends KFWeaponAttachment;

var transient ParticleSystemComponent ChargingPSC;
var ParticleSystem ChargingEffect;
var ParticleSystem ChargedEffect;
var bool bIsCharging;
var bool bIsFullyCharged;

var float StartFireTime;

var int ChargeLevel;

var const ParticleSystem MuzzleFlashEffectL1;
var const ParticleSystem MuzzleFlashEffectL2;
var const ParticleSystem MuzzleFlashEffectL3;

simulated function StartFire()
{
	StartFireTime = WorldInfo.TimeSeconds;
	bIsCharging = true;

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

simulated event Tick(float DeltaTime)
{
	local float ChargeRTPC;

	if(bIsCharging && !bIsFullyCharged)
	{
		ChargeRTPC = FMin(class'KFWeap_TauCannon'.default.MaxChargeTime, WorldInfo.TimeSeconds - StartFireTime) / class'KFWeap_TauCannon'.default.MaxChargeTime;

		if (ChargeRTPC >= 1.f)
		{
			bIsFullyCharged = true;
			ChargingPSC.SetTemplate(ChargedEffect);
		}
	}

	Super.Tick(DeltaTime);
}

simulated function FirstPersonFireEffects(Weapon W, vector HitLocation)
{
	super.FirstPersonFireEffects(W, HitLocation);

	if (ChargingPSC != none)
	{
		ChargingPSC.DeactivateSystem();
	}
}

simulated function bool ThirdPersonFireEffects(vector HitLocation, KFPawn P, byte ThirdPersonAnimRateByte)
{
	bIsCharging = false;
	bIsFullyCharged = false;

	ChargeLevel = GetChargeFXLevel();

	if (ChargingPSC != none)
	{
		ChargingPSC.DeactivateSystem();
	}

	return Super.ThirdPersonFireEffects(HitLocation, P, ThirdPersonAnimRateByte);
}

simulated function CauseMuzzleFlash(byte FiringMode)
{
	if (MuzzleFlash == None && MuzzleFlashTemplate != None)
	{
		AttachMuzzleFlash();
	}

	switch (ChargeLevel)
	{
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

	Super.CauseMuzzleFlash(FiringMode);
}

// Should generally match up with KFWeap_TauCannon::GetChargeFXLevel
function int GetChargeFXLevel()
{
	local int MaxCharges;
	local int Charges;

	MaxCharges = int(class'KFWeap_TauCannon'.default.MaxChargeTime / class'KFWeap_TauCannon'.default.ValueIncreaseTime);
	Charges = Min((WorldInfo.TimeSeconds - StartFireTime) / class'KFWeap_TauCannon'.default.ValueIncreaseTime, MaxCharges);

	if (Charges <= 1)
	{
		return 1;
	}
	else if (Charges < MaxCharges)
	{
		return 2;
	}
	else
	{
		return 3;
	}
}

defaultproperties
{
	MuzzleFlashTemplate=KFMuzzleFlash'WEP_HRG_Energy_ARCH.Wep_HRG_Energy_MuzzleFlash_3P'

	MuzzleFlashEffectL1=ParticleSystem'WEP_HRG_Energy_EMIT.FX_MuzzleFlash'
	MuzzleFlashEffectL2=ParticleSystem'WEP_HRG_Energy_EMIT.FX_MuzzleFlash'
	MuzzleFlashEffectL3=ParticleSystem'WEP_HRG_Energy_EMIT.FX_MuzzleFlash'

	ChargingEffect=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Cutter_Beam_Muzzleflash_01'
	ChargedEffect=ParticleSystem'WEP_Laser_Cutter_EMIT.FX_Laser_Cutter_Beam_Muzzleflash_03'
}
