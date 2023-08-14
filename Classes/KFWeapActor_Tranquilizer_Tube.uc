class KFWeapActor_Tranquilizer_Tube extends Actor;

//Visual tube mesh that embeds into the enemy
var() StaticMeshComponent TubeMesh;

//Blood spray looping FX
var() ParticleSystemComponent BloodSprayFX;

//Blood SFX
var AkComponent BleederSFXComponent;
var() AkEvent BleederSFX;
var() AkEvent BleederSFXEnd;

//Lifetime until destroy is called
var float Lifetime;

//Size in the X direction - @TODO - get this at runtime
var float TubeLength;

//Destroy Delay
var float DestroyDelay;
var bool bStopTick;

event PostBeginPlay()
{
    super.PostBeginPlay();

    BleederSFXComponent.PlayEvent(BleederSFX, true);
    Lifetime = class'KFDT_Toxic_Tranquilizer'.default.DoT_Duration;
    SetTimer(Lifetime, false, nameof(TearDown));
}

function TearDown()
{
    BloodSprayFX.DeactivateSystem();
	BleederSFXComponent.PlayEvent(BleederSFXEnd, true);
	bStopTick = true;

	//Because Mark wants his sound things to fade
	SetTimer(DestroyDelay, false, nameof(ActualDestroy));
}

function ActualDestroy()
{
	Destroy();
}

event Tick(float DeltaTime)
{
    local Vector NewRelativeLocation;
    super.Tick(DeltaTime);

	if (!bStopTick)
	{
		//Push the actor into the body based on relative rotation
		NewRelativeLocation = RelativeLocation + (Vector(RelativeRotation) * (TubeLength / Lifetime) * DeltaTime);
		SetRelativeLocation(NewRelativeLocation);
	}
}

defaultproperties
{
    Begin Object Class=StaticMeshComponent Name=Mesh0
        StaticMesh=StaticMesh'FX_Projectile_MESH.FX_Projectile_Leech'
    End Object
    Components.Add(Mesh0)
    TubeMesh=Mesh0

    Begin Object Class=ParticleSystemComponent Name=PSC0
        Template=ParticleSystem'WEP_Bleeder_EMIT.FX_Bleeder_Projectile'
        bAutoActivate=true
    End Object
    Components.Add(PSC0)
    BloodSprayFX=PSC0

    Begin Object Class=AkComponent name=BleederOneShotSFX
    	BoneName=dummy // need bone name so it doesn't interfere with default PlaySoundBase functionality
    	bStopWhenOwnerDestroyed=true
    End Object
    BleederSFXComponent=BleederOneShotSFX
    Components.Add(BleederOneShotSFX)

    TubeLength=10

	bStopTick=false
	DestroyDelay=0.5
    BleederSFX=none
    BleederSFXEnd=none
}