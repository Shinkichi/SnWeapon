class KFWeapDef_Impaler extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Impaler Carbine";
}

static function string GetItemCategory()
{
	return "Impaler Carbine";
}

static function string GetItemDescription()
{
    return "This is Impaler Carbine!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Impaler Carbine";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_GrenadeLauncher_Impaler"

	BuyPrice=650
	AmmoPricePerMag=13
	ImagePath="WEP_UI_M79_TEX.UI_WeaponSelect_M79"

	EffectiveRange=100

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
