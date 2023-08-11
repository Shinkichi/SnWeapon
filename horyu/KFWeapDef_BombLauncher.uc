class KFWeapDef_BombLauncher extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Bomb Launcher";
}

static function string GetItemCategory()
{
	return "Bomb Launcher";
}

static function string GetItemDescription()
{
    return "This is Bomb Launcher!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Bomb Launcher";
}

defaultproperties
{
	WeaponClassPath="SnWeapon.KFWeap_BombLauncher"

	BuyPrice=2000

	AmmoPricePerMag=70//40

	ImagePath="WEP_UI_Gravity_Imploder_TEX.UI_WeaponSelect_Gravity_Imploder"

	EffectiveRange=95 // Based on comment Slightly less than  M79 Grenade Launcher

	//SharedUnlockId=SCU_GravityImploder
}

