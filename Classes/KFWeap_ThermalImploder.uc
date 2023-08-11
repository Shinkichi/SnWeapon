class KFWeap_ThermalImploder extends KFWeapon;
`define GRAVITYIMPLODER_MIC_LED_INDEX 1

/** Weapons material colors for each fire mode. */
var LinearColor DefaultFireMaterialColor;
var LinearColor AltFireMaterialColor;

var bool bLastFireWasAlt;

var const bool bDebugDrawVortex;

/** Returns trader filter index based on weapon type */
static simulated event EFilterTypeUI GetTraderFilter()
{
	return FT_Flame;
}

simulated function Activate()
{
	super.Activate();
	UpdateMaterial();
}

simulated function UpdateMaterial()
{
	local LinearColor MatColor;
	MatColor = bLastFireWasAlt ? AltFireMaterialColor : DefaultFireMaterialColor;

	if( WeaponMICs.Length > `GRAVITYIMPLODER_MIC_LED_INDEX )
	{
		WeaponMICs[`GRAVITYIMPLODER_MIC_LED_INDEX].SetVectorParameterValue('Vector_Center_Color_A', MatColor);
	}
}

simulated function Projectile ProjectileFire()
{
	UpdateMaterial();
	return super.ProjectileFire();
}

simulated function BeginFire( Byte FireModeNum )
{
	super.BeginFire(FireModeNum);

	if(FireModeNum == ALTFIRE_FIREMODE && !bLastFireWasAlt)
	{
		bLastFireWasAlt=true;
	}
	else if (FireModeNum == DEFAULT_FIREMODE && bLastFireWasAlt)
	{
		bLastFireWasAlt=false;
	}
}

simulated function AltFireMode()
{
	StartFire(ALTFIRE_FIREMODE);
}

defaultproperties
{
	// Content
	PackageKey="Thermal_Imploder"
	FirstPersonMeshName="WEP_1P_Gravity_Imploder_MESH.Wep_1stP_Gravity_Imploder_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Gravity_Imploder_ANIM.Wep_1stP_Gravity_Imploder_Anim"
	PickupMeshName="WEP_3P_Gravity_Imploder_MESH.WEP_3rdP_Gravity_Imploder_Pickup" 
	AttachmentArchetypeName="WEP_Gravity_Imploder_ARCH.Wep_Gravity_Imploder_3P"
	MuzzleFlashTemplateName="WEP_Gravity_Imploder_ARCH.Wep_Gravity_Imploder_MuzzleFlash"

	// Inventory / Grouping
	InventorySize=7//8 //7
	GroupPriority=75//125 //75
	WeaponSelectTexture=Texture2D'WEP_UI_Gravity_Imploder_TEX.UI_WeaponSelect_Gravity_Imploder'
   	AssociatedPerkClasses(0)=class'KFPerk_Firebug'

    // FOV
    MeshFOV=75
	MeshIronSightFOV=40
    PlayerIronSightFOV=65

	// Depth of field
	DOF_FG_FocalRadius=50
	DOF_FG_MaxNearBlurSize=3.5

	// Ammo
	MagazineCapacity[0]=6 //5
	SpareAmmoCapacity[0]=48//42 //35
	InitialSpareMags[0]=2 //4
	AmmoPickupScale[0]=1 //1
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Zooming/Position
	PlayerViewOffset=(X=5.5,Y=8,Z=-2) //(X=11.0,Y=8,Z=-2)
	IronSightPosition=(X=10,Y=0,Z=-1.9) //(X=10,Y=0,Z=0)

	// AI warning system
	bWarnAIWhenAiming=true
	AimWarningDelay=(X=0.4f, Y=0.8f)
	AimWarningCooldown=0.0f

	// Recoil
	maxRecoilPitch=750 //500
	minRecoilPitch=675//400
	maxRecoilYaw=250 //150
	minRecoilYaw=-250 //-150
	RecoilRate=0.08
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1250
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=50
	RecoilISMinYawLimit=65485
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65485
	RecoilViewRotationScale=0.6
	IronSightMeshFOVCompensationScale=1.5

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Grenade_ThermalImploder'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_ThermalImploderImpact'
	InstantHitDamage(DEFAULT_FIREMODE)=333	//370 //185 //210 //250.0
	FireInterval(DEFAULT_FIREMODE)=1.33 //45 RPM
	Spread(DEFAULT_FIREMODE)=0.02 //0
	PenetrationPower(DEFAULT_FIREMODE)=0
	FireOffset=(X=25,Y=3.0,Z=-2.5)

	// ALTFIRE_FIREMODE (swap fire mode)
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletSingle'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Grenade_ThermalImploderAlt'
	FireInterval(ALTFIRE_FIREMODE)=1.33 //45 RPM
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_ThermalImploderImpactAlt'
	InstantHitDamage(ALTFIRE_FIREMODE)=70 //80.0//50.0
	Spread(ALTFIRE_FIREMODE)=0.02 //0.0085
	AmmoCost(ALTFIRE_FIREMODE)=1

	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_ThermalImploder'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_Fire_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_Fire_1P')
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_Gravity_Imploder.Play_WEP_Gravity_Imploder_Dry_Fire'
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_AltFire_3P', FirstPersonCue=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_AltFire_1P')
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_Gravity_Imploder.Play_WEP_Gravity_Imploder_Dry_Fire'
	EjectedShellForegroundDuration=1.5f

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	WeaponFireWaveForm=ForceFeedbackWaveform'FX_ForceFeedback_ARCH.Gunfire.Medium_Recoil'
    
	bLastFireWasAlt=false
	DefaultFireMaterialColor	= (R = 0.965f,G = 0.2972f, B = 0.0f)
	AltFireMaterialColor		= (R = 0.0f,  G = 0.9631f, B = 0.96581f)
	
	bHasFireLastAnims=true

	NumBloodMapMaterials=2
}
