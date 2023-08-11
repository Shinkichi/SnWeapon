class KFWeapDef_WMD extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "W.M.D.";
}

static function string GetItemCategory()
{
	return "W.M.D.";
}

static function string GetItemDescription()
{
    return "This is W.M.D.!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "W.M.D.";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_RocketLauncher_WMD"

	BuyPrice=2500//1500
	AmmoPricePerMag=30
	ImagePath="WEP_UI_RPG7_TEX.UI_WeaponSelect_RPG7"

	EffectiveRange=100
}
