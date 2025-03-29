state("Schedule I")
{
	bool	introComplete	: "GameAssembly.dll", 0x0374AA60, 0x20, 0x98, 0x18, 0x280;
	ulong 	inventory1	: "GameAssembly.dll", 0x0374AA60, 0x20, 0x98, 0x18, 0x2A0, 0x20, 0x10, 0x18, 0x14;
	ulong  	inventory1container	: "GameAssembly.dll", 0x0374AA60, 0x20, 0x98, 0x18, 0x2A0, 0x20, 0x10, 0x40,0x14;
	ulong  	inventory2	: "GameAssembly.dll", 0x0374AA60, 0x20, 0x98, 0x18, 0x2A0, 0x28, 0x10, 0x18, 0x14;
	ulong  	inventory2container	: "GameAssembly.dll", 0x0374AA60, 0x20, 0x98, 0x18, 0x2A0, 0x28, 0x10, 0x40,0x14;
	float	money	: "GameAssembly.dll", 0x0374AA60, 0x20, 0x98, 0x18, 0x2A0, 0x60, 0x10, 0x38;
}

startup
{
	vars.completedSplits = new List<string>();
	vars.shouldStart = false;

	settings.Add("cashmoney", true, "Split on first cash received");
	settings.Add("speedgrow", true, "Split on receiving speed grow");
	settings.Add("baggie", true, "Split on receiving og kush baggie");
}

start
{
	if (vars.shouldStart)
	{
		return current.introComplete;
	}
	if (current.introComplete == false)
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

split
{
	if ( current.money > 0.5 && !vars.completedSplits.Contains("money") && settings["cashmoney"])
	{
		vars.completedSplits.Add("money");
		return true;
	}

	if ( (current.inventory1 == 0x65006500700073 || current.inventory2 == 0x65006500700073) && !vars.completedSplits.Contains("speedgrow")  && settings["speedgrow"] )
	{
		vars.completedSplits.Add("speedgrow");
		return true;
	}
	
	if ( ( ( current.inventory1 == 0x75006B0067006F && current.inventory1container == 0x67006700610062 ) || ( current.inventory2 == 0x75006B0067006F && current.inventory2container == 0x67006700610062 ) ) && !vars.completedSplits.Contains("baggie")  && settings["baggie"] )
	{
		vars.completedSplits.Add("baggie");
		return true;
	}	
}