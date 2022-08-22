# The CodeTimer - VS Code Session time messurement tool.
The CodeTimer is a simple tool built in bash script that tracks your time spent on vs code. the tool can detect when you are actively using vs code and when you are idling or using different applications.
when inactivity is detected the tool gives you a duration called Buffer Time to return back to vs code before it stops counting time as "coding time".
Buffer Time can be set using option -b and the its default duration is 300s or 5m.    

## Installation

Simply run the installation script.

    ./install.sh

Make sure the script is executable by running the following command before running the installation script.

    chmod +x install.sh
**Please note:** that the installation uses a pre-compiled binary included in the "binaries" folder,
However you can compile your own binary using the script included in the "scripts" folder. make sure to replace the included binary with your own in the "binaries" folder before running the installation script.


## Usage

Simply run `codetimer [-option ] [-option]` on the terminal.
You can use any of these **options:**

 - ` -b [seconds]` Set the buffer time.
 - ` -c ` Run VS Code alongside the timer (if it wasn't already running).
 - ` -h ` Show instructions.
