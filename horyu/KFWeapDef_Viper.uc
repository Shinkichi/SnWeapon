
class KFWeapDef_Viper extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Viper50 SMG";
}

static function string GetItemCategory()
{
	return "Viper50 SMG";
}

static function string GetItemDescription()
{
    return "This is Viper50 SMG!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Viper50 SMG";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_SMG_Viper"

	BuyPrice=750//650
	AmmoPricePerMag=30
	ImagePath="WEP_UI_MP5RAS_TEX.UI_WeaponSelect_MP5RAS"

	EffectiveRange=70

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}