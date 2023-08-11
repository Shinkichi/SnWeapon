class KFDT_Bleeding_HRG_Kamaitachi extends KFDT_Bleeding
	abstract
	hidedropdown;

defaultproperties
{
	//physics
	KDamageImpulse=0
	KDeathUpKick=350
	KDeathVel=350

    //Afflictions
    BleedPower=50 //50
	StumblePower=0 //20
	GunHitPower=5

    //Damage Over Time Components
	DoT_Type=DOT_Bleeding
	DoT_Duration=0.5 //5.0
    DoT_Interval=0.5 //1.0
    DoT_DamageScale=0.1
	bStackDoT=true
}