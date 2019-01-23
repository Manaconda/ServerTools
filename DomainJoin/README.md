Adds machines from a CSV to the domain.  Will require machines have been prepped with workgroup powershell remote access.

domainjoin.ps1 <path to csv> <local admin password> <SECURE domain credential, will be prompted if not supplied>  <computer OU DN>

CSV:   

hostname
PC1
PC2
PC3
etc
