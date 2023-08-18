
class KFWeapDef_LaserRifle extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Laser Rifle";
}

static function string GetItemCategory()
{
	return "Laser Rifle";
}

static function string GetItemDescription()
{
    return "This is Laser Rifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Laser Rifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_LaserRifle"

	BuyPrice=2500//2000
	AmmoPricePerMag=50//75//66
	ImagePath="WEP_UI_Microwave_Assault_TEX.UI_WeaponSelect_Microwave_Assault"

	EffectiveRange=70
}
