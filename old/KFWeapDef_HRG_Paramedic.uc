
class KFWeapDef_HRG_Paramedic extends KFWeaponDefinition
	abstract;

static function string GetItemName()
{
    return "HRG Paramedic(Proto)";
}

static function string GetItemCategory()
{
	return "HRG Paramedic(Proto)";
}

static function string GetItemDescription()
{
    return "This is HRG Paramedic(Proto)!!";
}

static function string GetItemLocalization(string KeyName)
{
	return "HRG Paramedic(Proto)";
}

DefaultProperties
{
	WeaponClassPath="SnWeapon.KFWeap_HRG_Paramedic"

	BuyPrice=500
	AmmoPricePerMag=60 // 27
	ImagePath="WEP_UI_HRG_Warthog_TEX.UI_WeaponSelect_HRG_Warthog"

	IsPlayGoHidden=true;

	EffectiveRange=18

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650
}
