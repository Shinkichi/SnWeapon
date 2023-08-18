//class KFDT_Ballistic_Shotty_Medic extends KFDT_Ballistic_Handgun
class KFDT_Ballistic_Shotty_Medic extends KFDT_Ballistic_Shotgun
	abstract
	hidedropdown;


/** Called when damage is dealt to apply additional damage type (e.g. Damage Over Time) */
static function ApplySecondaryDamage( KFPawn Victim, int DamageTaken, optional Controller InstigatedBy )
{
	local class<KFDamageType> ToxicDT;

	ToxicDT = class'KFDT_Ballistic_Assault_Medic'.static.GetMedicToxicDmgType( DamageTaken, InstigatedBy );
  	if ( ToxicDT != None )
    {
        Victim.ApplyDamageOverTime(DamageTaken, InstigatedBy, ToxicDT);
    }
}

defaultproperties
{
	KDamageImpulse=900
	KDeathUpKick=-300
	KDeathVel=100

	StumblePower=0
	GunHitPower=45

	WeaponDef=class'KFWeapDef_MedicShotty'

	//Perk
	ModifierPerkList(0)=class'KFPerk_FieldMedic'
	ModifierPerkList(1)=class'KFPerk_Support'
	ModifierPerkList(2)=class'KFPerk_Gunslinger'
}
