class KFWeapDef_Shovel extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Shovel Magical Tool";
}

static function string GetItemCategory()
{
	return "Shovel Magical Tool";
}

static function string GetItemDescription()
{
    return "This is Shovel Magical Tool!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Shovel Magical Tool";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Blunt_Shovel"

	BuyPrice=300//200
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Crovel"

	EffectiveRange=3

	UpgradePrice[0]=500
	UpgradePrice[1]=600
	UpgradePrice[2]=700
	UpgradePrice[3]=1500

	UpgradeSellPrice[0]=375
	UpgradeSellPrice[1]=825
	UpgradeSellPrice[2]=1350
	UpgradeSellPrice[3]=2475
}