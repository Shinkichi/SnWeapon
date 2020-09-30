class KFWeapDef_Incinerator extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Incinerator";
}

static function string GetItemCategory()
{
	return "Incinerator";
}

static function string GetItemDescription()
{
    return "This is Incinerator!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Incinerator";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Flame_Incinerator"

	BuyPrice=1200 //1100
	AmmoPricePerMag=83
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Flamethrower"

	EffectiveRange=17

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
