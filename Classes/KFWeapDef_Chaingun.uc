
class KFWeapDef_Chaingun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Chaingunnner";
}

static function string GetItemCategory()
{
	return "Chaingunnner";
}

static function string GetItemDescription()
{
    return "This is Chaingunnner!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Chaingunnner";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Chaingun"

	BuyPrice=1200//1100
	AmmoPricePerMag=100//45
	ImagePath="wep_ui_cryogun_tex.UI_WeaponSelect_Cryogun"

	EffectiveRange=17

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}