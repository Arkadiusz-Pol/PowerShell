# Downloading a list of network adapters

Get-NetAdapter

# Checking the current settings of the selected adapter

Get-NetAdapterAdvancedProperty -Name "Adapter name"

# Changing the status of specific functions

Set-NetAdapterAdvancedProperty -Name "Ethernet 4" -DisplayName "DisplayName" -DisplayValue "Disabled"


