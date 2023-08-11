
class KFWeapDef_ExpressRifle extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Nitrostick";
}

static function string GetItemCategory()
{
	return "Nitrostick";
}

static function string GetItemDescription()
{
    return "This is Nitrostick!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Nitrostick";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_ExpressRifle"

	BuyPrice=1500
	AmmoPricePerMag=30//25 //25
	ImagePath="WEP_UI_Quad_Barrel_TEX.UI_WeaponSelect_QuadBarrel" //@TODO: Replace

	EffectiveRange=15

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
