
class KFWeapDef_PlasmaCutter extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Plasma Cutter";
}

static function string GetItemCategory()
{
	return "Plasma Cutter";
}

static function string GetItemDescription()
{
    return "This is Plasma Cutter!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Plasma Cutter";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_PlasmaCutter"

	BuyPrice=300
	AmmoPricePerMag=10
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Welder"
	
	UpgradePrice[0]=500
	UpgradePrice[1]=600
	UpgradePrice[2]=700
	UpgradePrice[3]=1500

	UpgradeSellPrice[0]=375
	UpgradeSellPrice[1]=825
	UpgradeSellPrice[2]=1350
	UpgradeSellPrice[3]=2475
}
