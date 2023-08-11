
class KFWeapDef_Auto1911Dual extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dual Auto1911 Pistols";
}

static function string GetItemCategory()
{
	return "Dual Auto1911 Pistols";
}

static function string GetItemDescription()
{
    return "This is Dual Auto1911 Pistols!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual Auto1911 Pistols";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_DualAuto1911"

	BuyPrice=750//650
	AmmoPricePerMag=26
	ImagePath="WEP_UI_Dual_M1911_TEX.UI_WeaponSelect_DualM1911"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
