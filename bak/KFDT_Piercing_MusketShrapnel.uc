class KFDT_Piercing_MusketShrapnel extends KFDT_Piercing
    abstract
    hidedropdown;

defaultproperties
{
    KDamageImpulse=2000
    KDeathUpKick=-500
    KDeathVel=500

    GunHitPower=300

    WeaponDef=class'KFWeapDef_Musket'

    ModifierPerkList(0)=class'KFPerk_Sharpshooter'
    ModifierPerkList(1)=class'KFPerk_Gunslinger'
}
