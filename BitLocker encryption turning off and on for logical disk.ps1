# Listing available disks

Get-PhysicalDisk

#Turning off BitLocker Encryption

manage-bde -off "<Drive Letter>"

# Checking status of encryption

manage-bde -status "<Drive Letter>"

#Turning on BitLocker Encryption

manage-bde -on "<Drive Letter>"
