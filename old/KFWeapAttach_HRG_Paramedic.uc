
class KFWeapAttach_HRG_Paramedic extends KFWeapAttach_DualBase;

`define AUTOTURRET_ATTACH_MIC_LED_INDEX 2

const ThrowAnim = 'Drone_Throw';
const CrouchThrowAnim = 'Drone_Throw_CH';

const DetonateAnim = 'Shoot';
const CrouchDetonateAnim = 'CH_Shoot';

const TransitionParamName = 'transition_full_to_empty';
const EmptyParamName = 'Blinking_0_off___1_on';

/** Completely overridden to play anims for both C4 firemodes (throw and detonate), also doesn't need to play effects */
simulated function bool ThirdPersonFireEffects( vector HitLocation, KFPawn P, byte ThirdPersonAnimRateByte )
{
	local float Duration;

	// Effects below this point are culled based on visibility and distance
	if ( !ActorEffectIsRelevant(P, false, MaxFireEffectDistance) )
	{
		return false;
	}

	DecodeThirdPersonAnimRate( ThirdPersonAnimRateByte );

	// Weapon shoot anims
	if (P.FiringMode == 0)
	{
		// anim simply hides and unhides bone
		Duration = WeapMesh.GetAnimLength( ThrowAnim );
		WeapMesh.PlayAnim( ThrowAnim, Duration / ThirdPersonAnimRate,, true );

		// use timer to make sure bone gets un-hidden (in case anim gets interrupted)
		SetTimer( 0.75f, false, nameof(UnHide) );
	}
	else if (P.FiringMode == 5)
	{
		Duration = WeapMesh.GetAnimLength( DetonateAnim );
		LeftWeapMesh.PlayAnim( DetonateAnim, Duration / ThirdPersonAnimRate,, true );
	}

	// Additive character shoot anims
	if ( !P.IsDoingSpecialMove() )
	{
		if( P.FiringMode == 0 )
		{
			if ( P.bIsCrouched )
			{
				P.PlayBodyAnim(CrouchThrowAnim, EAS_CH_UpperBody, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime);
			}
			else
			{
				P.PlayBodyAnim(ThrowAnim, EAS_UpperBody, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime);
			}
		}
		else if( P.FiringMode == 5 )
		{
			if ( P.bIsCrouched )
			{
				P.PlayBodyAnim(CrouchDetonateAnim, EAS_CH_UpperBody, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime);
			}
			else
			{
				P.PlayBodyAnim(DetonateAnim, EAS_UpperBody, ThirdPersonAnimRate, ShootBlendInTime, ShootBlendOutTime);
			}
		}
	}

	// prevent using "aiming" KFAnim_BlendByTargetingMode since we don't have/need the aim anims for C4
	P.LastWeaponFireTime = -1.f;

	return true;
}

/** Unhides the C4 unit in hand (basically the same as the notify, but don't use the notify) */
simulated function UnHide()
{
	if( WeapMesh != none )
	{
		WeapMesh.UnHideBoneByName( 'RW_Weapon' );
	}
}

/** Special event added for weap attachments. Free for use */
function OnSpecialEvent(int Arg)
{
	local float Value;
	Value = (Arg - 1) / 100.0f;

	if (Value >= 0)
	{
		if ( WeaponMIC == None && LeftWeapMesh != None )
		{
			WeaponMIC = LeftWeapMesh.CreateAndSetMaterialInstanceConstant(`AUTOTURRET_ATTACH_MIC_LED_INDEX);
		}
	
		WeaponMIC.SetScalarParameterValue(TransitionParamName, 1.0f - Value);
		WeaponMIC.SetScalarParameterValue(EmptyParamName, Value == 0 ? 1 : 0);
	}
}

defaultproperties
{
	bHasLaserSight=false
}