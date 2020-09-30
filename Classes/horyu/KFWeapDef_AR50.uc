
class KFWeapDef_AR50 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "AR-50 Survival Rifle";
}

static function string GetItemCategory()
{
	return "AR-50 Survival Rifle";
}

static function string GetItemDescription()
{
    return "This is AR-50 Survival Rifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "AR-50 Survival Rifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_AR50"

	BuyPrice=200
	AmmoPricePerMag=20
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_AR15"

	EffectiveRange=60

	UpgradePrice[0]=500
	UpgradePrice[1]=600
	UpgradePrice[2]=700
	UpgradePrice[3]=1500

	UpgradeSellPrice[0]=375
	UpgradeSellPrice[1]=825
	UpgradeSellPrice[2]=1350
	UpgradeSellPrice[3]=2475
}
