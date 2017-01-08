# What is tsloader
This tool, `tsloader`, is intended to [send JSON-formatted data][02] (aka [dweet][03] messages)
from a devices to [ThingSpace][01] in support of demonstrations.
In this current version, `tsloader` does this by running a daemon
that creates regular [system activity reports (sar)][04],
and parses the sar data to a simple, space delimited message.
This daemon ([`sar_daemon.sh][16]),
running within a [Node-RED][05] application (Node-RED flow [sar_to_ts_flow][17]),
that formats the information to [JSON][06] and [POST][07] it to ThingSpace.

If `tsloader` is being run on a system that isn't being heavily used,
it will likely create sar reports that are fairly static.
To combat this,
include here is a shell script, using the Linux utility `stress`,
which will help create some viability in the reports.

# Design Decisions
This tool requires Linux but is intended to be highly portal across hardware platforms.
To make the tool ease to use and easily extended,
it makes heavy use of Node-RED.
While intended to operate unseen in the background, this Node-RED application could easily be
made part of any demonstration because of its browser based, [flow programming][08] interface.

`tsloader` should run on any Linux hardware but the instructions here are for
installing and operating on a [Raspberry Pi 3][09].
[Node-RED is pre-installed on the Raspberry Pi][10] operating system, [Raspbian][11].

# Setting Up tsloader
While not required,
the procedure here is for setting up the Raspberry Pi 3 as a [headless devices][12].
The advantage is that you SSH into the devices so I don't need to attach a monitor/keyboard/mouse.
You'll need SSH tools on another computer, like your laptop, to login into the Raspberry Pi.

The real trick on going headless is doing the initial setup of the device
without an HDMI monitor or a keyboard / mouse,
required by the [typical RPi setup][13].
Using just a SD Card reader/writer, a USB WiFi adapter,
and a Linux machine, I will describe the whole setup here.

By the way, if you want to make an existing Raspberry Pi headless,
you don't need to follow this whole procedure.
Just make sure SSH is working and follow Step 3.
If you want to also upgrade your existing Raspberry Pi OS to the latest version,
check out the article ["Raspbian GNU/Linux upgrade from Wheezy to Raspbian Jessie 8"][14].

## Step 1: Configuring the Raspberry Pi
There are many post explaining how to set up a headless Raspberry Pi,
bu I used the posting "[HowTo: Set-Up the Raspberry Pi as a Headless Device][15]".
I followed steps 1 to 11.
To assure every thing is working properly, reboot and log back in.

## Step 2: Install tsloader

```bash
# install tsdemo files
mkdir ~/src
cd ~/src
git clone https://github.com/jeffskinnerbox/tsdemo.git

# go to the branch with tsloader
git checkout tsloader

# make the daemon executable
cd tsloader
chmod a+x sar_daemon.sh
```
## Step X:

### Editing Nodes
copy a node - ctrl-c
paste a node - ctrl-v
delete a node - delete or backspace

### Importing Flows
You can imported flows straight into the editor by pasting the JSON
representing the flow into the Import dialog
(`Ctrl-i` or via the dropdown menu within Node-RED).

### Exporting Flows
Use `Ctrl-a` to select all the flows on the tab and `Ctrl-e`  to popup the flow.
From there, you can do copy the flow to your clipboard.


## Step X: Creating More Variability in the Data
To get more variability within the data created by `tsloader`,
you'll need to add load to the processor,
you could run tools like [`sysbench`][18] or [`stress-ng`][19] at random periods.

# Author's Notes
* Currently, this README references my fork for tsdemo and my branch for tsloader.
Once the pull request is implemented,
I must reference the original project site (https://github.com/kidbug/tsdemo, the `upstream` remote).



[01]:https://thingspace.verizon.com/
[02]:https://thingspace.verizon.com/develop/apis/dweet/v1/index.html
[03]:https://dweet.io/
[04]:http://www.thegeekstuff.com/2011/03/sar-examples/?utm_source=feedburner
[05]:https://nodered.org/
[06]:https://www.copterlabs.com/json-what-it-is-how-it-works-how-to-use-it/
[07]:https://thingspace.verizon.com/develop/apis/dweet/v1/API%20Reference/Send%20Data%20with%20POST.html
[08]:http://jpaulmorrison.com/fbp/
[09]:https://www.raspberrypi.org/blog/raspberry-pi-3-on-sale/
[10]:http://nodered.org/docs/hardware/raspberrypi
[11]:https://www.raspberrypi.org/downloads/raspbian/
[12]:http://internetofthingsagenda.techtarget.com/definition/headless-system
[13]:https://www.raspberrypi.org/help/noobs-setup/
[14]:https://linuxconfig.org/raspbian-gnu-linux-upgrade-from-wheezy-to-raspbian-jessie-8
[15]:http://jeffskinnerbox.me/posts/2016/Apr/27/howto-set-up-the-raspberry-pi-as-a-headless-device/
[16]:https://github.com/jeffskinnerbox/tsdemo/blob/tsloader/tsloader/sar_daemon.sh
[17]:https://github.com/jeffskinnerbox/tsdemo/blob/tsloader/tsloader/sar_to_ts_flow
[18]:https://www.howtoforge.com/how-to-benchmark-your-system-cpu-file-io-mysql-with-sysbench
[19]:http://www.ubuntugeek.com/stress-ng-tool-to-load-and-stress-your-ubuntu-system.html
[20]:
