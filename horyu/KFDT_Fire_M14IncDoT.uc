// M14 Incendiary - By Shinkichi 2020
class KFDT_Fire_M14IncDoT extends KFDT_Fire
	abstract
	hidedropdown;


defaultproperties
{
	WeaponDef = class'KFWeapDef_M14Inc'

	DoT_Type = DOT_Fire
	DoT_Duration = 2.0 //5.0 //1.0 //2.7
	DoT_Interval = 0.5
	DoT_DamageScale = 0.1//0.3 //1.0 //0.7

	BurnPower = 8.5 //1.0 //18.5
}

