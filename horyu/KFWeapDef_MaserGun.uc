
class KFWeapDef_MaserGun extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Maser Gun";
}

static function string GetItemCategory()
{
	return "Maser Gun";
}

static function string GetItemDescription()
{
    return "This is Maser Gun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Maser Gun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_MaserGun"

	BuyPrice=1500
	AmmoPricePerMag=20 //25
	ImagePath="WEP_UI_RailGun_TEX.UI_WeaponSelect_Railgun"

	EffectiveRange=100

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
