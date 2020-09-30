
class KFWeapDef_Auto1911 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Auto1911 Pistol";
}

static function string GetItemCategory()
{
	return "Auto1911 Pistol";
}

static function string GetItemDescription()
{
    return "This is Auto1911 Pistol!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Auto1911 Pistol";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_Auto1911"

	BuyPrice=325
	AmmoPricePerMag=13
	ImagePath="WEP_UI_M1911_TEX.UI_WeaponSelect_M1911Colt"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
