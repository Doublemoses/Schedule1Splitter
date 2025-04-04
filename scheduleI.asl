state("Schedule I")
{

    bool	introComplete	    : "GameAssembly.dll", 0x0377EAD8, 0xB8, 0x18, 0x280;  // Tracks if in prologue
	float	money	            : "GameAssembly.dll", 0x0377EAD8, 0xB8, 0x18, 0x2A0, 0x60, 0x10, 0x38; // Paper money
    float   moneyonline         : "GameAssembly.dll", 0x038AF4F8, 0xB8, 0x0, 0x128;         // MoneyManager -> onlineBalance







    ulong   playerBase          : "GameAssembly.dll", 0x0377EAD8, 0xB8, 0x18;               // Player
    ulong   questManagerBase    : "GameAssembly.dll", 0x03832438, 0xB8, 0x20;               // QuestManager
    ulong   levelManagerBase    : "GameAssembly.dll", 0x038AF158, 0xB8, 0x0;                // LevelManager

    bool    hasCameraControl    : "GameAssembly.dll", 0x0377EBA8, 0xB8, 0x10, 0xB8;         // PlayerCamera -> Whether player can control camera
    float   gameTime            : "GameAssembly.dll", 0x038AFE18, 0xB8, 0x0, 0x140;         // TimeManager -> game time

    ulong   propertyList        : "GameAssembly.dll", 0x037AA8C8, 0xB8, 0x20, 0x10;         // List containing all properties
    

}

startup
{
    // Splitter state vars
	vars.completedSplits = new List<string>();
	vars.shouldStart = false;

    // Split logic vars
    vars.methReceived = false;
    vars.moneyWhenMethReceived = 0.0;

	settings.Add("prologuesleep",       false, "Split on bed during prologue (prologue% complete)");
    settings.Add("cashmoney",           false, "Split on first cash received (made a sale or picked up stash money)");
    settings.Add("methDeal",            false, "Split when making money after holding meth (meth% complete)");
	
    settings.Add("vehicle",             false, "Split on first entering a vehicle");    
    settings.Add("totalmoney",          false, "Split when combined money reaches a certain value (values set in 'Player set vars' section of asl file)");

    // Inventory
    settings.Add("inventory",           false, "Split when player has a specific item in inventory");

    settings.Add("drugs",               false, "Base drug types in a baggie", "inventory");
    settings.Add("ogkush",              false, "OG Kush", "drugs");
    settings.Add("meth",                false, "Meth", "drugs");

    settings.Add("pseudo",              false, "Split on receiving pseudo during prologue", "inventory");
    settings.Add("lowqualitypseudo",    false, "Split on first time receiving low-quality pseudo", "inventory");
    settings.Add("chemistrystation",    false, "Split on first time buying chemistry station", "inventory");
    settings.Add("speedgrow",           false, "Split on receiving speed grow", "inventory");

    // Deals
    settings.Add("deals",               false, "Split when first deal of a product class is complete");
    settings.Add("dealWeed",            false, "Weed (og Kush)", "deals");
    settings.Add("dealMeth",            false, "Meth", "deals");
    settings.Add("dealCoca",            false, "Coke", "deals");

    // Quests
    settings.Add("quests",              false, "Split when quest completed");
    settings.Add("quest0",              false, "Getting Started", "quests");
    settings.Add("quest1",              false, "Gearing Up", "quests");
    settings.Add("quest2",              false, "Money Management", "quests");
    settings.Add("quest3",              false, "Keeping It Fresh", "quests");
    settings.Add("quest4",              false, "Packin'", "quests");
    settings.Add("quest5",              false, "On The Grind", "quests");
    settings.Add("quest6",              false, "Moving Up", "quests");
    settings.Add("quest7",              false, "Dodgy Dealing", "quests");
    settings.Add("quest8",              false, "Mixing Mania", "quests");
    settings.Add("quest9",              false, "Welcome to Hyland Point", "quests");
    settings.Add("quest10",             false, "Clean Cash", "quests");
    settings.Add("quest11",             false, "Wretched Hive of Scum and Villainy", "quests");
    settings.Add("quest12",             false, "We Need To Cook", "quests");
    settings.Add("quest13",             false, "Cleaners", "quests");
    settings.Add("quest14",             false, "Botanists", "quests");
    settings.Add("quest15",             false, "Packagers", "quests");
    settings.Add("quest16",             false, "Chemists", "quests");
    settings.Add("quest17",             false, "Making the Rounds", "quests");
    settings.Add("quest18",             false, "Needin' the Green", "quests");

    // Properties
    settings.Add("properties",          false, "Split on purchasing properties");
    settings.Add("property0",           false, "Manor", "properties");
    settings.Add("property1",           false, "Motel", "properties");
    settings.Add("property2",           false, "Bungalow", "properties");
    settings.Add("property4",           false, "Docks warehouse", "properties");
    settings.Add("property5",           false, "Barn", "properties");
    settings.Add("property6",           false, "Sweatshop", "properties");

    // Player rank
    settings.Add("rank",                false, "Split on getting enough xp for a specific rank");
    settings.Add("rank1",               false, "Hoodlum", "rank");
    settings.Add("rank2",               false, "Peddler", "rank");
    settings.Add("rank3",               false, "Hustler", "rank");
    settings.Add("rank4",               false, "Bagman", "rank");
    settings.Add("rank5",               false, "Enforcer", "rank");
    settings.Add("rank6",               false, "Shot Caller", "rank");
    settings.Add("rank7",               false, "Block Boss", "rank");
    settings.Add("rank8",               false, "Underlord", "rank");
    settings.Add("rank9",               false, "Baron", "rank");
    settings.Add("rank10",              false, "Kingpin", "rank");
    

    // ===============
    // Player set vars
    // ===============

    //vars.moneySplitValue = 2079; // the value that combined offline and online balance should be above to cause a split

    // will split once your combined balance hits each threshold
    // put as many numbers in between the {} as you need, separated by commas
    //
    // example:
    //
    // vars.moneySplits = new float[] {1999, 19999, 49999, 99999};
    //
    // this line would split once you get at least 2000, then 20000, then 50000, then 100000
    
    //vars.moneySplits = new float[] {999999, 9999999, 99999999};
    vars.moneySplits = new float[] {2079};

}

