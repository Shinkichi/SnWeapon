class KFWeapDef_Marksman extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Marksman Rifle";
}

static function string GetItemCategory()
{
	return "Marksman Rifle";
}

static function string GetItemDescription()
{
    return "This is Marksman Rifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Marksman Rifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_Marksman"

	BuyPrice=650
	AmmoPricePerMag=30
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Bullpup"

	EffectiveRange=68

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
