class KFWeapDef_HRGVitaminDual extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dual HRG Vitamins";
}

static function string GetItemCategory()
{
	return "Dual HRG Vitamins";
}

static function string GetItemDescription()
{
    return "This is Dual HRG Vitamins!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual HRG Vitamins";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_DualHRGVitamin"

	BuyPrice=650
	AmmoPricePerMag=52//26 //24
	ImagePath="WEP_UI_Dual_Winterbite_Item_TEX.UI_WeaponSelect_HRG_DualWinterbite"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
