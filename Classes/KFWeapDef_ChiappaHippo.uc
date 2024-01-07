
class KFWeapDef_ChiappaHippo extends KFWeaponDefinition
    abstract;

static function string GetItemName()
{
    return "Hippo";
}

static function string GetItemCategory()
{
	return "Hippo";
}

static function string GetItemDescription()
{
    return "This is Hippo!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Hippo";
}

DefaultProperties
{
    WeaponClassPath="SnWeapon.KFWeap_Pistol_ChiappaHippo"

    BuyPrice=450//550
    AmmoPricePerMag=13//17
    ImagePath="wep_ui_chiapparhino_tex.UI_WeaponSelect_ChiappaRhinos"

	IsPlayGoHidden=true;


    EffectiveRange=50

    UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650

	//SharedUnlockId=SCU_ChiappaRhino
}
