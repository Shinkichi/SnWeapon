class KFWeapDef_HRG_ElectroDual extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dual HRG Electros";
}

static function string GetItemCategory()
{
	return "Dual HRG Electros";
}

static function string GetItemDescription()
{
    return "This is Dual HRG Electros!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual HRG Electros";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_Electro_Dual"

	BuyPrice=1100
	AmmoPricePerMag=32//42
	ImagePath="WEP_UI_Dual_HRG_SW_500_TEX.UI_WeaponSelect_HRG_DualSW500"

	EffectiveRange=15

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
