
class KFWeapDef_BFRDual extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dual Biggest Finests";
}

static function string GetItemCategory()
{
	return "Dual Biggest Finests";
}

static function string GetItemDescription()
{
    return "This is Dual Biggest Finests!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual Biggest Finests";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Revolver_DualBFR"

	BuyPrice=1600//1500
	AmmoPricePerMag=70//50
	ImagePath="WEP_UI_Dual_SW_500_TEX.UI_WeaponSelect_DualSW500"

	EffectiveRange=50

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
