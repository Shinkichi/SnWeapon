
class KFWeapDef_MedicMarksman extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HMTech-441 Battle Rifle";
}

static function string GetItemCategory()
{
	return "HMTech-441 Battle Rifle";
}

static function string GetItemDescription()
{
    return "This is HMTech-441 Battle Rifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HMTech-441 Battle Rifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Marksman_Medic"

	BuyPrice=1600//1500
	AmmoPricePerMag=40
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_MedicAssault"

	EffectiveRange=70

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
