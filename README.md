# Wireshark Dissector for IOTA Gossip protocol

This repository contains a IOTA gossip protocol dissector.  


## Installation

Just copy the iota.lua file into wireshark plugin directory. 

>You can find paths for your system in the Wireshark GUI. `Help -> About ... -> Folders`

Restart wireshark and open the capture files. 
The plugin will be automatically loaded and start decoding Gossip protocol messages:

## Example IOTA Gossip Protocol decoding:
```
IOTA Gossip Protocol
    Signature [truncated]: VGYMJSYAFUJFHTOYYHAQAVWQGYERNKDQ9URRSDYWJKZVWV99R9XFKIPGBZYEK9SQFWZCQURUEYHVNGEJWBQHWSRIMLBXRFGWDUMKJHLHBQJGBFFRCVMNHMCPYXFBNYWQNLQNFOIYFZZNBNMSIUS9QYFGNATQSEYKIWU9ZVDGZXADBPAIQHZNG9TZEHOSOWKDUFWVGTVACJAKFZYCNUJWFAS
    Address: IDSWNWLGPFLAQADAEYUINRS9MBEMCYARHXHVSBOZDOBHPIPNVYUFFTQLNYGDZKKTEBHYOQXVQVHXBGXH9
    Value: 0
    CurrentIndex: 0
    LastIndex: 3
    Timestamp: 1538581563
    Bundle: PNWZBXBXDTWIBTXZVSTX9HYFRXQCZASAHXXPJQEJXRLAP9OOGBFTQPICY9LYKEVRRLDY9JUH9ICFEQUNW
    TrunkTransaction: QWUYCTXQXWWVMUSQQIXSVXNZCLALGADOVQ9YYELDJQQJB9DPKYUDUFXFLNEXALYYSOPHPFZC9BWHKX999
    BranchTransaction: LXCVIBQBONOTCDHIARBX9ZDLHGWTVSEMJYMSERFBFOTZJFXQELRNBUSTILQD9BJDDEJVODXGZSIGPJ999
    AttachmentTimestamp: 0
    Nonce: LLAZWYRYQZCJKKDPOJKYDRPAAKR
    Tag: PB9999999999999999999999999
    Tag: PB9999999999999999999999999
    Requested Hash: OVQDZDADXEWDVVPZWMYQNOFMKXINDCI9AZRDNVEIFQJUTDDWLFGLOGDTDNSFHLNUORCYWMPVLWEAO9Z9999
```

## Changing port numbers

The default port number for `UDP` is port `14600` and for `TCP` is `15600`.
If the port number used in your IOTA settings is different, you could change the port via 
protocol settings in wireshark menu.

Go to `Edit -> Preferences -> Protocols` and choose IOTA on the left side menu.
