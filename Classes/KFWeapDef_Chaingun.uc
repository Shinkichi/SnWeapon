
class KFWeapDef_Chaingun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Chaingun";
}

static function string GetItemCategory()
{
	return "Chaingun";
}

static function string GetItemDescription()
{
    return "This is Chaingun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Chaingun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Chaingun"

	BuyPrice=1100
	AmmoPricePerMag=45
	ImagePath="wep_ui_cryogun_tex.UI_WeaponSelect_Cryogun"

	EffectiveRange=17

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}