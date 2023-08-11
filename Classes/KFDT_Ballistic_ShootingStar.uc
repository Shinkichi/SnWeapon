class KFDT_Ballistic_ShootingStar extends KFDT_Ballistic_Handgun
    abstract
    hidedropdown;

/** Allows the damage type to customize exactly which hit zones it can dismember */
static simulated function bool CanDismemberHitZone( name InHitZoneName )
{
    if( super.CanDismemberHitZone( InHitZoneName ) )
    {
        return true;
    }

    switch ( InHitZoneName )
    {
    case 'lupperarm':
    case 'rupperarm':
    case 'chest':
    case 'heart':
        return true;
    }

    return false;
}

defaultproperties
{
    KDamageImpulse=2000
    KDeathUpKick=-450
    KDeathVel=200

    KnockdownPower=15
    StumblePower=20
    GunHitPower=100

    WeaponDef=class'KFWeapDef_ShootingStar'

    ModifierPerkList(0)=class'KFPerk_Gunslinger'
}
