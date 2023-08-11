class KFDT_Ballistic_BomberGun_Dual extends KFDT_Ballistic_BomberGun
	abstract
	hidedropdown;

defaultproperties
{
	ModifierPerkList.Empty
	ModifierPerkList(0)=class'KFPerk_Demolitionist'
	ModifierPerkList(1)=class'KFPerk_Gunslinger'
}
