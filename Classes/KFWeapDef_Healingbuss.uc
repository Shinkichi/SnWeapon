
class KFWeapDef_Healingbuss extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Healingbuss";
}

static function string GetItemCategory()
{
	return "Healingbuss";
}

static function string GetItemDescription()
{
    return "This is Healingbuss!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Healingbuss";
}

defaultproperties
{
	WeaponClassPath="SnWeapon.KFWeap_Pistol_Healingbuss"

	BuyPrice=1500

	AmmoPricePerMag=39

	ImagePath="WEP_UI_Blunderbuss_TEX.UI_WeaponSelect_BlunderBluss"

	EffectiveRange=95 // Based on comment Slightly less than  M79 Grenade Launcher

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125

	//SharedUnlockId=SCU_Blunderbuss
}

