class KFWeapDef_LightningBore extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Lightning Bore";
}

static function string GetItemCategory()
{
	return "Lightning Bore";
}

static function string GetItemDescription()
{
    return "This is Lightning Bore!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Lightning Bore";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_RocketLauncher_LightningBore"

	BuyPrice=1500
	AmmoPricePerMag=78
	ImagePath="WEP_UI_Thermite_TEX.UI_WeaponSelect_Thermite"

	EffectiveRange=78

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125

	//SharedUnlockId=SCU_Thermite
}
