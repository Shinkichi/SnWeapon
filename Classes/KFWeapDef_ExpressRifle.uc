
class KFWeapDef_ExpressRifle extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Express Rifle";
}

static function string GetItemCategory()
{
	return "Express Rifle";
}

static function string GetItemDescription()
{
    return "This is Express Rifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Express Rifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_ExpressRifle"

	BuyPrice=1500
	AmmoPricePerMag=25 //25
	ImagePath="WEP_UI_Quad_Barrel_TEX.UI_WeaponSelect_QuadBarrel" //@TODO: Replace

	EffectiveRange=15

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
