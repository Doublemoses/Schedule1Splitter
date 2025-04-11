state("Schedule I")
{
    ulong   playerBase          : "GameAssembly.dll", 0x037991C0, 0xB8, 0x18;               // Player
    ulong   levelManagerBase    : "GameAssembly.dll", 0x038CEAA0, 0xB8, 0x0;                // LevelManager

    ulong   inventoryBase       : "GameAssembly.dll", 0x037991C0, 0xB8, 0x18, 0x2A0;        // Player -> Inventory -> Item[0]
    ulong   dailySalesBase      : "GameAssembly.dll", 0x037910F0, 0xB8, 0x10, 0x170;        // DailySummary -> itemsSoldByPlayer - Dictionary containing all products sold to show on end of day screen
    bool    hasCameraControl    : "GameAssembly.dll", 0x03799290, 0xB8, 0x10, 0xC0;         // PlayerCamera -> hasControl - Whether player can control camera
    float   gameTime            : "GameAssembly.dll", 0x038CF930, 0xB8, 0x0, 0x140;         // TimeManager -> gameTime
    float   moneyOnline         : "GameAssembly.dll", 0x038CEE40, 0xB8, 0x0, 0x128;         // MoneyManager -> onlineBalance
    float   moneyCash           : "GameAssembly.dll", 0x037991C0, 0xB8, 0x18, 0x2A0, 0x60, 0x10, 0x38;  // Player -> Inventory -> Slot 9 -> Cash
    ulong   mainQuestList       : "GameAssembly.dll", 0x038CF590, 0xB8, 0x20, 0x120;        // QuestManager -> DefaultQuests - List of all standard main game quests

    ulong   propertyList        : "GameAssembly.dll", 0x037C6A40, 0xB8, 0x20, 0x10;         // List containing all properties
    ulong   businessList        : "GameAssembly.dll", 0x03799910, 0xB8, 0x30, 0x10;         // List containing all businesses
}

