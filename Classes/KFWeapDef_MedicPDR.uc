
class KFWeapDef_MedicPDR extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HMTech-241 PDR";
}

static function string GetItemCategory()
{
	return "HMTech-241 PDR";
}

static function string GetItemDescription()
{
    return "This is HMTech-241 PDR!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HMTech-241 PDR";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_PDR_Medic"

	BuyPrice=750//650
	AmmoPricePerMag=30//21
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_MedicSMG"

	EffectiveRange=70

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
