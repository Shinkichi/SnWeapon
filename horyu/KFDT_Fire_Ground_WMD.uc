class KFDT_Fire_Ground_WMD extends KFDT_Fire_Ground
	abstract;

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
	WeaponDef=class'KFWeapDef_WMD'

	DoT_Type=DOT_Fire
	DoT_Duration=2.0 //5.0 //1.0
	DoT_Interval=0.5
	DoT_DamageScale=0.2 //0.5 //1.0

	BurnPower=8 //10 //1.0 //18.5
}

