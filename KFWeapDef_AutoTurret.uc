//=============================================================================
// KFWeapDef_AutoTurret
//=============================================================================
//=============================================================================
// Killing Floor 2
// Copyright (C) 2022 Tripwire Interactive LLC
//=============================================================================
class KFWeapDef_AutoTurret extends KFWeaponDefinition
	abstract;

DefaultProperties
{
	WeaponClassPath="KFGameContent.KFWeap_AutoTurret"

	BuyPrice=500
	AmmoPricePerMag=60 // 27
	ImagePath="WEP_UI_AutoTurret_TEX.UI_WeaponSelect_AutoTurret"

	IsPlayGoHidden=true;

	EffectiveRange=18

	UpgradePrice[0]=700
	UpgradePrice[1]=1500

	UpgradeSellPrice[0]=525
	UpgradeSellPrice[1]=1650

	SharedUnlockId=SCU_AutoTurret

}
