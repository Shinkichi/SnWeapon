
class KFWeapDef_BomberGunDual extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dual Bombies";
}

static function string GetItemCategory()
{
	return "Dual Bombies";
}

static function string GetItemDescription()
{
    return "This is Dual Bombies!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual Bombies";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_DualBomber"

	BuyPrice=650
	AmmoPricePerMag=26
	ImagePath="wep_ui_dual_flaregun_tex.UI_WeaponSelect_DualFlaregun"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
