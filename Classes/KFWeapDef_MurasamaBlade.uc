class KFWeapDef_MurasamaBlade extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Murasama";
}

static function string GetItemCategory()
{
	return "Murasama";
}

static function string GetItemDescription()
{
    return "This is Murasama!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Murasama";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Edged_MurasamaBlade"

	BuyPrice=850 //200
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Katana"

	EffectiveRange=2

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
