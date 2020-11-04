class KFWeapDef_Trenchgun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "M1897 Trenchgun";
}

static function string GetItemCategory()
{
	return "M1897 Trenchgun";
}

static function string GetItemDescription()
{
    return "This is M1897 Trenchgun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "M1897 Trenchgun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Shotgun_Trenchgun"

	BuyPrice=650
	AmmoPricePerMag=36//30
	ImagePath="WEP_UI_DragonsBreath.UI_WeaponSelect_DragonsBreath"

	EffectiveRange=25

	UpgradePrice[0]=600
	UpgradePrice[1]=700
	UpgradePrice[2]=1500

	UpgradeSellPrice[0]=450
	UpgradeSellPrice[1]=975
	UpgradeSellPrice[2]=2100
}
