class KFWeapDef_HRG_WhaleGun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Whale Squirt";
}

static function string GetItemCategory()
{
	return "HRG Whale Squirt";
}

static function string GetItemDescription()
{
    return "This is HRG Whale Squirt!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Whale Squirt";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_WhaleGun"

	BuyPrice=1200//1100
	AmmoPricePerMag=65 //75
	ImagePath="WEP_UI_HRG_SonicGun_TEX.UI_WeaponSelect_HRG_SonicGun"

	EffectiveRange=70

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
