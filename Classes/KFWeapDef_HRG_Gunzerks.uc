class KFWeapDef_HRG_Gunzerks extends KFWeaponDefinition
    abstract;

static function string GetItemName()
{
    return "HRG Gunzerks";
}

static function string GetItemCategory()
{
	return "HRG Gunzerks";
}

static function string GetItemDescription()
{
    return "This is HRG Gunzerks!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Gunzerks";
}

DefaultProperties
{
    WeaponClassPath="SnWeapon.KFWeap_HRG_Gunzerks"

    BuyPrice=1600
    AmmoPricePerMag=30

    ImagePath="WEP_UI_HRG_BlastBrawlers_TEX.UI_WeaponSelect_HRG_BlastBrawlers" 

    EffectiveRange=15

    UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}