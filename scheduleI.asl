state("Schedule I")
{
    // Player                   0x0377DA68, 0xB8, 0x18
    // Find via inventory item quantity
    bool	introComplete	    : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x280;  // Tracks if in prologue
    ulong	currentVehicle	    : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x208;  // Pointer towards vehicle player is currently in. 0 if not in a vehicle.
    ulong	currentProperty	    : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x268;  // Pointer towards property player is currently in. 0 if not in property.
    bool	currentPropertyRV	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x268, 0x164; // OwnedByDefault flag - assume for RV only? 0x140, 0x14 for property name
    bool	sleeping	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x258;  // Player sleeping

	ulong 	inventory1	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x20, 0x10, 0x18, 0x14; // I hate this, find better way.
	ulong  	inventory1container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x20, 0x10, 0x40, 0x14;
	ulong  	inventory2	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x28, 0x10, 0x18, 0x14;
	ulong  	inventory2container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x28, 0x10, 0x40, 0x14;
    ulong  	inventory3	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x30, 0x10, 0x18, 0x14;
	ulong  	inventory3container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x30, 0x10, 0x40, 0x14;
    ulong  	inventory4	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x38, 0x10, 0x18, 0x14;
	ulong  	inventory4container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x38, 0x10, 0x40, 0x14;
    ulong  	inventory5	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x40, 0x10, 0x18, 0x14;
	ulong  	inventory5container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x40, 0x10, 0x40, 0x14;
    ulong  	inventory6	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x48, 0x10, 0x18, 0x14;
	ulong  	inventory6container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x48, 0x10, 0x40, 0x14;
    ulong  	inventory7	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x50, 0x10, 0x18, 0x14;
	ulong  	inventory7container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x50, 0x10, 0x40, 0x14;
    ulong  	inventory8	        : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x58, 0x10, 0x18, 0x14;
	ulong  	inventory8container	: "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x58, 0x10, 0x40, 0x14;

	float	money	            : "GameAssembly.dll", 0x0377DA68, 0xB8, 0x18, 0x2A0, 0x60, 0x10, 0x38; // Paper money

    // TimeManager              0x038AEC90, 0XB8, 0X0
    // Find via game clock (as shown on phone), which is an int representing 24 hour time
    float   IGT                 : "GameAssembly.dll", 0x038AEC90, 0xB8, 0x0, 0x140; // In game time

    // PlayerCamera             0x0377DB38, 0xB8, 0x10
    // Find via cameraControl bool - 1 = can look, 0 = camera frozen
    bool    cameraControl       : "GameAssembly.dll", 0x0377DB38, 0xB8, 0x10, 0xB8; // Whether player can control camera
    
    // MoneyManager             0x038AE360, 0xB8, 0x0, 0x128;
    float   moneyonline         : "GameAssembly.dll", 0x038AE360, 0xB8, 0x0, 0x128; // Online balance
}

startup
{
	vars.completedSplits = new List<string>();
	vars.shouldStart = false;

    // split logic vars
    vars.methReceived = false;
    vars.moneyWhenMethReceived = 0.0;

	settings.Add("sleep",       true, "Split on bed during prologue (prologue% complete)");
    settings.Add("cashmoney",   false, "Split on first cash received (made a sale or picked up stash money)");
    settings.Add("methDeal",    false, "Split when making money after holding meth (meth% complete)");
	settings.Add("speedgrow",   false, "Split on receiving speed grow");
	settings.Add("baggie",      false, "Split on receiving og kush baggie");
    settings.Add("vehicle",     false, "Split on first entering a vehicle");
    settings.Add("pseudo",      false, "Split on receiving pseudo during prologue");
    settings.Add("property",    false, "Split on first time stepping into any owned property that isn't the RV");
    settings.Add("badpseudo",   false, "Split on first time receiving low-quality pseudo");
    settings.Add("chemlab",     false, "Split on first time buying chemistry station");
    settings.Add("totalmoney",  false, "Split when combined money reaches a certain value (default: 2079 for meth%)");
    

    // ===============
    // Player set vars
    // ===============

    vars.moneySplitValue = 2079; // the value that combined offline and online balance should be above to cause a split

}

