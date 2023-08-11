
class KFWeapDef_MasterKey extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "MasterKey Shotgun";
}

static function string GetItemCategory()
{
	return "MasterKey Shotgun";
}

static function string GetItemDescription()
{
    return "MasterKey Shotgun";
}

static function string GetItemLocalization(string KeyName)
{
	return "MasterKey Shotgun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotgun_MasterKey"

	BuyPrice=650
	AmmoPricePerMag=15//30 //32
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Mossberg"

	EffectiveRange=20

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
