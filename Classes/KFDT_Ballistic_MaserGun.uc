//class KFDT_Ballistic_MaserGun extends KFDT_Ballistic_Rifle
class KFDT_Ballistic_MaserGun extends KFDT_Microwave
	abstract
	hidedropdown;

/** Allows the damage type to map a hit zone to a different bone for dismemberment purposes. */
static simulated function GetBoneToDismember(KFPawn_Monster InPawn, vector HitDirection, name InHitZoneName, out name OutBoneName)
{
	local KFCharacterInfo_Monster MonsterInfo;

	MonsterInfo = InPawn.GetCharacterMonsterInfo();
    if ( MonsterInfo != none )
	{
		// Randomly pick the left or right shoulder to dismember
		if( InHitZoneName == 'chest')
		{
			OutBoneName = Rand(2) == 0 ? MonsterInfo.SpecialMeleeDismemberment.LeftShoulderBoneName : MonsterInfo.SpecialMeleeDismemberment.RightShoulderBoneName;
		}
	}
}

/** Allows the damage type to customize exactly which hit zones it can dismember */
static simulated function bool CanDismemberHitZone( name InHitZoneName )
{
    switch ( InHitZoneName )
	{
		case 'lupperarm':
		case 'rupperarm':
		case 'chest':
		case 'heart':
	 		return true;
	}

	return false;
}

defaultproperties
{
	EffectGroup=FXG_MicrowaveBlast
	//bCanObliterate=true
	ObliterationHealthThreshold=-500
	ObliterationDamageThreshold=500
	bCanObliterate=true
	bCanGib=true
	GoreDamageGroup=DGT_Obliteration

	KDamageImpulse=4500
	KDeathUpKick=500
	KDeathVel=350

	StumblePower=400
	GunHitPower=300
	MeleeHitPower=100

	BurnPower = 100//10
	MicrowavePower = 300//30

	WeaponDef=class'KFWeapDef_MaserGun'
	ModifierPerkList(0)=class'KFPerk_Firebug'
}
