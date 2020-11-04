class KFWeapDef_Grenadier extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HMTech-351 Grenadier";
}

static function string GetItemCategory()
{
	return "HMTech-351 Grenadier";
}

static function string GetItemDescription()
{
    return "This is HMTech-351 Grenadier!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HMTech-351 Grenadier";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Grenadier"

	BuyPrice=1100
	AmmoPricePerMag=40
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_MedicShotgun"

	EffectiveRange=50

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650

}
