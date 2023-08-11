class KFWeapDef_PayloadRifle extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "XM109 AMPR";
}

static function string GetItemCategory()
{
	return "XM109 AMPR";
}

static function string GetItemDescription()
{
    return "This is XM109 AMPR!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "XM109 AMPR";
}


DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Rifle_PayloadRifle"

	BuyPrice = 2500 //1500
	AmmoPricePerMag = 38 //28 //50
	ImagePath="WEP_UI_M99_TEX.UI_WeaponSelect_M99"

	EffectiveRange = 100


}
