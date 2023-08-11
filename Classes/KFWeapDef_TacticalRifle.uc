class KFWeapDef_TacticalRifle extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "SWTech-501 Tactical Rifle";
}

static function string GetItemCategory()
{
	return "SWTech-501 Tactical Rifle";
}

static function string GetItemDescription()
{
    return "This is SWTech-501 Tactical Rifle!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "SWTech-501 Tactical Rifle";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_TacticalRifle"

	BuyPrice=2000  //1200
	AmmoPricePerMag=32//47 //30
	ImagePath="WEP_UI_Medic_GrenadeLauncher_TEX.UI_WeaponSelect_MedicGrenadeLauncher"

	EffectiveRange=68

	SecondaryAmmoMagSize=1
	SecondaryAmmoMagPrice=27 //13 //18


}
