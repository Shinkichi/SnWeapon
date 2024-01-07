
class KFWeapDef_ChiappaHippoDual extends KFWeaponDefinition
    abstract;

static function string GetItemName()
{
    return "Dual Hippos";
}

static function string GetItemCategory()
{
	return "Dual Hippos";
}

static function string GetItemDescription()
{
    return "This is Dual Hippos!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Dual Hippos";
}

DefaultProperties
{
    WeaponClassPath="SnWeapon.KFWeap_Pistol_ChiappaHippoDual"

    BuyPrice=900//1100
    AmmoPricePerMag=26//34
    ImagePath="wep_ui_chiapparhino_tex.UI_WeaponSelect_DualChiappaRhinos"

	IsPlayGoHidden=true;

    EffectiveRange=50

    UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650

	//SharedUnlockId=SCU_ChiappaRhino
}
