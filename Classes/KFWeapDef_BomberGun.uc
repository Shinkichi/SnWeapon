
class KFWeapDef_BomberGun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "BomberGun";
}

static function string GetItemCategory()
{
	return "BomberGun";
}

static function string GetItemDescription()
{
    return "This is BomberGun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "BomberGun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_Bomber"

	BuyPrice=325
	AmmoPricePerMag=13
	ImagePath="wep_ui_flaregun_tex.UI_WeaponSelect_Flaregun"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