startup
{
    // Splitter state vars
	vars.completedSplits = new List<string>();
	vars.shouldStart = false;

	settings.Add("prologuesleep",       false, "Split on bed during prologue (prologue% complete)");
    settings.Add("vehicle",             false, "Split on first entering a vehicle");    
    settings.Add("totalmoney",          false, "Split when combined money reaches a certain value (values set in 'Player set vars' section of asl file)");

    // Inventory
    settings.Add("inventory",           false, "Split when player has a specific item in inventory");

    settings.Add("ogkush",              false, "OG Kush baggie", "inventory");
    settings.Add("meth",                false, "Meth baggie", "inventory");

    settings.Add("pseudo",              false, "Split on receiving pseudo during prologue", "inventory");
    settings.Add("lowqualitypseudo",    false, "Split on first time receiving low-quality pseudo", "inventory");
    settings.Add("chemistrystation",    false, "Split on first time buying chemistry station", "inventory");
    settings.Add("speedgrow",           false, "Split on receiving speed grow", "inventory");
    settings.Add("soil",                false, "Split on receiving soil", "inventory");

    // Deals
    settings.Add("deals",               false, "Split when selling a specific drug for the first time");
    settings.Add("dealweed",            false, "Weed (OG Kush)", "deals");
    settings.Add("dealmeth",            false, "Meth", "deals");
    settings.Add("dealcoca",            false, "Coca", "deals");

    // Quests
    settings.Add("quests",              false, "Split when quest completed");
    settings.Add("quest9",              false, "Welcome to Hyland Point", "quests");
    settings.Add("quest0",              false, "Getting Started", "quests");
    settings.Add("quest1",              false, "Gearing Up", "quests");
    settings.Add("quest2",              false, "Money Management", "quests");
    settings.Add("quest3",              false, "Keeping It Fresh", "quests");
    settings.Add("quest4",              false, "Packin'", "quests");
    settings.Add("quest5",              false, "On The Grind", "quests");
    settings.Add("quest6",              false, "Moving Up", "quests");
    settings.Add("quest7",              false, "Dodgy Dealing", "quests");
    settings.Add("quest8",              false, "Mixing Mania", "quests");
    settings.Add("quest10",             false, "Clean Cash", "quests");
    settings.Add("quest11",             false, "Wretched Hive of Scum and Villainy", "quests");    
    settings.Add("quest17",             false, "Making the Rounds", "quests");
    settings.Add("quest18",             false, "Needin' the Green", "quests");
    settings.Add("quest12",             false, "We Need To Cook", "quests");
    settings.Add("quest13",             false, "Cleaners", "quests");
    settings.Add("quest14",             false, "Botanists", "quests");
    settings.Add("quest15",             false, "Packagers", "quests");
    settings.Add("quest16",             false, "Chemists", "quests");

    // Real estate
    settings.Add("realestate",          false, "Split on purchasing real estate");

    settings.Add("property1",           false, "Motel", "realestate");
    settings.Add("property6",           false, "Sweatshop", "realestate");
    settings.Add("property2",           false, "Bungalow", "realestate");
    settings.Add("property5",           false, "Barn", "realestate");
    settings.Add("property4",           false, "Docks Warehouse", "realestate");
    settings.Add("property0",           false, "Manor", "realestate");
    settings.Add("business1",           false, "Laundromat", "realestate");
    settings.Add("business0",           false, "Post Office", "realestate");
    settings.Add("business3",           false, "Car Wash", "realestate");
    settings.Add("business2",           false, "Taco Ticklers", "realestate");

    // Player rank
    settings.Add("rank",                false, "Split when reaching a specific rank");
    settings.Add("rank1",               false, "Hoodlum", "rank");
    settings.Add("rank1tier5",          false, "Hoodlum V (Will not split on hoodlum I if this is ticked)", "rank1");
    settings.Add("rank2",               false, "Peddler", "rank");
    settings.Add("rank3",               false, "Hustler", "rank");
    settings.Add("rank4",               false, "Bagman", "rank");
    settings.Add("rank5",               false, "Enforcer", "rank");
    settings.Add("rank6",               false, "Shot Caller", "rank");
    settings.Add("rank7",               false, "Block Boss", "rank");
    settings.Add("rank8",               false, "Underlord", "rank");
    settings.Add("rank9",               false, "Baron", "rank");
    settings.Add("rank10",              false, "Kingpin", "rank");
    
    // Load cash splits from file scheduleIcashsplits.txt in the livesplit base directory
    vars.moneySplits = new List<int>();

    try {
        using (StreamReader sr = new StreamReader(System.IO.Directory.GetCurrentDirectory() + "\\scheduleIcashsplits.txt"))
        {
            string line;
            int i = 0;
            while ((line = sr.ReadLine()) != null)
            {
                if (line != "" && !line.StartsWith("//"))
                {
                    vars.moneySplits.Add(Convert.ToInt32(line));
                }
            }
        }
	} catch (Exception e) {
        print(e.Message + " ");
        vars.moneySplits.Clear();
        vars.moneySplits.Add(2079); // default value if an issue occurs loading the file. This line can be repeated to add multiple values.
	}
}

init
{
    /*var module = modules.First(x => x.ModuleName == "GameAssembly.dll");
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
    vars.playerSource = scanner.Scan(new SigScanTarget(-16, "73 1C 02 C0 00 00 00 00 39 F0 03 C0 00 00 00 00 BF 89 03 60 00 00 00 00 A3 16 00 A0 00 00 00 00 ?? ?? ?? ?? ?? ?? 00 00 A3 96 00 A0 00 00 00 00 A5 42 00 20 00 00 00 00 8B 3D 01 20 00 00 00 00 E7 B2 03 C0 00 00 00 00 1F E1 03 C0 00 00 00 00"));
    //vars.playerBase = new MemoryWatcher<bool>(new DeepPointer((IntPtr)vars.playerSource, 0xB8, 0x18, 0x22C));
    vars.playerBase = new MemoryWatcher<ulong>(new DeepPointer((IntPtr)vars.playerSource, 0xB8, 0x18));*/

    vars.inventoryItem = new string[8];
    vars.dailySalesCount = 0;
}

