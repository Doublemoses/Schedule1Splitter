# Schedule I Splitter BETA release
This is an early release of an autosplitter for the game Schedule I. While it should work smoothly for the most part, please be aware that this is early in development and may still have issues. If using the autosplits, the final time will not be exactly what the final leaderboard time is, but it should be very close. For any bug reports, issues, or suggestions, contact me on the Schedule I speedrunning discord.

## What Currently Works
Automatic timer starting works for both main game and prologue. There were some logic issues that have hopefully been fixed in this release.

There are also several autosplits defined, which are all off by default.

## Installing
Download the latest zip file from the releases section, and extract the *scheduleI.asl* to a convinient location.

In livesplit, open the layout editor, and add a new element under the menu **Control > Scriptable Auto Splitter**.

Double click on the *Scriptable Auto Splitter* element in the selection box to open its settings. Next to *Script Path*, click the browse button, and select the *scheduleI.asl* file.

A box labelled *Advanced* should appear. This contains options for all autosplits, which are off by default. Tick which options you want to automatically split on.

Make sure your **Compare Against** setting is set to **Real Time** not Game Time.

## Current autosplits
- Split on bed during prologue
  - This is the final split for any prologue run. This is safe to leave on, as this cannot be triggered at any other time.
- Split of first cash received
  - Splits as soon as the player has any cash money. Usually occurs on first sale, or picking up money from dropboxes. Used to end weed% run.
- Split when making money after holding meth
  - Once the player has meth in their inventory, the splitter will record the current money value, and will split once the player's money increases. Used to end meth% run.
- Split on receiving speed grow (bugged, depreciated)
- Split on receiving og kush baggie
- Split on first entering vehicle
- Split on receiving pseudo during prologue
- Split on first time receiving low-quality pseudo
- Split on first time stepping into any owned property that isn't the RV
- Split on first time buying chemistry station
- Split when combined money reaches a certain value (default: 2079 for meth%)
  - Splits when combined money total is over the set value. This can be changed by searching for and editing the following line:
    ```
    vars.moneySplitValue = 2079;
    ```
## Known Issues
- Speedgrow split only works for the first two inventory slots. I don't think this split is relevant for any current strats, so it will either be fixed or removed.

## Future Plans
- Recode everything. Once I have a general idea of everything, I want to remake it from the ground up. Still in the get it working phase for now.
- Possibly implement aobscanning to help protect against updates. Each patch currently requires four addresses to be found, and that will e xpand as more autosplit options are added.
- Add more splits. You can request a split from me, and I will add it if I know how.

