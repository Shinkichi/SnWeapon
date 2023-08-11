
class KFWeapDef_FalconDual extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dual .357 Jungle Falcons";
}

static function string GetItemCategory()
{
	return "Dual .357 Jungle Falcons";
}

static function string GetItemDescription()
{
    return "This is .357 Dual Jungle Falcons!!";
}

static function string GetItemLocalization(string KeyName)
{
	return ".357 Dual Jungle Falcons";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_DualFalcon"

	BuyPrice=1200//1100
	AmmoPricePerMag=52//42
	ImagePath="WEP_UI_Dual_Deagle_TEX.UI_WeaponSelect_DualDeagle"

	EffectiveRange=50

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
