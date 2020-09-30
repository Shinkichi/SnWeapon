class SnWeaponMut extends KFMutator;

function InitMutator(string Options, out string ErrorMessage)
{
	super.InitMutator( Options, ErrorMessage );
	`log("SnWeapon mutator initialized");
}
