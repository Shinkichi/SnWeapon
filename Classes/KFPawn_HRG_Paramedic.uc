
class KFPawn_HRG_Paramedic extends KFPawn
	notplaceable;
    
`define AUTOTURRET_MIC_INDEX 0

enum ETurretState
{
    ETS_None,
    ETS_Throw,
    ETS_Deploy,
    ETS_TargetSearch,
    ETS_Combat,
    ETS_Detonate,
    ETS_Empty
};

var SkeletalMeshComponent TurretMesh;
var Controller InstigatorController;

/** Speed to rise the drone in Z axis after thrown */
var const float DeployZSpeed;
/** Height (Z axis) the drone should position for deployment */
var const float DeployHeight;
/** Radius to detect enemies */
var const float EffectiveRadius;
/** Radius to trigger explosion */
var const float ExplosiveRadius;
/** Rotation Vel for aiming targets */
var const rotator AimRotationVel;
/** Rotation Vel for aiming targets */
var const rotator CombatRotationVel;
/** Time before refreshing targets */
var const float TimeBeforeRefreshingTargets;
/** Time to idle after rotating to a random position (search) */
var const float TimeIdlingWhenSearching;
/** Min Value to apply randomness to idling */
var const float MinIdlingVariation;
/** Max Value to apply randomness to idling */
var const float MaxIdlingVariation;
/** Pitch requested when out of ammo */
var const int EmptyPitch;
/** Turret Explosion */
var GameExplosion ExplosionTemplate;
/** Weapon the turret carries */
var class<KFWeaponDefinition> WeaponDefinition;
/** WIf explodes when an enemy gets nearby */
var const bool bCanDetonateOnProximityWithAmmo;

var repnotify ETurretState CurrentState;
var repnotify rotator ReplicatedRotation;
var repnotify float CurrentAmmoPercentage;
var repnotify AKEvent TurretWeaponAmbientSound;
var repnotify int WeaponSkinID;
var repnotify int AutoTurretFlashCount;

var transient rotator DeployRotation;

/** Rotation */
var transient rotator RotationStart;
var transient rotator TargetRotation;
var transient float   RotationAlpha;
var transient float   RotationTime;
var transient bool    bRotating;

var transient KFWeap_HRG_ParamedicWeapon TurretWeapon;
var transient KFWeapAttach_HRG_WarthogWeap TurretWeaponAttachment;

var transient KFWeap_HRG_Paramedic OwnerWeapon;

var bool deployUsingOffsetFromPlayerLocation;
var float deployUsingOffsetZ;

var transient vector ThrowInstigatorLocation;
var transient vector GroundLocation; 
var transient vector DeployedLocation;
var transient float RandomSearchLocation;
var transient KFPawn_Human EnemyTarget;
var transient bool bHasSearchRandomLocation;
var transient byte TeamNum;
var transient bool bRotatingByTime;
var transient MaterialInstanceConstant TurretAttachMIC;

/** Socket name to attach weapon */
const WeaponSocketName = 'WeaponSocket';
const WeaponAttachmentSocketName = 'WeaponAttachment';

const TransitionParamName = 'transition_full_to_empty';
const EmptyParamName = 'Blinking_0_off___1_on';

const DroneFlyingStartAudio = AkEvent'WW_WEP_HRG_Warthog.Play_WEP_HRG_Warthog_Drone_IdleFly';
const DroneFlyingStopAudio = AkEvent'WW_WEP_HRG_Warthog.Stop_WEP_HRG_Warthog_Drone_IdleFly';

var AkComponent FlyAkComponent;

const DroneDryFire = AkEvent'WW_WEP_HRG_Warthog.Play_WEP_HRG_Warthog_Drone_DryFire';

const NoAmmoSocketName = 'malfunction';
const NoAmmoFXTemplate = ParticleSystem'WEP_HRG_Warthog_EMIT.FX_HRG_Warthog_NoAmmo_Sparks';
var transient ParticleSystemComponent NoAmmoFX;

var transient int DetonateNumberOfProjectiles;
var transient int DetonateMinimumDistance;
var transient int DetonateMaximumDistance;
var transient float DetonateMinTime;
var transient float DetonateMaxTime;

var transient vector DeployLastLocation;
var transient float LastMoveExpectedSize;

replication
{
    if( bNetDirty )
		CurrentState, ReplicatedRotation, CurrentAmmoPercentage, TurretWeaponAmbientSound, EnemyTarget, WeaponSkinID, AutoTurretFlashCount;
}

simulated event ReplicatedEvent(name VarName)
{
	if( VarName == nameof(CurrentState) )
	{
        ChangeState(CurrentState);
    }
    else if (VarName == nameof(ReplicatedRotation))
    {
        RotateBySpeed(ReplicatedRotation);
    }
    else if (VarName == nameof(CurrentAmmoPercentage))
    {
        UpdateTurretMeshMaterialColor(CurrentAmmoPercentage);
    }
    else if (VarName == nameof(TurretWeaponAmbientSound))
    {
        SetWeaponAmbientSound(TurretWeaponAmbientSound);
    }
    else if (VarName == nameof(WeaponSkinID))
    {
        SetWeaponSkin(WeaponSkinID);
    }
    else if (VarName == nameof(AutoTurretFlashCount))
    {
        FlashCountUpdated(Weapon, AutoTurretFlashCount, TRUE);
    }
    else if (VarName == nameof(FlashCount))
    {
        // Intercept Flash Count: do nothing
    }
    else
	{
		super.ReplicatedEvent(VarName);
	}
}

simulated event PreBeginPlay()
{
    local class<KFWeapon> WeaponClass;
    local rotator ZeroRotator;

    super.PreBeginPlay();
    
    WeaponClass = class<KFWeap_HRG_ParamedicWeapon> (DynamicLoadObject(WeaponDefinition.default.WeaponClassPath, class'Class'));
    WeaponClassForAttachmentTemplate = WeaponClass;

    SetMeshVisibility(false);

    if (Role == ROLE_Authority)
    {
        Weapon = Spawn(WeaponClass, self);
        TurretWeapon = KFWeap_HRG_ParamedicWeapon(Weapon);
        MyKFWeapon = TurretWeapon;

        if (Weapon != none)
        {
            Weapon.bReplicateInstigator=true;
            Weapon.bReplicateMovement=true;
            Weapon.Instigator = Instigator;
            TurretWeapon.InstigatorDrone = self;
            Weapon.SetCollision(false, false);
            Weapon.SetBase(self,, TurretMesh, WeaponSocketName);
            TurretMesh.AttachComponentToSocket(Weapon.Mesh, WeaponSocketName);

            Weapon.SetRelativeLocation(vect(0,0,0));
            Weapon.SetRelativeRotation(ZeroRotator);
            Weapon.Mesh.SetOnlyOwnerSee(true);
            MyKFWeapon.Mesh.SetHidden(true);
        }
    }
    if (WorldInfo.NetMode == NM_Client || WorldInfo.NetMode == NM_Standalone)
    {
        /** If this fails, the HRG Warthog is still loading from KFWeap_HRG_Warthog.  */
        if (WeaponClass.default.AttachmentArchetype != none)
		{
            SetTurretWeaponAttachment(WeaponClass);
        }
    }
}

simulated function SetTurretWeaponAttachment(class<KFWeapon> WeaponClass)
{
    local KFWeaponAttachment AttachmentTemplate;
    local rotator ZeroRotator;

    if (WeaponAttachment != none)
        return;

    // Create the new Attachment.
    AttachmentTemplate = WeaponClass.default.AttachmentArchetype;
    WeaponAttachment = Spawn(AttachmentTemplate.Class, self,,,, AttachmentTemplate);
    
    if (WeaponAttachment != None)
    {
        WeaponAttachment.SetCollision(false, false);
        WeaponAttachment.Instigator = Instigator;

        TurretMesh.AttachComponentToSocket(WeaponAttachment.WeapMesh, WeaponAttachmentSocketName);
        WeaponAttachment.SetRelativeLocation(vect(0,0,0));
        WeaponAttachment.SetRelativeRotation(ZeroRotator);
        WeaponAttachment.WeapMesh.SetOnlyOwnerSee(false);
        WeaponAttachment.WeapMesh.SetOwnerNoSee(false);
        WeaponAttachment.ChangeVisibility(true);

        WeaponAttachment.AttachLaserSight();

        TurretWeaponAttachment = KFWeapAttach_HRG_WarthogWeap(WeaponAttachment);
        TurretWeaponAttachment.PlayCloseAnim();
    }
}

simulated function UpdateInstigator(Pawn NewInstigator)
{
    local KFPawn_Human KFPH;

    Instigator = NewInstigator;

    TeamNum = Instigator.GetTeamNum();

    if (Weapon != none)
    {
        Weapon.Instigator = NewInstigator;
    }
    
    KFPH = KFPawn_Human(NewInstigator);
    if (KFPH != none && KFPH.WeaponSkinItemId > 0)
    {
        SetWeaponSkin(KFPH.WeaponSkinItemId);
    }
}

simulated function SetWeaponSkin(int SkinID)
{
    if (Role == Role_Authority)
    {
        WeaponSkinID = SkinID;
        bForceNetUpdate = true;
    }    
    
    if (WeaponAttachment != none)
    {
        WeaponAttachment.SetWeaponSkin(SkinID);
    }
}

simulated function UpdateWeaponUpgrade(int UpgradeIndex)
{
    if (Weapon != none)
    {
        TurretWeapon.SetWeaponUpgradeLevel(UpgradeIndex);
    }
}

/**
    Object states
 */
function SetTurretState(ETurretState State)
{
    if (CurrentState == State)
        return;

    ChangeState(State);

    CurrentState = State;
    bForceNetUpdate = true;
}

function UpdateReadyToUse(bool bReady)
{
    if (OwnerWeapon != none)
    {
        OwnerWeapon.SetReadyToUse(bReady);
    }
}

simulated function ChangeState(ETurretState State)
{
    switch(State)
    {
        case ETS_None:
            break;
        case ETS_Throw:
            GotoState('Throw');
            break;
        case ETS_Deploy:
            GotoState('Deploy');
            break;
        case ETS_TargetSearch:
            GotoState('TargetSearch');
            break;
        case ETS_Combat:
            GotoState('Combat');
            break;
        case ETS_Detonate:
            GotoState('Detonate');
            break;
        case ETS_Empty:
            GotoState('Empty');
            break;
        default:
            break;
    }
}

auto simulated state Throw
{
    simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);

        ThrowInstigatorLocation = Instigator.Location;

        if (Role == Role_Authority)
        {
            UpdateReadyToUse(false);
        }
    }

    simulated event Landed(vector HitNormal, actor FloorActor)
    {
        super.Landed(HitNormal, FloorActor);

        if (Role == ROLE_Authority)
        {
            GroundLocation = Location;
            DeployRotation = Rotation;

            SetTurretState(ETS_Deploy);
        }      
    }

    simulated event Tick(float DeltaTime)
    {
        if (deployUsingOffsetFromPlayerLocation)
        {
            // If the drone goes below the offset, prevent from falling more
            if (Location.Z < (ThrowInstigatorLocation.z - deployUsingOffsetZ))
            {
                GroundLocation = Location;
                DeployRotation = Rotation;

                SetTurretState(ETS_Deploy);
            }
        }

        super.Tick(DeltaTime);
    }
}

simulated state Deploy
{
    simulated function BeginState(name PreviousStateName)
	{
        local float AnimDuration;

		super.BeginState(PreviousStateName);

        if (TurretWeaponAttachment != none)
        {
            AnimDuration = TurretWeaponAttachment.PlayDeployAnim();
            SetTimer(AnimDuration, false, nameof(StartIdleAnim));
        }

        SetPhysics(PHYS_NONE);
 
        if (Role == ROLE_Authority)
        {
            Velocity = vect(0,0,1) * DeployZSpeed;
            UpdateReadyToUse(false);
        }
    }

	simulated event Tick(float DeltaTime)
    {
		local float CurrentHeight;
        local vector LocationNext;

        super.Tick(DeltaTime);

        // If we didn't move..
        if (VSize(Location - DeployLastLocation) < (LastMoveExpectedSize * 0.8f))
        {
            SetTurretState(ETS_TargetSearch);
            return;          
        }

        LocationNext = Location;
        LocationNext.z += Velocity.z * DeltaTime;

        // If we are going to collide stop
        if (!FastTrace(LocationNext, Location, vect(25,25,25)))
        {
            SetTurretState(ETS_TargetSearch);
            return;
        }

        DeployLastLocation = Location;
        LastMoveExpectedSize = VSize(LocationNext - Location);

        SetLocation(LocationNext);

        // Check height to change state
        CurrentHeight = Location.Z - GroundLocation.Z;
        if (CurrentHeight >= DeployHeight)
        {
            SetTurretState(ETS_TargetSearch);
        }
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        DeployedLocation = Location;

        Velocity = vect(0,0,0);

        if (Role == ROLE_Authority)
        {
            UpdateReadyToUse(true);

            if (bCanDetonateOnProximityWithAmmo)
            {
                SetTimer(0.25f, true, nameof(CheckEnemiesWithinExplosionRadius));
            }
        }
    }
}

simulated state TargetSearch
{
    simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);

        bHasSearchRandomLocation = false;

        if (Role == ROLE_Authority)
        {
            GetRandomSearchLocation();
            // bHasSearchRandomLocation=true;

            SetTimer(TimeBeforeRefreshingTargets, true, nameof(CheckForTargets));
        }
    }

    simulated function EndState(name EndStateName)
    {
        if (Role == ROLE_Authority)
        {
            ClearTimer(nameof(CheckForTargets));
            ClearTimer(nameof(GetRandomSearchLocation));
        }

        super.EndState(EndStateName);
    }

    simulated event Tick( float DeltaTime )
    {
        super.Tick(DeltaTime);

        if (Role == ROLE_Authority)
        {
            if (ReachedRotation() && !bHasSearchRandomLocation)
            {
                SetTimer( TimeIdlingWhenSearching + RandRange(MinIdlingVariation, MaxIdlingVariation), false, nameof(GetRandomSearchLocation));
                bHasSearchRandomLocation = true;
            }
        }
    }

    function GetRandomSearchLocation()
    {
        local rotator NewRotation;

        NewRotation.Yaw += RandRange(0,65536);
        bHasSearchRandomLocation = false;

        RequestRotation(NewRotation);
    }
}

simulated state Combat
{
    simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);

        /*if (Role == ROLE_Authority)
        {
            SetTimer(TimeBeforeRefreshingTargets, true, nameof(CheckForTargets));
        }*/

        if (WorldInfo.NetMode == NM_Client || WorldInfo.NetMode == NM_Standalone)
        {
            if (TurretWeaponAttachment != none)
            {
                TurretWeaponAttachment.UpdateLaserColor(true);
            }
        }
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer(nameof(CheckForTargets));

        if (Role == ROLE_Authority && TurretWeapon != none)
        {
            TurretWeapon.StopFire(0);
        }

        if (WorldInfo.NetMode == NM_Client || WorldInfo.NetMode == NM_Standalone)
        {
            if (TurretWeaponAttachment != none)
            {
                TurretWeaponAttachment.UpdateLaserColor(false);
            }
        }

        super.EndState(NextStateName);
    }

    simulated event Tick( float DeltaTime )
    {
        local vector MuzzleLoc;
        local rotator MuzzleRot;
        local rotator DesiredRotationRot;

        local vector HitLocation, HitNormal;
        local TraceHitInfo HitInfo;
        local Actor HitActor;

        local float NewAmmoPercentage;

        local bool bIsSpotted;

        if (Role == ROLE_Authority)
        {
            TurretWeapon.GetMuzzleLocAndRot(MuzzleLoc, MuzzleRot);

            NewAmmoPercentage = float(TurretWeapon.AmmoCount[0]) / TurretWeapon.MagazineCapacity[0];
            
            if (NewAmmoPercentage != CurrentAmmoPercentage)
            {
                CurrentAmmoPercentage = NewAmmoPercentage;

                if (WorldInfo.NetMode == NM_Standalone)
                {   
                    UpdateTurretMeshMaterialColor(CurrentAmmoPercentage);
                }
                else
                {
                    bNetDirty = true;
                }
            }
        }
        else
        {
            WeaponAttachment.WeapMesh.GetSocketWorldLocationAndRotation('MuzzleFlash', MuzzleLoc, MuzzleRot);
        }

        if (Role == ROLE_Authority)
        {
            if (EnemyTarget != none)  
            {
                // Trace from the Target reference to MuzzleLoc, because MuzzleLoc could be already inside physics, as it's outside the collider of the Drone!
                HitActor = Trace(HitLocation, HitNormal, EnemyTarget.Mesh.GetBoneLocation('Spine1'), MuzzleLoc,,,,TRACEFLAG_Bullet);

                // Visible by local player or team
	            /*bIsSpotted = (EnemyTarget.bIsCloakingSpottedByLP || EnemyTarget.bIsCloakingSpottedByTeam);*/
	           bIsSpotted = (EnemyTarget.bIsCloaking);

               /** Search for new enemies if current is dead, cloaked or too far, or something between the drone that's world geometry */
                if (!EnemyTarget.IsAliveAndWell() || (EnemyTarget.Health > 0) || (EnemyTarget.Health < EnemyTarget.HealthMax)
                    || (EnemyTarget.bIsCloaking && bIsSpotted == false)
                    || VSizeSq(EnemyTarget.Location - Location) > EffectiveRadius * EffectiveRadius
                    || (HitActor != none && HitActor.bWorldGeometry && KFFracturedMeshGlass(HitActor) == None))
                {
                    EnemyTarget = none;
                    CheckForTargets();

                    if (EnemyTarget == none)
                    //if ((EnemyTarget == none) || (EnemyTarget.Health <= 0) || (EnemyTarget.Health >= EnemyTarget.HealthMax))
                    {
                        SetTurretState(ETS_TargetSearch);
                        return;
                    }
                }
            }
        }
        
        if (EnemyTarget != none)
        {
            DesiredRotationRot = rotator(Normal(EnemyTarget.Mesh.GetBoneLocation('Spine1') - MuzzleLoc));
            DesiredRotationRot.Roll  = 0;

            RotateBySpeed(DesiredRotationRot);

            if (Role == ROLE_Authority && ReachedRotation())
            {
                HitActor = Trace(HitLocation, HitNormal, MuzzleLoc + vector(Rotation) * EffectiveRadius, MuzzleLoc, , , HitInfo, TRACEFLAG_Bullet);
                
                if (TurretWeapon != none)
                {
                    if (HitActor != none && HitActor.bWorldGeometry == false)
                    {
                        TurretWeapon.CurrentTarget = EnemyTarget;

                        TurretWeapon.Fire();

                        if (!TurretWeapon.HasAmmo(0))
                        {
                            SetTurretState(ETS_Empty);
                        }
                    }
                }
            }
        }

        super.Tick(DeltaTime);
    }
}

simulated state Detonate
{
    function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
        
        StopIdleSound();

        if (Role == ROLE_Authority)
        {
            TriggerExplosion();
        }
    }

    function array<float> GenerateFuseTimes()
    {
        local float i;
        local array<float> FuseTimes;

        i = 0;
        while (i < (DetonateMaxTime - DetonateMinTime))
        {
            FuseTimes.AddItem(DetonateMinTime + i);
            i += 0.1f;
        }

        return FuseTimes;      
    }

    function TriggerExplosion()
    {
        local KFExplosionActorReplicated ExploActor;
        local int i, RandomNumber;
	    local vector StartTrace, AimDir, X, Y, Z;
	    local rotator StartAimRot;
	    local class<KFProjectile> MyProjectileClass;
        local Quat R;
        local float Angle, FuseTime;
        local KFProj_HighExplosive_HRG_Paramedic Projectile;
        local array<float> FuseTimes;
        //local GameExplosion ExplosionToUse;
        //local KFPawn PawnInstigator;
        //local KFPerk Perk;
        //local float OriginalDamageRadiusDroneExplosion;

        // Shoot grenades around

        MyProjectileClass = class'KFProj_HighExplosive_HRG_Paramedic';

        if( Role == ROLE_Authority || (MyProjectileClass.default.bUseClientSideHitDetection
            && MyProjectileClass.default.bNoReplicationToInstigator && Instigator != none
            && Instigator.IsLocallyControlled()) )
        {
            TurretWeapon.CurrentTarget = none;

            TurretWeapon.GetMuzzleLocAndRot(StartTrace, StartAimRot);

            StartAimRot.Pitch = 0.f;
            StartAimRot.Roll = 0.f;

            GetAxes(StartAimRot, X, Y, Z);

            Angle = 360.f / DetonateNumberOfProjectiles;

            // Randomize a vector so the values are not repeated
            FuseTimes = GenerateFuseTimes();

            for (i = 0; i < DetonateNumberOfProjectiles; ++i)
            {
                // Generate different angle for each one
                R = QuatFromAxisAndAngle(Z, Angle * DegToRad * i);

                AimDir = QuatRotateVector(R, vector(StartAimRot));
                AimDir.Z = 0.f;

                // Generate different distance from start location for each one
                TurretWeapon.CurrentDistanceProjectile = DetonateMinimumDistance + Rand(DetonateMaximumDistance - DetonateMinimumDistance);

                Projectile = KFProj_HighExplosive_HRG_Paramedic(TurretWeapon.SpawnProjectile(class'KFProj_HighExplosive_HRG_Paramedic', StartTrace, AimDir));
                
                // Setup as timed explosive and set the timer..

                FuseTime = DetonateMinTime;

                if (FuseTimes.Length == 0)
                {
                    FuseTimes = GenerateFuseTimes();
                }

                if (FuseTimes.Length != 0)
                {
                    RandomNumber = Rand(FuseTimes.Length);

                    FuseTime = FuseTimes[RandomNumber];

                    FuseTimes.Remove(RandomNumber, 1);
                }

                Projectile.SetupDetonationTimer(FuseTime);
            }

            TurretWeapon.CurrentDistanceProjectile = -1.f;
        }

        // explode using the given template
        ExploActor = Spawn(class'KFExplosionActorReplicated', TurretWeapon,, Location, Rotation,, true);
        if (ExploActor != None)
        {
            ExploActor.InstigatorController = Instigator.Controller;
            ExploActor.Instigator = Instigator;
            ExploActor.bIgnoreInstigator = true;

            ExploActor.Explode(ExplosionTemplate);
        }
        Destroy();
    }
}

simulated state Empty
{
    simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
        
        if (WorldInfo.NetMode == NM_Client || WorldInfo.NetMode == NM_Standalone)
        {   
            // Attach No Ammo VFX
            if (NoAmmoFX == none)
            {
                NoAmmoFX = WorldInfo.MyEmitterPool.SpawnEmitter(NoAmmoFXTemplate, Location);                                              
            }

            // Play dry sound 2 or 3 times
            SetTimer(0.5f, false, 'PlayEmptySound1');
            SetTimer(1.f, false, 'PlayEmptySound2');
            SetTimer(1.5f, false, 'PlayEmptySound3');

            // When sound finish play animation
            SetTimer(2.f, false, 'PlayEmptyState');

            UpdateTurretMeshMaterialColor(0.0f);
        }
        
        if (Role == ROLE_Authority && !bCanDetonateOnProximityWithAmmo)
        {
            SetTimer(0.25f, true, nameof(CheckEnemiesWithinExplosionRadius));
        }
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
    }
}

// We can't use the same delegate, hence we create 3 functions..

simulated function PlayEmptySound1()
{
    PlaySoundBase(DroneDryFire);
}

simulated function PlayEmptySound2()
{
    PlaySoundBase(DroneDryFire);
}

simulated function PlayEmptySound3()
{
    PlaySoundBase(DroneDryFire);
}

simulated function PlayEmptyState()
{
    if (TurretWeaponAttachment != none)
    {
		StopIdleSound();

        TurretWeaponAttachment.PlayEmptyState();
    }
}

simulated function StopIdleSound()
{
    FlyAkComponent.StopEvents();
}

function CheckForTargets()
{
    local KFPawn_Human CurrentTarget;
    local TraceHitInfo   HitInfo;    

    local float CurrentDistance;
    local float Distance;

    local vector MuzzleLoc;
    local rotator MuzzleRot;

	local vector HitLocation, HitNormal;
    local Actor HitActor;

    local bool bIsSpotted;

    if (EnemyTarget != none)
    {
        CurrentDistance = VSizeSq(Location - EnemyTarget.Location);
    }
    else
    {
        CurrentDistance = 9999.f;
    }

    TurretWeapon.GetMuzzleLocAndRot(MuzzleLoc, MuzzleRot);
    
    foreach CollidingActors(class'KFPawn_Human', CurrentTarget, EffectiveRadius, Location, true,, HitInfo)
    {
        // Visible by local player or team
	    /*bIsSpotted = (CurrentTarget.bIsCloakingSpottedByLP || CurrentTarget.bIsCloakingSpottedByTeam);*/
	    bIsSpotted = (CurrentTarget.bIsCloaking);

        if (!CurrentTarget.IsAliveAndWell()
            || (CurrentTarget.bIsCloaking && bIsSpotted == false))
        {
            continue;
        }

        // Trace from the Target reference to MuzzleLoc, because MuzzleLoc could be already inside physics, as it's outside the collider of the Drone!
        HitActor = Trace(HitLocation, HitNormal, CurrentTarget.Mesh.GetBoneLocation('Spine1'), MuzzleLoc,,,,TRACEFLAG_Bullet);

        if (HitActor == none || (HitActor.bWorldGeometry && KFFracturedMeshGlass(HitActor) == None) )
        {
            continue;
        }

        Distance = VSizeSq(Location - CurrentTarget.Location);

        if (EnemyTarget == none)
        {
            EnemyTarget = CurrentTarget;
            CurrentDistance = Distance;
        }
        else if (CurrentDistance > Distance)
        {
            EnemyTarget = CurrentTarget;
            CurrentDistance = Distance;
        }
    }
    
    if (EnemyTarget != none)
    {
        SetTurretState(ETS_Combat);
    }
}

////////////////////////////////////////////////////////////

simulated event Destroyed()
{
    local KFWeap_HRG_Paramedic WeapOwner;

    StopIdleSound();

    WeapOwner = KFWeap_HRG_Paramedic(Owner);

    if (WeapOwner != none)
    {
        WeapOwner.RemoveDeployedTurret(,self);
    }

    ClearTimer(nameof(CheckEnemiesWithinExplosionRadius));

    if (NoAmmoFX != none)
    {
        NoAmmoFX.KillParticlesForced();
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(NoAmmoFX);
		NoAmmoFX = none;
    }

    super.Destroyed();
}

simulated function CheckEnemiesWithinExplosionRadius()
{
    local KFPawn_Human KFPM;
    local Vector CheckExplosionLocation;

    CheckExplosionLocation = Location;
    CheckExplosionLocation.z -= DeployHeight * 0.5f;

    if (CheckExplosionLocation.z < GroundLocation.z)
    {
        CheckExplosionLocation.z = GroundLocation.z;
    }

    //DrawDebugSphere(CheckExplosionLocation, ExplosiveRadius, 10, 255, 255, 0 );

    foreach CollidingActors(class'KFPawn_Human', KFPM, ExplosiveRadius, CheckExplosionLocation, true,,)
    {
        if(KFPM != none && KFPM.IsAliveAndWell())
        {
            SetTurretState(ETS_Detonate);
            return;
        }
    }
}

simulated function StartIdleAnim()
{
    if (TurretWeaponAttachment != none)
    {
        TurretWeaponAttachment.PlayIdleAnim();

        FlyAkComponent.PlayEvent(DroneFlyingStartAudio, true, true);
    }
}

simulated event Tick(float DeltaTime)
{
    local rotator NewRotationRate;

    /** This gets reset somehow and causes issues with the rotation */
    RotationRate = NewRotationRate;

    if (bRotating)
    {
        UpdateRotation(DeltaTime);
    }

    super.Tick(DeltaTime);
}

simulated function UpdateRotation(float DeltaTime)
{
    local rotator RotationDiff;
    local rotator RotationStep;
    local rotator NewRotation;
    local rotator RotationSpeed;
    local int Sign;

    if (bRotating)
    {
        if (bRotatingByTime) /** Rotate in an amount of time */
        {
            if(RotationAlpha < RotationTime)
            {
                RotationAlpha += DeltaTime;
            
                RotationStep = RLerp(RotationStart, TargetRotation, FMin(RotationAlpha / RotationTime, 1.0f), true);
                RotationStep.Roll = 0.0f;

                RotationStep.Yaw = RotationStep.Yaw % 65536;
                RotationStep.Pitch = RotationStep.Pitch % 65536;
                
                if (RotationStep.Yaw < 0)
                    RotationStep.Yaw += 65536;

                if (RotationStep.Pitch < 0)
                    RotationStep.Pitch += 65536;

                SetRotation(RotationStep);
            }
            else
            {
                bRotating = false;   
            }
        }
        else /** Rotate By Speed */
        {
            RotationSpeed = CurrentState == ETS_Combat ? CombatRotationVel : AimRotationVel;

            RotationDiff = TargetRotation - Rotation;

            RotationDiff.Yaw   = NormalizeRotAxis(RotationDiff.Yaw);
            RotationDiff.Pitch = NormalizeRotAxis(RotationDiff.Pitch);
            RotationDiff.Roll  = NormalizeRotAxis(RotationDiff.Roll);

            Sign = RotationDiff.Yaw >= 0? 1 : -1;
            RotationStep.Yaw = RotationSpeed.Yaw * DeltaTime * Sign;
            if (Abs(RotationStep.Yaw) > Abs(RotationDiff.Yaw))
            {
                RotationStep.Yaw = RotationDiff.Yaw;
            }

            Sign = RotationDiff.Pitch >= 0? 1 : -1;
            RotationStep.Pitch = RotationSpeed.Pitch * DeltaTime * Sign;
            if (Abs(RotationStep.Pitch) > Abs(RotationDiff.Pitch))
            {
                RotationStep.Pitch = RotationDiff.Pitch;
            }

            RotationStep.Roll = 0.0f;

            NewRotation = Rotation + RotationStep;
            NewRotation.Yaw   = NewRotation.Yaw % 65536;
            NewRotation.Pitch = NewRotation.Pitch % 65536;
            
            if (NewRotation.Yaw < 0)
                NewRotation.Yaw += 65536;

            if (NewRotation.Pitch < 0)
                NewRotation.Pitch += 65536;

            SetRotation(NewRotation);

            if (ReachedRotation())
            {
                bRotating = false;
            }
        }
    }
}

simulated function RotateByTime(rotator NewRotation, float Time)
{
    if (NewRotation != Rotation)
    {
        RotationStart   = Rotation;
        TargetRotation  = NewRotation;
        RotationAlpha   = 0.0;
        RotationTime    = Time;
        bRotating       = true;
        bRotatingByTime = true;
    }
}

simulated function RotateBySpeed(rotator NewRotation)
{
    TargetRotation  = NewRotation;
    RotationAlpha   = 0.0f;
    RotationTime    = 0.0f;
    bRotating       = true;
    bRotatingByTime = false;
}

simulated event byte ScriptGetTeamNum()
{
	return TeamNum;
}

simulated function RequestRotation(rotator NewRotation)
{
    if (Role == ROLE_Authority)
    {
        /** Set rotation the same as its going to be replicated **/
        ReplicatedRotation.Yaw   = ((NewRotation.Yaw >> 8) & 255) << 8;
        ReplicatedRotation.Pitch = ((NewRotation.Pitch >> 8) & 255) << 8;
        
        bForceNetUpdate = true;
    }

    RotateBySpeed(ReplicatedRotation);
}

simulated function bool ReachedRotation(int DeltaError = 2000)
{
    local int YawDiff;
    YawDiff = Abs((TargetRotation.Yaw & 65535) - (Rotation.Yaw & 65535));
    return (YawDiff < DeltaError) || (YawDiff > 65535 - DeltaError);
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
}

simulated function TakeRadiusDamage(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f,
	optional bool		bAdjustRadiusDamage=true
)
{}

function bool CanAITargetThisPawn(Controller TargetingController)
{
    return false;
}

simulated function bool CanInteractWithPawnGrapple()
{
	return false;
}

simulated function bool CanInteractWithZoneVelocity()
{
	return false;
}

simulated function UpdateTurretMeshMaterialColor(float Value)
{
    if (TurretWeaponAttachment == none)
    {
        return;
    }

    if (TurretAttachMIC == none)
    {
        TurretAttachMIC = TurretWeaponAttachment.WeapMesh.CreateAndSetMaterialInstanceConstant(`AUTOTURRET_MIC_INDEX);
    }
    
    if (TurretAttachMIC != none)
    {
        TurretAttachMIC.SetScalarParameterValue(TransitionParamName, 1.0f - Value);
		TurretAttachMIC.SetScalarParameterValue(EmptyParamName, Value == 0.0f ? 1 : 0);
    }
}

