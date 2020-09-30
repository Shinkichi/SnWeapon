class KFWeapDef_M1895 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "USSR M1895";
}

static function string GetItemCategory()
{
	return "USSR M1895";
}

static function string GetItemDescription()
{
    return "This is USSR M1895!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "USSR M1895";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_M1895"

	BuyPrice=650
	AmmoPricePerMag=42//55 //50
	ImagePath="WEP_UI_Centerfire_TEX.UI_WeaponSelect_Centerfire"

	EffectiveRange=70

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
