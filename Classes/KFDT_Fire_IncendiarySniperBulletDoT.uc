class KFDT_Fire_IncendiarySniperBulletDoT extends KFDT_Fire
	abstract
	hidedropdown;

static function int GetKillerDialogID()
{
	return 86;//KILL_Fire
}

static function int GetDamagerDialogID()
{
	return 102;//DAMZ_Fire
}

static function int GetDamageeDialogID()
{
	return 116;//DAMP_Fire
}

defaultproperties
{
	WeaponDef = class'KFWeapDef_IncendiarySniper'

	DoT_Type = DOT_Fire
	DoT_Duration = 2.0
	DoT_Interval = 0.5
	DoT_DamageScale = 0.3

	BurnPower = 8
}