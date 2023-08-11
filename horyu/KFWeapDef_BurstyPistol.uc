
class KFWeapDef_BurstyPistol extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HMTech-121 Bursty";
}

static function string GetItemCategory()
{
	return "HMTech-121 Bursty";
}

static function string GetItemDescription()
{
    return "This is HMTech-121 Bursty!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HMTech-121 Bursty";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_Bursty"

	BuyPrice=300//200
	AmmoPricePerMag=10
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_MedicPistol"

	EffectiveRange=50

	UpgradePrice[0]=500
	UpgradePrice[1]=600
	UpgradePrice[2]=700
	UpgradePrice[3]=1500

	UpgradeSellPrice[0]=375
	UpgradeSellPrice[1]=825
	UpgradeSellPrice[2]=1350
	UpgradeSellPrice[3]=2475
}
