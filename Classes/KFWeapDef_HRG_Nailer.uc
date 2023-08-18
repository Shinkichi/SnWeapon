class KFWeapDef_HRG_Nailer extends KFWeaponDefinition
	abstract;


static function string GetItemName()
{
    return "HRG Nailer";
}

static function string GetItemCategory()
{
	return "HRG Nailer";
}

static function string GetItemDescription()
{
    return "This is HRG Nailer!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Nailer";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_Nailer"

	BuyPrice=1600//1500
	AmmoPricePerMag=45//36 
    ImagePath="ui_weaponselect_tex.UI_WeaponSelect_AA12"

	EffectiveRange=70

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
