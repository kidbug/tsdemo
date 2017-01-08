# What is tsloader
This tool, `tsloader`, is intended to [send JSON-formatted data][02] (aka [dweet][03] messages)
from a devices to [ThingSpace][01] in support of client demonstrations.
In this current version, `tsloader` does this by running a daemon
that creates regular [system activity reports (sar)][04],
and parses the sar data to a simple, space delimited message.
This daemon ([`sar_daemon.sh`][16]),
running within a [Node-RED][05] application (Node-RED flow [`tsloader_flow`][17]),
that formats the information to [JSON][06] and [POST][07] it to ThingSpace.

# Design Decisions
This tool requires Linux but is intended to be highly portal across hardware platforms.
To make the tool ease to use and easily extended,
it use Node-RED.
While intended to operate unseen in the background, this Node-RED application could easily be
made part of any demonstration if desired.
Node-RED its browser based and uses a [flow programming][08] paradigm,
making it easy to describe its functionality.

`tsloader` should run on any Linux hardware but the instructions here are for
installing and operating on a [Raspberry Pi 3][09].
[Node-RED is pre-installed on the Raspberry Pi][10] operating system, [Raspbian][11].

# Setting Up tsloader
While not required,
the procedure here is for setting up the Raspberry Pi 3 as a [headless devices][12].
The advantage is you don't need to attach a monitor/keyboard/mouse,
just login from another computer.
You'll need SSH tools on that other computer, like your laptop, to login into the Raspberry Pi.

The real trick on going headless is doing the initial setup of the Raspberry Pi
without an HDMI monitor or a keyboard / mouse,
required by the [typical RPi setup][13].
Using just a SD Card reader/writer, a USB WiFi adapter,
and a Linux machine, I provide a description of the whole setup in Step 1.

If you want to make an existing Raspberry Pi headless,
you don't need to follow this whole procedure.
If you want to also upgrade your existing Raspberry Pi OS to the latest version,
check out the article ["Raspbian GNU/Linux upgrade from Wheezy to Raspbian Jessie 8"][14].

## Step 1: Configuring the Raspberry Pi
There are many post explaining how to set up a headless Raspberry Pi,
but I used the posting "[HowTo: Set-Up the Raspberry Pi as a Headless Device][15]".
I followed steps 1 to 11.
Once your complete, make sure everything is working properly by rebooting and log back in.

## Step 2: Install tsloader
Now clone the tsdemo project as shown below
(**NOTE:** Generally, you clone the main repository (aka `upstream` remote)
and **not** this forked version.
But at this moment, the pull request hasn't been submitted.):

```bash
# install tsdemo files
mkdir ~/src
cd ~/src
git clone https://github.com/jeffskinnerbox/tsdemo.git

# go to the branch with tsloader
cd tsdemo
git checkout tsloader
cd tsloader
```

## Step 3: Installing Additional Node Modules
Next we need to install some required Node-RED node modules.
A subtlety (bug?)  with the [Node-RED implementation on the Raspberry Pi][22]
is that you must do installs while within the users Node-RED configuration directory.
By default this is `~/.node-red`.
Therefore, it appears that Node-RED modules are not global,
so **DO NOT** use `nmp install -g ...` .

You can search for available nodes in the [Node-RED library][20] or on the [npm repository][21].
We need the following node modules:

* [daemon](https://www.npmjs.com/package/node-red-node-daemon)
* [timestamp](http://flows.nodered.org/node/thethingbox-node-timestamp)
* [OS Information](http://flows.nodered.org/node/node-red-contrib-os)

They are installed as follows:

```bash
# all node-red module must go here
cd ~/.node-red

# install daemon to run bash script
sudo npm install node-red-node-daemon

# install tool to timestamp JSON message
sudo npm install thethingbox-node-timestamp

# install tools to get operating system information
sudo npm install node-red-contrib-os
```

## Step 4: Install Sar
The Node-RED `tsloader` flow runs a daemon shell that make use of [system activity reports (sar)][04],
We must install this package via:

```bash
# install system activity reports, aka sar
sudo apt-get install sysstat
```

## Step 5: Installing tsloader Flow
The final step is to install and deploy (aka execute) the `tsloader` flow.
Once completed, `tsloader` will  immediately start posting data to ThingSpace.
Do the following tasks:

1. Start Node-RED by executing `node-red` on the command-line in a terminal
(see alternative ways [here][23])
1. Pull up the Node-RED user interface by entering `http://<raspberry-pi-host-name>:1880` into your browser.
1. Import the tsloader flow into Node-RED by copying the contents of
`/home/pi/src/tsdemo/tsloader/tsloader_flow` into Node_RED via entering 'Ctrl-i` on the Node-RED UI.
(see [here][24] for more information).
1. Double click on the tab heading to name the flow "tsloader" (optional)
1. Click the "Deply" button to start the flow and begin posting data to ThingSpace

To check assure everything is working,
turn on the "msg.statusCode" node and you should see HTTP status code "200" being printed.
Also, you can check ThingSpace via:

```bash
# check dweet message status on thingspace
curl -s -X GET --header "Accept: application/json" "https://thingspace.io/get/dweets/for/tsloader" | jq -C '.' | head -n 50
```

`tsloader` should now run continously until you stop Node-RED.

### Node-RED UI Edit Cheat Sheet
* Editing Nodes
    * copy a node - `ctrl-c`
    * paste a node - `ctrl-v`
    * delete a node - delete or backspace
* Importing Flows
    * You can imported flows straight into the editor by pasting the JSON representing the flow into the Import dialog (`Ctrl-i` or via the dropdown menu within Node-RED).
* Exporting Flows
    * Use `Ctrl-a` to select all the flows on the tab and `Ctrl-e` to popup the flow.  From there, you can copy the flow to your clipboard.

## Step 6: Creating More Variability in the Data
To get more variability within the data created by `tsloader`,
you'll need to add load to the processor.
Run some resource consuming application
or you could run tools like [`sysbench`][18] or [`stress-ng`][19] at random periods.

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
[20]:http://flows.nodered.org/
[21]:https://www.npmjs.com/browse/keyword/node-red
[22]:http://nodered.org/docs/hardware/raspberrypi#using-the-editor
[23]:https://nodered.org/docs/hardware/raspberrypi
[24]:https://nodered.org/docs/getting-started/first-flow
