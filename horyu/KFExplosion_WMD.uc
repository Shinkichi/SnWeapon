class KFExplosion_WMD extends KFExplosion_Nuke;

simulated function Explode(GameExplosion NewExplosionTemplate, optional vector Direction)
{
	NewExplosionTemplate.MyDamageType = NewExplosionTemplate.default.MyDamageType;
	super.Explode(NewExplosionTemplate, Direction);

	ExplosionTemplate.Damage = class'KFPerk_Demolitionist'.static.GetLingeringPoisonDamage();
	ExplosionTemplate.MyDamageType = class'KFDT_Toxic_WMD';
}

DefaultProperties
{
}
