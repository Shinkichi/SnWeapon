// Frag12 Auto Shotgun - By Shinkichi 2020
class KFWeapDef_Frag12 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Frag12 Auto Shotgun";
}

static function string GetItemCategory()
{
	return "Frag12 Auto Shotgun";
}

static function string GetItemDescription()
{
    return "This is Frag-12 Auto Shotgun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Frag12 Auto Shotgun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotgun_Frag12"

	BuyPrice=2500//1500
	AmmoPricePerMag=82 //110 //82
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_AA12"

	EffectiveRange=30

	//UpgradePrice[0]=1500

	//UpgradeSellPrice[0]=1125
}
