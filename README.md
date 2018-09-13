# Wireshark Dissector for IOTA Gossip protocol

This repository contains a IOTA gossip protocol dissector.  


## Installation

Just copy the iota.lua file into wireshark folder plugin directory. Restart wireshark 
and open the capture files. The plugin will be automatically loaded and start decoding 
Gossip protocol messages. 

## Changing port numbers

The default port number for UDP is port 14600 and for TCP is 15600.
If the port number used in your IOTA settings is different, you could change the port via 
protocol settings in wireshark menu. 

Go to Edit Menu - Preferences - Protocols and choose IOTA on the left side menu.



