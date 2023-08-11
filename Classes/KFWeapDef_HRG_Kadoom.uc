
class KFWeapDef_HRG_Kadoom extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Kadoomstick";
}

static function string GetItemCategory()
{
	return "HRG Kadoomstick";
}

static function string GetItemDescription()
{
    return "This is HRG Kadoomstick!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Kadoomstick";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_Kadoom"

	BuyPrice=1600//1400
	AmmoPricePerMag=46//25
	ImagePath="WEP_UI_HRG_MegaDragonsbreath_TEX.UI_WeaponSelect_HRG_MegaDragonsbreath"

	EffectiveRange=25

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
