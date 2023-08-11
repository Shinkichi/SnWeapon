class KFWeapDef_Rivetgun_HRG extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Rivetgun";
}

static function string GetItemCategory()
{
	return "HRG Rivetgun";
}

static function string GetItemDescription()
{
    return "This is HRG Rivetgun!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Rivetgun";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_Rivetgun"
	AttachmentArchtypePath="WEP_Nail_Shotgun_ARCH.Wep_Nail_Shotgun_3P"
	
	BuyPrice=1100
	AmmoPricePerMag=45
	ImagePath="WEP_UI_HRG_Nailgun_PDW_TEX.UI_WeaponSelect_HRG_Nailgun_PDW"

	EffectiveRange=55

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
