class KFMeleeHelperWeaponGunzerks extends KFMeleeHelperWeapon
	config(Game);

event InitWorldTraceForHitboxCollision()
{
	local KFWeap_HRG_Gunzerks Gunzerks;

	Gunzerks = KFWeap_HRG_Gunzerks(Instigator.Weapon);
	if (Gunzerks != none)
	{
		Gunzerks.Shoot();
	}

	super.InitWorldTraceForHitboxCollision();
}

simulated function InitAttackSequence(EPawnOctant NewAtkDir, EMeleeAttackType NewAtkType)
{
	super.InitAttackSequence(NewAtkDir, NewAtkType);
	NextAttackType = NewAtkType;
}

defaultproperties
{

}
