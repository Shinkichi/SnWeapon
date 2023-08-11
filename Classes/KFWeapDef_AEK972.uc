class KFWeapDef_AEK972 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Koksharov AEK-972";
}

static function string GetItemCategory()
{
	return "Koksharov AEK-972";
}

static function string GetItemDescription()
{
    return "This is Koksharov AEK-972!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Koksharov AEK-972";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_AssaultRifle_AEK972"

	BuyPrice=1200//1100
	AmmoPricePerMag=40
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_AK12"

	EffectiveRange=67

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125
}
