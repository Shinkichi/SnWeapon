class KFWeapDef_JavelinGun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Monodon Snitch";
}

static function string GetItemCategory()
{
	return "Monodon Snitch";
}

static function string GetItemDescription()
{
    return "This is Monodon Snitch!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Monodon Snitch";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_JavelinGun"

	BuyPrice=1300//1100
	AmmoPricePerMag=110//55//75
	ImagePath="WEP_UI_Seal_Squeal_TEX.UI_WeaponSelect_SealSqueal"

	EffectiveRange=70

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
