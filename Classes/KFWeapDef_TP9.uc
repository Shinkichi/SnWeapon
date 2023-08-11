
class KFWeapDef_TP9 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "TP9 SMG";
}

static function string GetItemCategory()
{
	return "TP9 SMG";
}

static function string GetItemDescription()
{
    return "This is TP9 SMG!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "TP9 SMG";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_SMG_TP9"

	BuyPrice=300//200
	AmmoPricePerMag=25//16 //26
	ImagePath="WEP_UI_MP7_TEX.UI_WeaponSelect_MP7"

	EffectiveRange=70

	UpgradePrice[0]=500
	UpgradePrice[1]=600
	UpgradePrice[2]=700
	UpgradePrice[3]=1500

	UpgradeSellPrice[0]=375
	UpgradeSellPrice[1]=825
	UpgradeSellPrice[2]=1350
	UpgradeSellPrice[3]=2475
}