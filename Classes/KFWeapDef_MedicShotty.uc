class KFWeapDef_MedicShotty extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HMTech-131 Shotty";
}

static function string GetItemCategory()
{
	return "HMTech-131 Shotty";
}

static function string GetItemDescription()
{
    return "This is HMTech-131 Shotty!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HMTech-131 Shotty";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotty_Medic"

	BuyPrice=300//200
	AmmoPricePerMag=20//10
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
