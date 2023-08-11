class KFDT_Fire_HRGInfantryLifleDoT extends KFDT_Fire
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
	WeaponDef=class'KFWeapDef_HRGInfantryLifle'

	DoT_Type=DOT_Fire
	DoT_Duration=3.0 //2.0 //5.0 //1.0
	DoT_Interval=0.5
	DoT_DamageScale=0.12 //0.25 //1.0

	BurnPower=8 //1.0 //18.5
}

