class KFWeapDef_BFR extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Biggest Finest Revolver";
}

static function string GetItemCategory()
{
	return "Biggest Finest Revolver";
}

static function string GetItemDescription()
{
    return "This is Biggest Finest Revolver!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Biggest Finest Revolver";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Revolver_BFR"

	BuyPrice=800//750
	AmmoPricePerMag=35//25
	ImagePath="WEP_UI_SW_500_TEX.UI_WeaponSelect_SW500"

	EffectiveRange=50

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
