class KFWeapDef_Scout extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Scout Breacher";
}

static function string GetItemCategory()
{
	return "Scout Breacher";
}

static function string GetItemDescription()
{
    return "This is Scout Breacher!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Scout Breacher";
}

defaultproperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_Scout"

	BuyPrice=1200

	AmmoPricePerMag=30//25
	SecondaryAmmoMagPrice=15 //13
	SecondaryAmmoMagSize=40//6 // Num of bullets given (not magazines)

	ImagePath="WEP_UI_Famas_TEX.UI_WeaponSelect_Famas"

	EffectiveRange=67 // @TODO: ¿?¿?¿?

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650

	//SharedUnlockId=SCU_FAMAS
}
