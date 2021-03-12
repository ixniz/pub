# https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/joindomainorworkgroup-method-in-class-win32-computersystem

<#
0x10000000
0x00010000
0x00001000
0x00000080
0x00000040
0x00000020
0x00000001
=
0x10011141
#>

<#PS C:\Users\Administrator>#> $ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem
<#PS C:\Users\Administrator>#> $fJoinOptions = 0x10011141
<#PS C:\Users\Administrator>#> $fJoinOptions
#268505409
<#PS C:\Users\Administrator>#> $ComputerSystem.JoinDomainOrWorkgroup([string]'testlab.local', $null, $null, $null, $fJoinOptions)

<#
__GENUS          : 2
__CLASS          : __PARAMETERS
__SUPERCLASS     :
__DYNASTY        : __PARAMETERS
__RELPATH        :
__PROPERTY_COUNT : 1
__DERIVATION     : {}
__SERVER         :
__NAMESPACE      :
__PATH           :
ReturnValue      : 0
PSComputerName   :
#>
