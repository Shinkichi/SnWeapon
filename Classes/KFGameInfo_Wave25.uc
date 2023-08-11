class KFGameInfo_Wave25 extends KFGameInfo_Survival;

/** Scale to use against WaveTotalAI to determine full wave size */
function float GetTotalWaveCountScale()
{
	local float WaveScale;

	WaveScale = 2;

	return WaveScale;
}

defaultproperties
{
}