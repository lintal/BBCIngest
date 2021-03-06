# BBCIngest

Poll the web for the latest edition of an audio file.

## this is how it works

1. When it first runs, if necessary it creates the archive, publish and log folders specified in the settings.
2. The user can then install a schedule into the Windows Task Scheduler or run the program interactively.

## Running from the task scheduler (recommended)

If you install the scheduled tasks the program will be started a few minutes before a new edition is due. 
There will be notifications when a new edition is found and when it is published.
After installing to the task scheduler the program can be closed.

## Running interactively

To run interactively open the settings menu and set 'RunInForeground' to true. Exit the program and run it again.

If RunInForeground is set there will be a start button. If you press start the program operates as follows:

1. The program calculates the publication time of the next edition from the hour and minute patterns in the settings
2. It then goes to sleep until a few minutes before the next edition is due, set by the minutes before setting
3. It then fetches and publishes the new edition
4. One the publication is complete it goes to sleep until the due time – this just makes the next sleep calculation simple
5. It then repeats from step 1 above.

If you run the program interactively don't leave it running for more than 48 hours as it could run out of memory.

## Fetching and publishing

Whether invoked from the task scheduler or inteactively, once a new edition is due:

1. The program fetches the previous edition and publishes it as though it were the next edition. This ensures a recent edition will be broadcast
2. It then polls using an http HEAD request every 10 seconds for the new edition
3. Once the new edition is available, it downloads it using http and publishes it, overwriting the file published in 4 above.

If the new edition is late, the programme will continue polling after the due time for the number of minutes in the settings "broadcast minutes after.
This defaults to zero but if, for example the station plans to broadcast an edition published at 16:30 at 16:45 it can set this to 15 and if the
new edition is 10 minutes late it will still be fetched and published.

Download and error information is written to a file in the log directory and if enabled during installation it posts log messages to a central log server.
If you permit log posting it is important to fill in your station name and city so your logs can be differentiated from thos of other stations.

## Other settings:

The file fetched is determined by the prefix, basename, webdate and suffix settings. The webdate setting is a .Net DateTime format.
The suffix is probably mp3 or wav.

If the webdate is the empty string the prefix is used as the entire URL. This allows polling for static URLs where new editions are determined by
the last modified date header of the HTTP HEAD response.

The file published is set by the, publish, basename, discdate, useLocaltime and suffix settings. The discdate is a .Net DateTime format.
If useLocalTime is false the published file will contain the due date in UTC.
If useLocalTime is true the published file will contain the due date in the PC's local timezone.
If the discdate is the empty string then the output filename is just the basename with the suffix as the extension. This allows publishing to a fixed filename.

The city and station settings only affect text writting to the log file.
If the logUrl is set, then log messages are http posted to that url as a JSON object.

If SafePublishing is set (recommended) the programme publishes to a temporary file name and then renames the completed file to the final name.

If Publish All Versions is set then all scheduled versions are published each time. This is important if you don't use the Task Scheduler.

If Run As Service is set then the task will be installed as a service. You need to run the program with Admin privileges for this to work.

From version 2.2, if the Target Extension is set to mp2 then the file will be encoded to MPEG-1 Layer II at 384 kbit/s and resampled to 44.1 kHz.
