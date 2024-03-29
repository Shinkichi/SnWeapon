
class KFWeapDef_DoubleDragon extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Sawn-Offed Dragostick";
}

static function string GetItemCategory()
{
	return "Sawn-Offed Dragostick";
}

static function string GetItemDescription()
{
    return "This is Sawn-Offed Dragostick!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Sawn-Offed Dragostick";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotgun_DoubleDragon"

	BuyPrice=750 //650
	AmmoPricePerMag=13 //11
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_DBShotgun"

	EffectiveRange=15

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
