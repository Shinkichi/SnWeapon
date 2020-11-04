
class KFWeapDef_IncendiaryM79 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Incendiary M79";
}

static function string GetItemCategory()
{
	return "Incendiary M79";
}

static function string GetItemDescription()
{
    return "This is Incendiary M79!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Incendiary M79";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_GrenadeLauncher_IncendiaryM79"

	BuyPrice=750//650
	AmmoPricePerMag=13
	ImagePath="WEP_UI_M79_TEX.UI_WeaponSelect_M79"

	EffectiveRange=100

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
