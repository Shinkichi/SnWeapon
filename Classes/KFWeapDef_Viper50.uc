
class KFWeapDef_Viper50 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Viper 50";
}

static function string GetItemCategory()
{
	return "Viper 50";
}

static function string GetItemDescription()
{
    return "This is Viper 50!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Viper 50";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_SMG_Viper50"

	BuyPrice=750//650
	AmmoPricePerMag=30//28 //22 //33
	ImagePath="WEP_UI_MP5RAS_TEX.UI_WeaponSelect_MP5RAS"

	EffectiveRange=70

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}