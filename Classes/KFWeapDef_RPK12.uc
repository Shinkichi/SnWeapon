class KFWeapDef_RPK12 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "RPK-12 SAW";
}

static function string GetItemCategory()
{
	return "RPK-12 SAW";
}

static function string GetItemDescription()
{
    return "This is RPK-12 SAW!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "RPK-12 SAW";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_RPK12"

	BuyPrice=1200//1100
	AmmoPricePerMag=40
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_AK12"

	EffectiveRange=67

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
