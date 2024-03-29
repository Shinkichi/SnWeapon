class KFWeapDef_HX63A extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Grenadier 63A GMG";
}

static function string GetItemCategory()
{
	return "Grenadier 63A GMG";
}

static function string GetItemDescription()
{
    return "This is Grenadier 63A GMG!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Grenadier 63A GMG";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_LMG_HX63A"

	BuyPrice=1600//1500
	AmmoPricePerMag=70 //70
	ImagePath="wep_ui_stoner63a_tex.UI_WeaponSelect_Stoner"

	EffectiveRange=68

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}