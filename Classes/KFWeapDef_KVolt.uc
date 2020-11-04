class KFWeapDef_KVolt extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "K-Volt";
}

static function string GetItemCategory()
{
	return "K-Volt";
}

static function string GetItemDescription()
{
    return "This is K-Volt!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "K-Volt";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_SMG_KVolt"

	BuyPrice=1500
	AmmoPricePerMag=35 //35
	ImagePath="WEP_UI_KRISS_TEX.UI_WeaponSelect_KRISS"

	EffectiveRange=70

    UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}