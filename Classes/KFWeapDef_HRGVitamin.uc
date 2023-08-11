class KFWeapDef_HRGVitamin extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Vitamin";
}

static function string GetItemCategory()
{
	return "HRG Vitamin";
}

static function string GetItemDescription()
{
    return "This is HRG Vitamin!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Vitamin";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_HRGVitamin"

	BuyPrice=325
	AmmoPricePerMag=26//13 //12
	ImagePath="WEP_UI_HRG_Winterbite_Item_TEX.UI_WeaponSelect_HRG_Winterbite"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
