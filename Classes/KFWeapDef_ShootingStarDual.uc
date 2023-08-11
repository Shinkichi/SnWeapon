class KFWeapDef_ShootingStarDual extends KFWeaponDefinition
    abstract;

static function string GetItemName()
{
    return "Dual Shooting Stars";
}

static function string GetItemCategory()
{
	return "Dual Shooting Stars";
}

static function string GetItemDescription()
{
    return "This is Dual Shooting Stars!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual Shooting Stars";
}

DefaultProperties
{
    WeaponClassPath="SnWeapon.KFWeap_Pistol_ShootingStarDual"

    BuyPrice=1100
    AmmoPricePerMag=34
    ImagePath="wep_ui_chiapparhino_tex.UI_WeaponSelect_DualChiappaRhinos"

    EffectiveRange=50

    UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650

	//SharedUnlockId=SCU_ChiappaRhino
}
