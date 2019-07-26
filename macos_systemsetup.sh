# Set current time zone to <timezone>. Use "-listtimezones" to list time zones.
sudo systemsetup -settimezone 'Europe/Berlin'

# Set using network time to either <on> or <off>.
sudo systemsetup -setusingnetworktime on

# Set network time server to <timeserver>.
sudo systemsetup -setnetworktimeserver time.apple.com

# Set restart on freeze to either <on> or <off>.
sudo systemsetup -setrestartfreeze on

# Set remote login to either <on> or <off>. Use "systemsetup -f -setremotelogin off" to suppress prompting when turning remote login off.
sudo systemsetup -f -setremotelogin off

# Set remote apple events to either <on> or <off>.
sudo systemsetup -setremoteappleevents off

# Set computer name to <computername>.
sudo systemsetup -setcomputername MBP2019

# Set local subnet name to <name>.
sudo systemsetup -setlocalsubnetname local
