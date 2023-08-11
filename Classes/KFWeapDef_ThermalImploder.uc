
class KFWeapDef_ThermalImploder extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Thermal Imploder";
}

static function string GetItemCategory()
{
    return "Thermal Imploder";
}

static function string GetItemDescription()
{
    return "This is Thermal Imploder!!";
}

static function string GetItemLocalization(string KeyName)
{
    return "Thermal Imploder";
}

defaultproperties
{
	WeaponClassPath="SnWeapon.KFWeap_ThermalImploder"

	BuyPrice=2000

	AmmoPricePerMag=70//40

	ImagePath="WEP_UI_Gravity_Imploder_TEX.UI_WeaponSelect_Gravity_Imploder"

	EffectiveRange=95 // Based on comment Slightly less than  M79 Grenade Launcher

	//SharedUnlockId=SCU_GravityImploder
}

