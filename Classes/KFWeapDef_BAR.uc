class KFWeapDef_BAR extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "M1918 BAR";
}

static function string GetItemCategory()
{
	return "M1918 BAR";
}

static function string GetItemDescription()
{
    return "This is M1918 BAR!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "M1918 BAR";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_BAR"

	BuyPrice=1200//1100
	AmmoPricePerMag=160//80//53//60
	ImagePath="WEP_UI_M14EBR_TEX.UI_WeaponSelect_SM14-EBR"

	EffectiveRange=90

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
