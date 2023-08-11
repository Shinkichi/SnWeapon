class KFDT_Frag12Dot extends KFDT_Fire
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
	WeaponDef=class'KFWeapDef_Frag12'


	DoT_Type=DOT_Fire
	DoT_Duration=2.5 //5.0 //1.7
	DoT_Interval=0.5 //1.0 //0.4
	DoT_DamageScale=0.1 //1.5
	bNoInstigatorDamage=true

	BurnPower=15.5 //2.5

    ModifierPerkList(0)=class'KFPerk_Demolitionist'
	ModifierPerkList(1) = class'KFPerk_Firebug'
}