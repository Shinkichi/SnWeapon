
class KFDT_Toxic_WMD extends KFDT_Toxic_DemoNuke
	hidedropdown;

/** Nuke will always apply poison */
static function bool AlwaysPoisons()
{
	return true;
}

defaultproperties
{
	DoT_Type=DOT_Toxic
    bNoInstigatorDamage=true

    KnockdownPower=0
	StumblePower=0

	DoT_Duration=5 //10.0
	DoT_Interval=0.3 //1.0 //0.3
	DoT_DamageScale=1.f //0.1 //1.0

	PoisonPower=1000
	BurnPower=0
	
	ModifierPerkList.Empty
	ModifierPerkList(0)=class'KFPerk_FieldMedic'
}