
class KFWeap_AssaultRifle_LaserRifle extends KFWeap_RifleBase;

/** Animation to play when the weapon is fired  in burst mode with 2 rounds left */
var(Animations) const editconst	name	BurstFire2RdAnim;
/** Animation to play when the weapon is fired in burst fire mode for 3 rounds*/
var(Animations) const editconst	name	BurstFire3RdAnim;

// Iron Sights
/** Animation to play when the weapon is fired in burst mode with 2 rounds left */
var(Animations) const editconst	name	BurstFire2RdSightedAnim;
/** Animation to play when the weapon is fired in burst fire mode for 3 rounds*/
var(Animations) const editconst	name	BurstFire3RdSightedAnim;

var int BurstAmountBegin;

simulated state WeaponBurstFiring
{
	simulated event BeginState(Name PreviousStateName)
	{
		BurstAmountBegin = GetBurstAmount();
		Super.BeginState(PreviousStateName);
	}

	simulated function name GetWeaponFireAnim(byte FireModeNum)
	{
		// only do one burst animation instead of a burst animation per shot
		// since burst amount gets reduced after each shot, this will only play the one animation based on the number of shots in the burst fire
		if (BurstAmount == BurstAmountBegin)
		{
			if (BurstAmount == 3)
			{
				if (bUsingSights)
				{
					return BurstFire3RdSightedAnim;
				}
				return BurstFire3RdAnim;
			}
			else if (BurstAmount == 2)
			{
				if (bUsingSights)
				{
					return BurstFire2RdSightedAnim;
				}
				return BurstFire2RdAnim;
			}
			else
			{
				return super.GetWeaponFireAnim(FireModeNum);
			}
		}

		// will not play any animation
		return '';
	}
}

static simulated event EFilterTypeUI GetAltTraderFilter()
{
	return FT_Electric;
}

defaultproperties
{
    // FOV
	MeshFOV=70
	MeshIronSightFOV=52
    PlayerIronSightFOV=70

	// Depth of field
	DOF_FG_FocalRadius=85
	DOF_FG_MaxNearBlurSize=2.5

	// Zooming/Position
	IronSightPosition=(X=10,Y=0,Z=0)    //x20
	PlayerViewOffset=(X=30.0,Y=10,Z=-2.5)  //x18 y9 z0

	// Content
	PackageKey="LaserRifle"
	FirstPersonMeshName="WEP_1P_Microwave_Assault_MESH.Wep_1stP_Microwave_Assault_Rig"
	FirstPersonAnimSetNames(0)="WEP_1P_Microwave_Assault_ANIM.WEP_1P_Microwave_Assault_ANIM"
	PickupMeshName="WEP_3P_Microwave_Assault_MESH.Wep_3rdP_Microwave_Assault_Pickup"
	AttachmentArchetypeName = "WEP_Microwave_Assault_ARCH.Microwave_Assault_3rdP"
	MuzzleFlashTemplateName="WEP_Microwave_Assault_ARCH.Wep_Microwave_Gun_MuzzleFlash" //@TODO: Replace

	// Ammo
	MagazineCapacity[0]=50//60//75//40
	SpareAmmoCapacity[0]=400//480//525//320
	InitialSpareMags[0]=2
	bCanBeReloaded=true
	bReloadFromMagazine=true

	// Recoil
	maxRecoilPitch=125
	minRecoilPitch=100
	maxRecoilYaw=120
	minRecoilYaw=-100
	RecoilRate=0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=65035
	RecoilISMaxYawLimit=75
	RecoilISMinYawLimit=65460
	RecoilISMaxPitchLimit=375
	RecoilISMinPitchLimit=65460
	IronSightMeshFOVCompensationScale=4.0

	// Inventory
	InventorySize=8
	GroupPriority=125
	WeaponSelectTexture=Texture2D'WEP_UI_Microwave_Assault_TEX.UI_WeaponSelect_Microwave_Assault'

	// DEFAULT_FIREMODE
	FireModeIconPaths(DEFAULT_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletAuto'
	FiringStatesArray(DEFAULT_FIREMODE)=WeaponFiring
	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(DEFAULT_FIREMODE)=class'KFProj_Bullet_LaserRifle'
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'KFDT_Ballistic_LaserRifle'
	FireInterval(DEFAULT_FIREMODE)=+0.1 // 600 RPM
	Spread(DEFAULT_FIREMODE)=0.0085
	PenetrationPower(DEFAULT_FIREMODE)=2.0
	InstantHitDamage(DEFAULT_FIREMODE)=50
	FireOffset=(X=30,Y=4.5,Z=-5)

	// ALT_FIREMODE
	FireModeIconPaths(ALTFIRE_FIREMODE)=Texture2D'ui_firemodes_tex.UI_FireModeSelect_BulletBurst'
	FiringStatesArray(ALTFIRE_FIREMODE)=WeaponBurstFiring
	WeaponFireTypes(ALTFIRE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'KFProj_Bullet_LaserRifle'
	FireInterval(ALTFIRE_FIREMODE)=+0.1 // 600 RPM
	InstantHitDamageTypes(ALTFIRE_FIREMODE)=class'KFDT_Ballistic_LaserRifle'
	PenetrationPower(ALTFIRE_FIREMODE)=2.0
	InstantHitDamage(ALTFIRE_FIREMODE)=50
	Spread(ALTFIRE_FIREMODE)=0.0085
	BurstAmount=3
	BurstFire2RdAnim=Shoot_Burst2
	BurstFire3RdAnim=Shoot_Burst
	BurstFire2RdSightedAnim=Shoot_Burst2_Iron
	BurstFire3RdSightedAnim=Shoot_Burst_Iron


	// BASH_FIREMODE
	InstantHitDamageTypes(BASH_FIREMODE)=class'KFDT_Bludgeon_LaserRifle'
	InstantHitDamage(BASH_FIREMODE)=26

	// Fire Effects
	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Helios.Play_WEP_Helios_Shoot_FullAuto_LP_3P', FirstPersonCue=AkEvent'WW_WEP_Helios.Play_WEP_Helios_Shoot_FullAuto_LP_1P') //@TODO: Replace
	WeaponFireSnd(ALTFIRE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Helios.Play_WEP_Helios_Shoot_Single_3P', FirstPersonCue=AkEvent'WW_WEP_Helios.Play_WEP_Helios_Shoot_Single_1P') //@TODO: Replace
	WeaponDryFireSnd(DEFAULT_FIREMODE)=AkEvent'WW_WEP_SA_SCAR.Play_WEP_SA_SCAR_Handling_DryFire' //@TODO: Replace
	WeaponDryFireSnd(ALTFIRE_FIREMODE)=AkEvent'WW_WEP_SA_SCAR.Play_WEP_SA_SCAR_Handling_DryFire' //@TODO: Replace

	// Advanced (High RPM) Fire Effects
	bLoopingFireAnim(DEFAULT_FIREMODE)=true
	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_Helios.Play_WEP_Helios_Shoot_FullAuto_LP_End_3P', FirstPersonCue=AkEvent'WW_WEP_Helios.Play_WEP_Helios_Shoot_FullAuto_LP_End_1P') //@TODO: Replace
	SingleFireSoundIndex=ALTFIRE_FIREMODE

	// Attachments
	bHasIronSights=true
	bHasFlashlight=false

	AssociatedPerkClasses(0)=class'KFPerk_Commando'
}
