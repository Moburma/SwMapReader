# SwMapReader
Powershell 5 Script to process building Things in map files (.MAD) from the Bullfrog Productions game Syndicate Wars into human readable CSV format to aid in reverse engineering and editing. 

Run with SWMapReader.ps1 {filename}
  
  e.g. SWMapReader.ps1 MAP065.MAD

Features:
* Lists all building objects in a map and their details, especially ThingOffset, needed to give NPCs and objectives building related commands in levels
* Limited identication of what some building types are (preliminary)
* Outputs to CSV file

Limitations:
To get to the building Things you're meant to have processed the other data chunks of the file first to know where they are. We're not doing that here, so a shortcut is taken. Because the building Things are normally the very last objects in a map file it just works backwards in 168 byte chunks for the end, looking for the header that lists the number of Things to see if that matches the number processed so far. This works on 90% of maps, but a few seem to have either extra other data at the end, or buildings that are not counted in the total number. This breaks the script on those. Known maps that don't work:

* MAP011.MAD
* MAP012.MAD
* MAP047.MAD
* MAP070.MAD
* MAP052.MAD
* MAP060.MAD
