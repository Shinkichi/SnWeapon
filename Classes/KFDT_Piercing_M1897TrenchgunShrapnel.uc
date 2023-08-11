class KFDT_Piercing_M1897TrenchgunShrapnel extends KFDT_Piercing
    abstract
    hidedropdown;

defaultproperties
{
    KDamageImpulse=2000
    KDeathUpKick=-500
    KDeathVel=500

    GunHitPower=300

    WeaponDef=class'KFWeapDef_M1897Trenchgun'

    ModifierPerkList(0)=class'KFPerk_Support'
}
