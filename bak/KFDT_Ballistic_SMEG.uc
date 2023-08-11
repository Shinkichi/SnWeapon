class KFDT_Ballistic_SMEG extends KFDT_Ballistic_Rifle
    abstract
    hidedropdown;

defaultproperties
{
    KDamageImpulse=3000
    KDeathUpKick=800
    KDeathVel=500

    StumblePower=200
    GunHitPower=0

    WeaponDef=class'KFWeapDef_SMEG'
    ModifierPerkList(0)=class'KFPerk_Support'
}
