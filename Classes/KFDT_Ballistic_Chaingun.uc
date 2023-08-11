class KFDT_Ballistic_Chaingun extends KFDT_Ballistic_Shotgun
	abstract;

defaultproperties
{
	KDamageImpulse=500
	GibImpulseScale=0.85
	KDeathUpKick=50
	KDeathVel=75

	WeaponDef=class'KFWeapDef_Chaingun'
	
	//Perk
	ModifierPerkList.Empty()
	ModifierPerkList(0)=class'KFPerk_Commando'
	ModifierPerkList(1)=class'KFPerk_Support'
	ModifierPerkList(2)=class'KFPerk_SWAT'
}