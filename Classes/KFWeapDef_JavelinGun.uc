class KFWeapDef_JavelinGun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "JavelinGun";
}

static function string GetItemCategory()
{
	return "JavelinGun";
}

static function string GetItemDescription()
{
    return "This is JavelinGun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "JavelinGun";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_JavelinGun"

	BuyPrice=1100
	AmmoPricePerMag=75
	ImagePath="WEP_UI_Seal_Squeal_TEX.UI_WeaponSelect_SealSqueal"

	EffectiveRange=70

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
