class KFWeapDef_HRGKillBurst extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Killburst";
}

static function string GetItemCategory()
{
	return "HRG Killburst";
}

static function string GetItemDescription()
{
    return "This is HRG Killburst!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Killburst";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_HRGKillBurst"

	BuyPrice=1000
	AmmoPricePerMag=12
	ImagePath="WEP_UI_HRGScorcher_Pistol_TEX.UI_WeaponSelect_HRGScorcher"

	EffectiveRange=100 // Based on comment Slightly less than  M79 Grenade Launcher

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