start
{
    // Player + 0x280 (introComplete) is trigger for main game
    // cameraControl is trigger for prologue
	if ( vars.shouldStart
        && ( memory.ReadValue<bool>((IntPtr)current.playerBase + 0x280) || current.hasCameraControl) )
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
    /*if (memory.ReadValue<bool>((IntPtr)current.loadingScreenBase + 0x28))
    {
        if (memory.ReadValue<bool>((IntPtr)current.loadingScreenBase + 0xB0))
        {
            vars.loadingState = 1; // tutorial loading screen
        }
        else
        {
            vars.loadingState = 2; // main game loading screen
        }
    }

    if (vars.loadingState == 2 && !memory.ReadValue<bool>((IntPtr)current.loadingScreenBase + 0x28)) 
    {
        vars.loadingState = 0;
        return true;
    }*/

}

onReset
{
    foreach (string splitName in vars.completedSplits) // debugging
    {
        print(splitName);
    }
    vars.dailySalesCount = 0;
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
    if (settings["inventory"])
    {
        for (int i = 0; i < 8; i++)
        {
            // update current inventory item string
            ulong itemOffset = memory.ReadValue<ulong>((IntPtr)current.inventoryBase + 0x20 + (8 * i)); // recalc pointer to current slot
            itemOffset = memory.ReadValue<ulong>((IntPtr)itemOffset + 0x10);
            ulong packageOffset = itemOffset; // save this to calc packaging offsets if needed
            itemOffset = memory.ReadValue<ulong>((IntPtr)itemOffset + 0x18);
            vars.inventoryItem[i] = memory.ReadString((IntPtr)itemOffset + 0x14, 32);
            string package = "";

            if (settings["ogkush"] || settings["meth"]) // if drugs are being split on, check what package the item has
            {
                packageOffset = memory.ReadValue<ulong>((IntPtr)packageOffset + 0x40);
                package = memory.ReadString((IntPtr)packageOffset + 0x14, 32);
            }
                        
            if (settings["ogkush"] && !vars.completedSplits.Contains("ogkush")
                && vars.inventoryItem[i] == "ogkush"
                && package == "baggie")
            {
                vars.completedSplits.Add("ogkush");
                return true;
            }

            if (settings["meth"] && !vars.completedSplits.Contains("meth")
                && vars.inventoryItem[i] == "meth"
                && package == "baggie")
            {
                vars.completedSplits.Add("meth");
                return true;
            }


            if (settings["pseudo"] && !vars.completedSplits.Contains("pseudo")
                && vars.inventoryItem[i] == "pseudo"
                && memory.ReadValue<bool>((IntPtr)current.playerBase + 0x280) == false) 
            {
                vars.completedSplits.Add("pseudo");
                return true;
            }

            if (settings["lowqualitypseudo"] && !vars.completedSplits.Contains("lowqualitypseudo")
                && vars.inventoryItem[i] == "lowqualitypseudo")
            {
                vars.completedSplits.Add("lowqualitypseudo");
                return true;
            }

            if (settings["chemistrystation"] && !vars.completedSplits.Contains("chemistrystation")
                && vars.inventoryItem[i] == "chemistrystation")
            {
                vars.completedSplits.Add("chemistrystation");
                return true;
            }

            if (settings["speedgrow"] && !vars.completedSplits.Contains("speedgrow")
                && vars.inventoryItem[i] == "speedgrow")
            {
                vars.completedSplits.Add("speedgrow");
                return true;
            }

            if (settings["soil"] && !vars.completedSplits.Contains("soil")
                && vars.inventoryItem[i] == "soil")
            {
                vars.completedSplits.Add("soil");
                return true;
            }
        }
    }

    if ((settings["dealweed"] && !vars.completedSplits.Contains("dealweed"))
        || (settings["dealmeth"] && !vars.completedSplits.Contains("dealmeth"))
        || (settings["dealcoca"] && !vars.completedSplits.Contains("dealcoca")))
    {
        uint oldCount = (uint)vars.dailySalesCount;
        vars.dailySalesCount = memory.ReadValue<uint>((IntPtr)current.dailySalesBase + 0x20);

        if (vars.dailySalesCount > oldCount)    // New entry in list of drugs sold
        {
            ulong offset = memory.ReadValue<ulong>((IntPtr)current.dailySalesBase + 0x18);
            offset = memory.ReadValue<ulong>((IntPtr)(offset + 0x10 + (vars.dailySalesCount * 0x18)));
            String compare = memory.ReadString((IntPtr)offset + 0x14, 32);

            if (compare == "ogkush" && settings["dealweed"])
            {
                vars.completedSplits.Add("dealweed");
                return true;
            }
            else if (compare == "meth" && settings["dealmeth"])
            {
                vars.completedSplits.Add("dealmeth");
                return true;
            }
            else if (compare == "coca")
            {
                vars.completedSplits.Add("dealcoca");
                return true;
            }
        }
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
        && memory.ReadValue<bool>((IntPtr)current.playerBase + 0x258)           // player sleeping
        && !memory.ReadValue<bool>((IntPtr)current.playerBase + 0x280))         // player currentltly in tutorial
    {
        vars.completedSplits.Add("prologuesleep");
        return true;
    }

    if (settings["totalmoney"])
    {
        for (int i = 0; i < vars.moneySplits.Count; i++)
        {
            if (((current.moneyCash + current.moneyOnline) > (vars.moneySplits[i] - 0.51)) && !vars.completedSplits.Contains("moneysplit" + i))
            {
                vars.completedSplits.Add("moneysplit" + i);
                return true;
            }
        }
    }

    // Iterate through all default quests and check their completion state.
    // 0 = not active, 1 = active, 2 = complete
    if (settings["quests"])
    {
        for (int i = 0; i < 19; i++)
        {
            if (settings["quest" + i] && !vars.completedSplits.Contains("quest" + i))
            {
                ulong questOffset = memory.ReadValue<ulong>((IntPtr)current.mainQuestList + (0x20 + (8 * i)));
                if (memory.ReadValue<int>((IntPtr)questOffset + 0x020) == 2)
                {
                    print("splitting on " + i);
                    vars.completedSplits.Add("quest" + i);
                    return true;
                }
            }
        }
    }

    if (settings["realestate"])
    {
        for (int i = 0; i < 7; i++)
        {
            if (i == 3) { continue; } // RV, skip

            if (settings["property" + i] && !vars.completedSplits.Contains("property" + i))
            {
                ulong offset = memory.ReadValue<ulong>((IntPtr)current.propertyList + 0x20 + (8 * i));
                    
                if (memory.ReadValue<bool>((IntPtr)offset + 0x120) == true) // IsOwned
                {
                    vars.completedSplits.Add("property" + i);
                    return true;
                }
            }
        }

        for (int i = 0; i < 4; i++)
        {
            if (settings["business" + i] && !vars.completedSplits.Contains("business" + i))
            {
                ulong offset = memory.ReadValue<ulong>((IntPtr)current.businessList + 0x20 + (8 * i));
                    
                if (memory.ReadValue<bool>((IntPtr)offset + 0x120) == true) // IsOwned
                {
                    vars.completedSplits.Add("business" + i);
                    return true;
                }
            }
        }
    }

    if (settings["rank"])
    {
        int rank = memory.ReadValue<int>((IntPtr)current.levelManagerBase + 0x120);

        if (rank != 0)
        {
            if (settings["rank" + rank] && !vars.completedSplits.Contains("rank" + rank))
            {

                if (rank == 1 && settings["rank1tier5"]) // special case for splitting on Hoodlum V
                {
                    int tier = memory.ReadValue<int>((IntPtr)current.levelManagerBase + 0x128);
                    if (tier == 5)
                    {
                        vars.completedSplits.Add("rank1");
                        vars.completedSplits.Add("rank1tier5");
                        return true;
                    }
                }
                else
                {
                    vars.completedSplits.Add("rank" + rank);
                    return true;
                }
            }
        }
    }
}