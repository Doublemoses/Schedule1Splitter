state("Schedule I")
{
    // 0x0376E808, 0xB8, 0x18   Player
    bool	introComplete	    : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x280;  // Tracks if in prologue
    ulong	currentVehicle	    : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x208;  // Pointer towards vehicle player is currently in. 0 if not in a vehicle.
    bool	sleeping	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x258;  // Player sleeping

	ulong 	inventory1	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x20, 0x10, 0x18, 0x14; // I hate this, find better way.
	ulong  	inventory1container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x20, 0x10, 0x40, 0x14;
	ulong  	inventory2	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x28, 0x10, 0x18, 0x14;
	ulong  	inventory2container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x28, 0x10, 0x40, 0x14;
    ulong  	inventory3	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x30, 0x10, 0x18, 0x14;
	ulong  	inventory3container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x30, 0x10, 0x40, 0x14;
    ulong  	inventory4	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x38, 0x10, 0x18, 0x14;
	ulong  	inventory4container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x38, 0x10, 0x40, 0x14;
    ulong  	inventory5	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x40, 0x10, 0x18, 0x14;
	ulong  	inventory5container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x40, 0x10, 0x40, 0x14;
    ulong  	inventory6	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x48, 0x10, 0x18, 0x14;
	ulong  	inventory6container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x48, 0x10, 0x40, 0x14;
    ulong  	inventory7	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x50, 0x10, 0x18, 0x14;
	ulong  	inventory7container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x50, 0x10, 0x40, 0x14;
    ulong  	inventory8	        : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x58, 0x10, 0x18, 0x14;
	ulong  	inventory8container	: "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x58, 0x10, 0x40, 0x14;

	float	money	            : "GameAssembly.dll", 0x0376E808, 0xB8, 0x18, 0x2A0, 0x60, 0x10, 0x38; // Paper money

    // 0x0389ECD8, 0XB8, 0X0    TimeManager
    float   IGT                 : "GameAssembly.dll", 0x0389ECD8, 0xB8, 0x0, 0x140; // In game time

    // 0x0376E8D8, 0xB8, 0x10   PlayerCamera
    bool    cameraControl       : "GameAssembly.dll", 0x0376E8D8, 0xB8, 0x10, 0xB8; // Whether player can control camera
}

startup
{
	vars.completedSplits = new List<string>();
	vars.shouldStart = false;

	settings.Add("cashmoney", true, "Split on first cash received");
	settings.Add("speedgrow", true, "Split on receiving speed grow");
	settings.Add("baggie", true, "Split on receiving og kush baggie");
    settings.Add("vehicle", true, "Split on first entering a vehicle");

    settings.Add("pseudo", true, "Split on receiving pseudo during prologue");
    settings.Add("sleep", true, "Split on first sleep during prologue");
}

start
{
	if ( vars.shouldStart && (current.introComplete == true || current.cameraControl == true) )
	{
		return true;
	}

    if (current.IGT > 5 && current.IGT < 6) // Prologue IGT starts at ~5 for some reason
	{
		vars.shouldStart = true;
	}
	return false;
}

onReset
{
	vars.completedSplits.Clear();
	vars.shouldStart = false;
}

// Not currently used, as runs are timed using real time, but might as well add it
gameTime
{
    return TimeSpan.FromSeconds(current.IGT);
}

split
{
	if (current.money > 0.5 && !vars.completedSplits.Contains("money") && settings["cashmoney"])
	{
		vars.completedSplits.Add("money");
		return true;
	}

	if ((current.inventory1 == 0x65006500700073 || current.inventory2 == 0x65006500700073) && !vars.completedSplits.Contains("speedgrow")  && settings["speedgrow"])
	{
		vars.completedSplits.Add("speedgrow");
		return true;
	}
	
    if ( ( ( current.inventory1 == 0x75006B0067006F && current.inventory1container == 0x67006700610062 )
        || ( current.inventory2 == 0x75006B0067006F && current.inventory2container == 0x67006700610062 )
        || ( current.inventory3 == 0x75006B0067006F && current.inventory3container == 0x67006700610062 )
        || ( current.inventory4 == 0x75006B0067006F && current.inventory4container == 0x67006700610062 )
        || ( current.inventory5 == 0x75006B0067006F && current.inventory5container == 0x67006700610062 )
        || ( current.inventory6 == 0x75006B0067006F && current.inventory6container == 0x67006700610062 )
        || ( current.inventory7 == 0x75006B0067006F && current.inventory7container == 0x67006700610062 )
        || ( current.inventory8 == 0x75006B0067006F && current.inventory8container == 0x67006700610062 ) )
        && !vars.completedSplits.Contains("baggie")
        && settings["baggie"])
	{
		vars.completedSplits.Add("baggie");
		return true;
    }

    if ((current.inventory1 == 0x75006500730070
        || current.inventory2 == 0x75006500730070
        || current.inventory3 == 0x75006500730070
        || current.inventory4 == 0x75006500730070
        || current.inventory5 == 0x75006500730070
        || current.inventory6 == 0x75006500730070
        || current.inventory7 == 0x75006500730070
        || current.inventory8 == 0x75006500730070)
        && !current.introComplete
        && !vars.completedSplits.Contains("pseudo")
        && settings["pseudo"])
	{
		vars.completedSplits.Add("pseudo");
		return true;
    }

    if (current.currentVehicle != 0  && !vars.completedSplits.Contains("vehicle") && settings["vehicle"])
    {
        vars.completedSplits.Add("vehicle");
        return true;
    }

    if (current.sleeping && !current.introComplete && !vars.completedSplits.Contains("sleep") && settings["sleep"])
    {
        vars.completedSplits.Add("sleep");
        return true;
    }
}

