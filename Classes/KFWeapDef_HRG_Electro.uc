class KFWeapDef_HRG_Electro extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Electro";
}

static function string GetItemCategory()
{
	return "HRG Electro";
}

static function string GetItemDescription()
{
    return "This is HRG Electro!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Electro";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_Electro"

	BuyPrice=550
	AmmoPricePerMag=16//21
	ImagePath="WEP_UI_HRG_SW_500_TEX.UI_WeaponSelect_HRG_SW500"

	EffectiveRange=15

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
