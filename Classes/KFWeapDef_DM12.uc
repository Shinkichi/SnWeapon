
class KFWeapDef_DM12 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "DM12 Multi-Barrel";
}

static function string GetItemCategory()
{
	return "DM12 Multi-Barrel";
}

static function string GetItemDescription()
{
    return "This is DM12 Multi-Barrel!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "DM12 Multi-Barrel";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotgun_DM12"

	BuyPrice=850//750
	AmmoPricePerMag=48//64
	ImagePath="WEP_UI_HZ12_TEX.UI_WeaponSelect_HZ12"

	EffectiveRange=20

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}