init
{
    //vars.offset = memory.ReadValue<int>(current.questList + 0x120);
}

start
{
    // introComplete is trigger for main game
    // cameraControl is trigger for prologue

    bool introComplete = memory.ReadValue<bool>((IntPtr)current.playerBase + 0x280);

	if ( vars.shouldStart && (introComplete || current.hasCameraControl) )
	{
        vars.shouldStart = false;
		return true;
	}

    // make sure triger events happening before 10s game time don't start timer. Prevents main game from starting early.
    if (current.gameTime > 10 && current.gameTime < 11)
	{
		vars.shouldStart = true;
	}
    else if (current.gameTime < 10)
    {
        vars.shouldStart = false;
    }
}

onReset
{
    // Reset progress tracking variables
    vars.methReceived = false;

    // Reset splitter logic variables
	vars.completedSplits.Clear();
	vars.shouldStart = false;
}

// Not currently used, as runs are timed using real time. Remove // and set comparison to game time if needed
gameTime
{
    // return TimeSpan.FromSeconds(current.gameTime);
}

split
{
	if (current.money > 0.5 && !vars.completedSplits.Contains("money") && settings["cashmoney"])
	{
		vars.completedSplits.Add("money");
		return true;
	}

    if (settings["inventory"] || settings["dealMeth"])
    {
        for (int i = 0; i < 8; i++)
        {
            bool inBaggie = false;
            ulong offset = memory.ReadValue<ulong>((IntPtr)current.playerBase + 0x2A0);
            offset = memory.ReadValue<ulong>((IntPtr)offset + (0x20 + (8 * i)));
            offset = memory.ReadValue<ulong>((IntPtr)offset + 0x10);

            if (settings["drugs"])
            {
                ulong offsetContainer = memory.ReadValue<ulong>((IntPtr)offset + 0x40);
                if (memory.ReadString((IntPtr)offsetContainer + 0x14, 16) == "baggie")
                {
                    inBaggie = true;
                }
            }

            offset = memory.ReadValue<ulong>((IntPtr)offset + 0x18);
            String itemName = memory.ReadString((IntPtr)offset + 0x14, 32);
                        
            if (settings["ogkush"] && !vars.completedSplits.Contains("ogkush")
                && itemName == "ogkush"
                && inBaggie)
            {
                vars.completedSplits.Add("ogkush");
                return true;
            }

            if (settings["pseudo"] && !vars.completedSplits.Contains("pseudo")
                && itemName == "pseudo"
                && !current.introComplete) 
            {
                vars.completedSplits.Add("pseudo");
                return true;
            }

            if (settings["lowqualitypseudo"] && !vars.completedSplits.Contains("lowqualitypseudo")
                && itemName == "lowqualitypseudo")
            {
                vars.completedSplits.Add("lowqualitypseudo");
                return true;
            }

            if (settings["chemistrystation"] && !vars.completedSplits.Contains("chemistrystation")
                && itemName == "chemistrystation")
            {
                vars.completedSplits.Add("chemistrystation");
                return true;
            }

            if (settings["speedgrow"] && !vars.completedSplits.Contains("speedgrow")
                && itemName == "speedgrow")
            {
                vars.completedSplits.Add("speedgrow");
                return true;
            }

            if (settings["dealMeth"] && !vars.completedSplits.Contains("dealMeth")
                && itemName == "meth"
                && !vars.methReceived)
            {
                vars.methReceived = true;
                vars.moneyWhenMethReceived = current.money;
            }

        }
    }

    // Player has held meth, so split when money increases
    if (settings["dealMeth"] && !vars.completedSplits.Contains("dealMeth")
        && vars.methReceived
        && (current.money > vars.moneyWhenMethReceived))
    {
        vars.methReceived = false;
        vars.completedSplits.Add("dealMeth");
        return true;
    }

    // player enters any vehicle
    if (settings["vehicle"] && !vars.completedSplits.Contains("vehicle")
        && memory.ReadValue<ulong>((IntPtr)current.playerBase + 0x208) != 0)
    {
        vars.completedSplits.Add("vehicle");
        return true;
    }

    // Split to end prologue
    if (settings["prologuesleep"] && !vars.completedSplits.Contains("prologuesleep")
        && memory.ReadValue<bool>((IntPtr)current.playerBase + 0x258)
        && !current.introComplete)
    {
        vars.completedSplits.Add("prologuesleep");
        return true;
    }

    if (settings["totalmoney"])
    {
        for (int i = 0; i < vars.moneySplits.Length; i++)
        {
            if (((current.money + current.moneyonline) > vars.moneySplits[i]) && !vars.completedSplits.Contains("moneysplit" + i))
            {
                vars.completedSplits.Add("moneysplit" + i);
                return true;
            }
        }
    }

    if (settings["quests"])
    {
        for (int i = 0; i < 19; i++)
        {
            if (settings["quest" + i] && !vars.completedSplits.Contains("quest" + i))
            {
                ulong offset = memory.ReadValue<ulong>((IntPtr)current.questManagerBase + 0x120);
                offset = memory.ReadValue<ulong>((IntPtr)offset + (0x20 + (8 * i)));
                if (memory.ReadValue<int>((IntPtr)offset + 0x020) == 2)
                {
                    vars.completedSplits.Add("quest" + i);
                    return true;
                }
            }
        }
    }

    if (settings["properties"])
    {
        for (int i = 0; i < 7; i++)
        {
            if (i == 3) { continue; } // RV, skip

            if (settings["property" + i] && !vars.completedSplits.Contains("property" + i))
            {
                ulong offset = memory.ReadValue<ulong>((IntPtr)current.propertyList + 0x20 + (8 * i));
                
                if (memory.ReadValue<bool>((IntPtr)offset + 0x120) == true)
                {
                    vars.completedSplits.Add("property" + i);
                    return true;
                }
            }
        }
    }

    if (settings["rank"])
    {
        int rank = memory.ReadValue<int>((IntPtr)current.levelManagerBase + 0x120);

        for (int i = 1; i <= rank; i++)
        {
            if (i > 10) { break; } // safety if rank contains garbage value

            if (settings["rank" + i] && !vars.completedSplits.Contains("rank" + i))
            {
                vars.completedSplits.Add("rank" + i);
                return true;
            }
        }
    }
}