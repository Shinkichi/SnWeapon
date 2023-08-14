class KFWeapDef_Tranquilizer extends KFWeaponDefinition
    abstract;

static function string GetItemName()
{
    return "Tranquilizer";
}

static function string GetItemCategory()
{
	return "Tranquilizer";
}

static function string GetItemDescription()
{
    return "This is Tranquilizer!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Tranquilizer";
}

DefaultProperties
{
    WeaponClassPath="SnWeapon.KFWeap_Rifle_Tranquilizer"

    BuyPrice=2500//1100
    AmmoPricePerMag=60//30
    ImagePath="WEP_UI_Bleeder_TEX.UI_WeaponSelect_Bleeder"

    EffectiveRange=90

    //UpgradePrice[0]=700
	//UpgradePrice[1]=1500

	//UpgradeSellPrice[0]=525
	//UpgradeSellPrice[1]=1650
}