/** No AutoAim */
simulated function bool GetAutoTargetBones(out array<name> WeakBones, out array<name> NormalBones)
{
	return false;
}

simulated function SetWeaponAmbientSound(AkEvent NewAmbientSound, optional AkEvent FirstPersonAmbientSound)
{
    super.SetWeaponAmbientSound(NewAmbientSound, FirstPersonAmbientSound);

    if (WorldInfo.NetMode == NM_DedicatedServer)
    {
        TurretWeaponAmbientSound = NewAmbientSound;
        bNetDirty = true;
    }
}

/**
 * This function's responsibility is to signal clients that non-instant hit shot
 * has been fired. Call this on the server and local player.
 *
 * Network: Server and Local Player
 */
simulated function IncrementFlashCount(Weapon InWeapon, byte InFiringMode)
{
    Super.IncrementFlashCount(InWeapon, InFiringMode);
    AutoTurretFlashCount = FlashCount;
    // bNetDirty = true;
    bForceNetUpdate = true;
}

simulated function ClearFlashCount(Weapon InWeapon)
{
    Super.ClearFlashCount(InWeapon);

    AutoTurretFlashCount = FlashCount;
    bForceNetUpdate=true;
}

defaultproperties
{
    bCollideComplex=TRUE
	Begin Object Name=CollisionCylinder
		CollisionRadius=40
		CollisionHeight=30
        bIgnoreRadialImpulse=true
        BlockNonZeroExtent=true
		CollideActors=true
		BlockActors=false
	End Object
	CylinderComponent=CollisionCylinder

	Begin Object Class=SkeletalMeshComponent Name=TurretMesh0
		SkeletalMesh=SkeletalMesh'wep_3p_hrg_warthog_mesh.drone_SM'
		PhysicsAsset=PhysicsAsset'wep_3p_hrg_warthog_mesh.drone_SM_Physics'
		BlockNonZeroExtent=false
		CastShadow=false
        bIgnoreRadialImpulse=true

    End Object
    Components.Add(TurretMesh0)
    TurretMesh=TurretMesh0
    Mesh=TurretMesh0

    Begin Object Class=KFGameExplosion Name=ExploTemplate0
		Damage=300
	    DamageRadius=300
		DamageFalloffExponent=0.5f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_HRG_Paramedic'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_HRG_Warthog_ARCH.HRG_Warthog_Explosion'
		ExplosionSound=AkEvent'WW_WEP_HRG_Warthog.Play_WEP_HRG_Warthog_Alt_Fire_3P'

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=900
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true

        bIgnoreInstigator=true
        ActorClassToIgnoreForDamage = class'KFPawn_Human'
	End Object
	ExplosionTemplate=ExploTemplate0

    // sounds
	Begin Object Class=AkComponent name=FlyAkComponent0
		BoneName=dummy
		bStopWhenOwnerDestroyed=true
		bForceOcclusionUpdateInterval=true
		OcclusionUpdateInterval=0.2f
	End Object
    FlyAkComponent=FlyAkComponent0
    Components.Add(FlyAkComponent0)

    CurrentState=ETS_None
	DeployZSpeed=800.0f
	DeployHeight=200.0f

    deployUsingOffsetFromPlayerLocation=true
    deployUsingOffsetZ = 100.f

    EffectiveRadius=1500.0f
    ExplosiveRadius=100.0f

    WeaponDefinition=class'SnWeapon.KFWeapDef_HRG_ParamedicWeapon'

    TimeBeforeRefreshingTargets=0.5f
    TimeIdlingWhenSearching = 1.0f
    MinIdlingVariation = -0.5f
    MaxIdlingVariation = 1.0f

    // Rotation speed per second
    AimRotationVel    =(Pitch=16384,Yaw=32768,Roll=0)
    CombatRotationVel =(Pitch=16384,Yaw=32768,Roll=0)
    
    RotationAlpha = 0.0f
    RotationTime  = 0.0f
    bRotating     = false
    bHasSearchRandomLocation = false

    EmptyPitch=0    //-10000

    bRunPhysicsWithNoController=true;

    bCanBeDamaged=false
    TeamNum=0

    bRotatingByTime=false
    RemoteRole = ROLE_SimulatedProxy
    
    bCanDetonateOnProximityWithAmmo=false
    bIgnoreForces=true

    bIsTurret=true

    NoAmmoFX=none

    bAlwaysRelevant=true

    AutoTurretFlashCount=0

    DetonateNumberOfProjectiles=5
    DetonateMinimumDistance=200 // cm
    DetonateMaximumDistance=700 // cm
    DetonateMinTime=1f
    DetonateMaxTime=1.4f

    DeployLastLocation=(X=-9999.f, Y=-9999.f, Z=-9999.f)
    LastMoveExpectedSize= 0.f
}