start
{
    // introComplete is trigger for main game
    // cameraControl is trigger for prologue
	if ( vars.shouldStart && (current.introComplete == true || current.cameraControl == true) )
	{
        vars.shouldStart = false;
		return true;
	}

    // make sure triger events happening before 10s IGT don't start timer. Prevents main game from starting early.
    if (current.IGT > 10 && current.IGT < 11)
	{
		vars.shouldStart = true;
	}
    else if (current.IGT < 10)
    {
        vars.shouldStart = false;
    }
	return false;
}

onReset
{
	vars.completedSplits.Clear();
	vars.shouldStart = false;
}

// Not currently used, as runs are timed using real time. Remove // and set comparison to game time if needed
gameTime
{
    // return TimeSpan.FromSeconds(current.IGT);
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
	
    // player receives bag with ogkush
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

    // regular pseudo for prologue
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

    // low quality pseudo for meth%
    if ((current.inventory1 == 0x710077006F006C
        || current.inventory2 == 0x710077006F006C
        || current.inventory3 == 0x710077006F006C
        || current.inventory4 == 0x710077006F006C
        || current.inventory5 == 0x710077006F006C
        || current.inventory6 == 0x710077006F006C
        || current.inventory7 == 0x710077006F006C
        || current.inventory8 == 0x710077006F006C)
        && !vars.completedSplits.Contains("badpseudo")
        && settings["badpseudo"])
	{
		vars.completedSplits.Add("badpseudo");
		return true;
    }

    // low quality pseudo for meth%
    if ((current.inventory1 == 0x6D006500680063
        || current.inventory2 == 0x6D006500680063
        || current.inventory3 == 0x6D006500680063
        || current.inventory4 == 0x6D006500680063
        || current.inventory5 == 0x6D006500680063
        || current.inventory6 == 0x6D006500680063
        || current.inventory7 == 0x6D006500680063
        || current.inventory8 == 0x6D006500680063)
        && !vars.completedSplits.Contains("chemlab")
        && settings["chemlab"])
	{
		vars.completedSplits.Add("chemlab");
		return true;
    }

    // check if player has received meth. If so, set flag so we can split once player's money increased
    if ((current.inventory1 == 0x6800740065006D
        || current.inventory2 == 0x6800740065006D
        || current.inventory3 == 0x6800740065006D
        || current.inventory4 == 0x6800740065006D
        || current.inventory5 == 0x6800740065006D
        || current.inventory6 == 0x6800740065006D
        || current.inventory7 == 0x6800740065006D
        || current.inventory8 == 0x6800740065006D)
        && !vars.methReceived
        && !vars.completedSplits.Contains("methDeal")
        && settings["methDeal"])
	{
        print("holding");
		vars.methReceived = true;
        vars.moneyWhenMethReceived = current.money;
    }

    if (vars.methReceived == true && (current.money > vars.moneyWhenMethReceived) && settings["methDeal"])
    {
        vars.methReceived = false;
        vars.completedSplits.Add("methDeal");
        return true;
    }

    // player enters any vehicle
    if (current.currentVehicle != 0 && !vars.completedSplits.Contains("vehicle") && settings["vehicle"])
    {
        vars.completedSplits.Add("vehicle");
        return true;
    }

    // player walks into any owned property that isn't the RV
    if (current.currentProperty != 0 && !current.currentPropertyRV && !vars.completedSplits.Contains("property") && settings["property"])
    {
        vars.completedSplits.Add("property");
        return true;
    }

    // Split to end prologue
    if (current.sleeping && !current.introComplete && !vars.completedSplits.Contains("sleep") && settings["sleep"])
    {
        vars.completedSplits.Add("sleep");
        return true;
    }

    if (((current.money + current.moneyonline) > vars.moneySplitValue) && !vars.completedSplits.Contains("totalmoney") && settings["totalmoney"])
    {
        vars.completedSplits.Add("totalmoney");
        return true;
    }
}

