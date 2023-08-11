
class KFWeapDef_Henry1860 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Henry 1860";
}

static function string GetItemCategory()
{
	return "Henry 1860";
}

static function string GetItemDescription()
{
    return "This is Henry 1860!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Henry 1860";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_Henry1860"

	BuyPrice=300//200
	AmmoPricePerMag=32 //30
	ImagePath="wep_ui_winchester_tex.UI_WeaponSelect_Winchester"

	EffectiveRange=70

	UpgradePrice[0]=500
	UpgradePrice[1]=600
	UpgradePrice[2]=700
	UpgradePrice[3]=1500

	UpgradeSellPrice[0]=375
	UpgradeSellPrice[1]=825
	UpgradeSellPrice[2]=1350
	UpgradeSellPrice[3]=2475
}
