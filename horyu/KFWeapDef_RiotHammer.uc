class KFWeapDef_RiotHammer extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "Riot Hammer";
}

static function string GetItemCategory()
{
	return "Riot Hammer";
}

static function string GetItemDescription()
{
    return "This is Riot Hammer!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "Riot Hammer";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_Blunt_RiotHammer"
	
	BuyPrice=1300
	AmmoPricePerMag=85
	ImagePath="ui_weaponselect_tex.UI_WeaponSelect_Pulverizer"

	EffectiveRange=3

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
