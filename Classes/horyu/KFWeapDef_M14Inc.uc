// M14 Incendiary - By Shinkichi 2020
class KFWeapDef_M14Inc extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dragon Sniper";
}

static function string GetItemCategory()
{
	return "Dragon Sniper";
}

static function string GetItemDescription()
{
    return "This is Dragon Sniper!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dragon Sniper";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_M14Inc"

	BuyPrice=1100
	AmmoPricePerMag=42
	ImagePath="WEP_UI_M14EBR_TEX.UI_WeaponSelect_SM14-EBR"

	EffectiveRange=90

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
