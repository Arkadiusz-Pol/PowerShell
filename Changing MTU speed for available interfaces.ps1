# Listing available interfaces

netsh interface ipv4 show interfaces

# Changing MTU speed for specific Interface

netsh interface ipv4 set subinterface "<Interface Name>" mtu=<NewMTUSize> store=persistent

# Checking changes

netsh interface ipv4 show subinterface "<Interface Name>"
