
class KFWeapDef_Flechette extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "MB 500 Flechette-Shotgun";
}

static function string GetItemCategory()
{
	return "MB 500 Flechette-Shotgun";
}

static function string GetItemDescription()
{
    return "This is MB 500 Flechette-Shotgun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "MB 500 Flechette-Shotgun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotgun_Flechette"

	BuyPrice=300
	AmmoPricePerMag=30 //32
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Mossberg"

	EffectiveRange=20

	UpgradePrice[0]=500
	UpgradePrice[1]=600
	UpgradePrice[2]=700
	UpgradePrice[3]=1500

	UpgradeSellPrice[0]=375
	UpgradeSellPrice[1]=825
	UpgradeSellPrice[2]=1350
	UpgradeSellPrice[3]=2475
}
