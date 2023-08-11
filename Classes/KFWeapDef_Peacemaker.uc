
class KFWeapDef_Peacemaker extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "SAA Peacemaker";
}

static function string GetItemCategory()
{
	return "SAA Peacemaker";
}

static function string GetItemDescription()
{
    return "This is SAA Peacemaker!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "SAA Peacemaker";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Revolver_Peacemaker"

	BuyPrice=150//100
	AmmoPricePerMag=16//10 //6
	ImagePath="WEP_UI_Remington_1858_TEX.UI_WeaponSelect_Remington"

	EffectiveRange=50

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
