
class KFWeapDef_IncendiarySniper extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "DSA SA58 ACOG";
}

static function string GetItemCategory()
{
	return "DSA SA58 ACOG";
}

static function string GetItemDescription()
{
    return "This is DSA SA58 ACOG!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "DSA SA58 ACOG";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_IncendiarySniper"

	BuyPrice=1600 //1500
	AmmoPricePerMag=71//47
	ImagePath="WEP_UI_FNFAL_TEX.UI_WeaponSelect_FNFAL"
	

	EffectiveRange=70

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
