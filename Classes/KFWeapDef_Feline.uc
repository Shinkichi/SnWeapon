class KFWeapDef_Feline extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Feline X3 SMG";
}

static function string GetItemCategory()
{
	return "Feline X3 SMG";
}

static function string GetItemDescription()
{
    return "This is Feline X3 SMG!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Feline X3 SMG";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_Feline"

	BuyPrice=750//650
	AmmoPricePerMag=32 //30
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Bullpup"

	EffectiveRange=68

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
