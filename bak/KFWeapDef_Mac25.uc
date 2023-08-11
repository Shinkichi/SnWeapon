
class KFWeapDef_Mac25 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Mac 25";
}

static function string GetItemCategory()
{
	return "Mac 25";
}

static function string GetItemDescription()
{
    return "This is Mac 25!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Mac 25";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_SMG_Mac25"

	BuyPrice=1100
	AmmoPricePerMag=32
	ImagePath="WEP_UI_MAC10_TEX.UI_WeaponSelect_Mac10"

	EffectiveRange=70

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}