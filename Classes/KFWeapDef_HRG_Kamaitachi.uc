
class KFWeapDef_HRG_Kamaitachi extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Kamaitachi";
}

static function string GetItemCategory()
{
	return "HRG Kamaitachi";
}

static function string GetItemDescription()
{
    return "This is HRG Kamaitachi!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Kamaitachi";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_Kamaitachi"

	BuyPrice=1500
	AmmoPricePerMag=60 //70
	ImagePath="WEP_UI_HRG_Vampire_TEX.UI_WeaponSelect_HRG_Vampire"

	EffectiveRange=70

	UpgradePrice[0]=1500
	UpgradeSellPrice[0]=1125
}
