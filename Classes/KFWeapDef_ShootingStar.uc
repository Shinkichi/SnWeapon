class KFWeapDef_ShootingStar extends KFWeaponDefinition
    abstract;

static function string GetItemName()
{
    return "Shooting Star";
}

static function string GetItemCategory()
{
	return "Shooting Star";
}

static function string GetItemDescription()
{
    return "This is Shooting Star!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Shooting Star";
}

DefaultProperties
{
    WeaponClassPath="SnWeapon.KFWeap_Pistol_ShootingStar"

    BuyPrice=550
    AmmoPricePerMag=17
    ImagePath="wep_ui_chiapparhino_tex.UI_WeaponSelect_ChiappaRhinos"

    EffectiveRange=50

    UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650

	//SharedUnlockId=SCU_ChiappaRhino
}
