class KFWeapDef_TauCannon extends KFWeaponDefinition
    abstract;

static function string GetItemName()
{
    return "Tau Cannon";
}

static function string GetItemCategory()
{
	return "Tau Cannon";
}

static function string GetItemDescription()
{
    return "This is Tau Cannon!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Tau Cannon";
}

DefaultProperties
{
    WeaponClassPath="SnWeapon.KFWeap_TauCannon"

    BuyPrice=1600//1500
    AmmoPricePerMag=125
    ImagePath="WEP_UI_HuskCannon_TEX.UI_WeaponSelect_HuskCannon"


    EffectiveRange=60

	UpgradePrice[0]=1500

    UpgradeSellPrice[0]=1125
}