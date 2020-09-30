
class KFDT_Fire_Ground_Incinerator extends KFDT_Fire_Ground
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
	WeaponDef=class'KFWeapDef_Incinerator'

	DoT_Type=DOT_Fire
	DoT_Duration=1.7 //5.0
	DoT_Interval=0.4 //1.0
	DoT_DamageScale=0.8 //1.5

	BurnPower=12 //15.5

    ModifierPerkList(0) = class'KFPerk_Firebug'
}