class KFWeapDef_G21 extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Ballistic Shield & Glock 21";
}

static function string GetItemCategory()
{
	return "Ballistic Shield & Glock 21";
}

static function string GetItemDescription()
{
    return "This is Ballistic Shield & Glock 21!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Ballistic Shield & Glock 21";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_SMG_G21"

	BuyPrice=1400//1500
	AmmoPricePerMag=39//24
	ImagePath="WEP_UI_RiotShield_TEX.UI_WeaponSelect_RiotShield"

	EffectiveRange=70

	UpgradePrice[0]=1500

	UpgradeSellPrice[0]=1125

	//SharedUnlockId=SCU_G18RiotShield
}