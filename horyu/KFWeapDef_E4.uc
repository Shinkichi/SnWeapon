class KFWeapDef_E4 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "E4 Lightstorms";
}

static function string GetItemCategory()
{
	return "E4 Lightstorms";
}

static function string GetItemDescription()
{
    return "This is E4 Lightstorms!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "E4 Lightstorms";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Thrown_E4"

	BuyPrice=300
	AmmoPricePerMag=50 // 27
	ImagePath="WEP_UI_C4_TEX.UI_WeaponSelect_C4"

	EffectiveRange=10

	//UpgradePrice[0]=600
	//UpgradePrice[1]=700
	//UpgradePrice[2]=1500

	//UpgradeSellPrice[0]=450
	//UpgradeSellPrice[1]=975
	//UpgradeSellPrice[2]=2100
}
