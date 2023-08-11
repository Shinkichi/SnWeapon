
class KFWeapDef_HRGInfantryLifle extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Infantry Lifle";
}

static function string GetItemCategory()
{
	return "HRG Infantry Lifle";
}

static function string GetItemDescription()
{
    return "This is HRG Infantry Lifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Infantry Lifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_HRGInfantryLifle"
	
	BuyPrice=1300//1200
	AmmoPricePerMag=30

	ImagePath="WEP_UI_HRG_IncendiaryRifle_TEX.UI_WeaponSelect_HRG_IncendiaryRifle"

	EffectiveRange=68

	SecondaryAmmoMagSize=1
	SecondaryAmmoMagPrice=15

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
