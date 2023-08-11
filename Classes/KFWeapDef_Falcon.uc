
class KFWeapDef_Falcon extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return ".357 Jungle Falcon";
}

static function string GetItemCategory()
{
	return ".357 Jungle Falcon";
}

static function string GetItemDescription()
{
    return "This is .357 Jungle Falcon!!";
}

static function string GetItemLocalization(string KeyName)
{
	return ".357 Jungle Falcon";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_Falcon"

	BuyPrice=600//550
	AmmoPricePerMag=26//21
	ImagePath="WEP_UI_Deagle_TEX.UI_WeaponSelect_Deagle"

	EffectiveRange=50

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
