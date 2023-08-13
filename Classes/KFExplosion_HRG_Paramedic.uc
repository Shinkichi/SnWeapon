
class KFExplosion_HRG_Paramedic extends KFExplosionActorLingering;

var private int HealingValue;

// Disable Knockdown for friendlies
protected function bool KnockdownPawn(BaseAiPawn Victim, float DistFromExplosion)
{
	if (Victim.GetTeamNum() != Instigator.GetTeamNum())
	{
		return Super.KnockdownPawn(Victim, DistFromExplosion);
	}

	return false;
}

// Disable Stumble for friendlies
protected function bool StumblePawn(BaseAiPawn Victim, float DistFromExplosion)
{
	if (Victim.GetTeamNum() != Instigator.GetTeamNum())
	{
		return Super.StumblePawn(Victim, DistFromExplosion);
	}

	return false;
}

protected simulated function AffectsPawn(Pawn Victim, float DamageScale)
{
	local KFPawn KFP;

	if( bWasFadedOut|| bDeleteMe || bPendingDelete )
	{
		return;
	}

	KFP = KFPawn(Victim);

	if (KFP == none)
	{
		return;
	}

	if (KFP.GetTeamNum() == Instigator.GetTeamNum())
	{
		KFP.HealDamage(HealingValue, Instigator.Controller, class'KFDT_Healing');
	}
	else
	{
		super.AffectsPawn(VIctim, DamageScale);

		KFP.ApplyDamageOverTime(class'KFDT_Toxic_Paramedic'.default.PoisonPower, Instigator.Controller, class'KFDT_Toxic_Paramedic');
	}
}

DefaultProperties
{
	Interval=0f
	MaxTime=0f

	bOnlyDamagePawns=true
	bDoFullDamage=false

	bExplodeMoreThanOnce=false

	HealingValue=20//15//50
}
