
class KFWeapDef_PeacemakerDual extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Dual SAA Peacemakers";
}

static function string GetItemCategory()
{
	return "Dual SAA Peacemakers";
}

static function string GetItemDescription()
{
    return "This is Dual SAA Peacemakers!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual SAA Peacemakers";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Revolver_DualPeacemaker"

	BuyPrice=300//200
	AmmoPricePerMag=32//20  //12
	ImagePath="WEP_UI_DualRemington1858_TEX.UI_WeaponSelect_DualRemington"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
