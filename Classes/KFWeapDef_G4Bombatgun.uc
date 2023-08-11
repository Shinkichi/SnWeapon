class KFWeapDef_G4Bombatgun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "G4 Bombat Shotgun";
}

static function string GetItemCategory()
{
	return "G4 Bombat Shotgun";
}

static function string GetItemDescription()
{
    return "This is G4 Bombat Shotgun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "G4 Bombat Shotgun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotgun_G4Bombatgun"

	BuyPrice=1200//1100
	AmmoPricePerMag=60//38 //40
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Benelli"

	EffectiveRange=35

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
