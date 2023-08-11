
class KFWeapDef_TacticalRifle extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "TRs 301 Tactical Rifle";
}

static function string GetItemCategory()
{
	return "TRs 301 Tactical Rifle";
}

static function string GetItemDescription()
{
    return "This is TRs 301 Tactical Rifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "TRs 301 Tactical Rifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_TacticalRifle"
	
	BuyPrice=1300//1200
	AmmoPricePerMag=30
	ImagePath="wep_ui_m16_m203_tex.UI_WeaponSelect_M16M203"

	EffectiveRange=68

	SecondaryAmmoMagSize=1
	SecondaryAmmoMagPrice=15 //13

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
