Function AssignStaticIP {
    # assigns ip address that user specified
    param()
    Remove-NetRoute -InterfaceIndex $global:config.networkConfig.interfaceIndex
    Remove-NetIPAddress -InterfaceIndex $global:config.networkConfig.interfaceIndex
    New-NetIPAddress -InterfaceAlias $global:config.networkConfig.interfaceAlias -AddressFamily IPv4 -IPAddress $global:config.networkConfig.IPAddress -PrefixLength $global:config.networkConfig.prefixLength -DefaultGateway $global:config.networkConfig.defaultGateway
}

Function AssignDNSServerAddress {
    #assigns dns server address that user specified
    param()
    Set-DnsClientServerAddress -InterfaceIndex $global:config.networkConfig.interfaceIndex -ServerAddresses ($global:config.networkConfig.serverAddress)
}

Function InstallActiveDirectory {
    #install and configure active directory and dns
    param()
    Write-Output "[+] Installing Windows AD Domain Services and setting up domain"
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    Add-windowsfeature RSAT-ADDS
    Import-Module ADDSDeployment

    $netbiosName = $global:config.activeDirectoryConfig.netbiosName
    $domainName = $global:config.activeDirectoryConfig.domainName
    $safeModePasswd = ConvertTo-SecureString $global:config.activeDirectoryConfig.safeModePasswd -AsPlainText -Force

    Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName $domainName -DomainNetbiosName $netbiosName -SafeModeAdministratorPassword $safeModePasswd -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$true -SysvolPath "C:\Windows\SYSVOL" -Force:$true

    Write-Output "[+] Installing Windows AD Domain Services and setting up domain"
    Write-Output "nullptr.local created"
    Write-Output "Please reboot, if not already your Domain Controller and login as the domain administrator and run setupscript2.ps1 as that use"
}

Function RenameDomainController {
    #rename computer
    param()
    $computerName = $global:config.activeDirectoryConfig.computerName
   
    Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" 
    Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" 

    Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername" -name "ComputerName" -value $computerName
    Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputername" -name "ComputerName" -value $computerName
    Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" -value $computerName
    Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" -value  $computerName
    Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "AltDefaultDomainName" -value $computerName
    Set-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -name "DefaultDomainName" -value $computerName
}

Function EnableRemoteManagement {
    #
    param()
    # Enable-PSRemoting
    # Enable-NetFirewallRule -DisplayName "Windows Management Instrumentation (DCOM-In)"
    # Enable-NetFirewallRule -DisplayGroup "Remote Event Log Management"
    # Enable-NetFirewallRule -DisplayGroup "Remote Service Management"
    # Enable-NetFirewallRule -DisplayGroup "Remote Volume Management"
    # Enable-NetFirewallRule -DisplayGroup "Windows Defender Firewall Remote Management"
    # Enable-NetFirewallRule -DisplayGroup "Remote Event Log Management"
    # Enable-NetFirewallRule -DisplayGroup "Remote Scheduled Tasks Management"

    # Set-NetFirewallRule -DisplayName "Windows Management Instrumentation (DCOM-In)" -Enabled False -PassThru
    # Set-NetFirewallRule -DisplayGroup "Remote Event Log Management" -Enabled False -PassThru
    # Set-NetFirewallRule -DisplayGroup "Remote Service Management" -Enabled False -PassThru
    # Set-NetFirewallRule -DisplayGroup "Remote Volume Management" -Enabled False -PassThru
    # Set-NetFirewallRule -DisplayGroup "Windows Defender Firewall Remote Management" -Enabled False -PassThru
    # Set-NetFirewallRule -DisplayGroup "Remote Event Log Management" -Enabled False -PassThru
    # Set-NetFirewallRule -DisplayGroup "Remote Scheduled Tasks Management" -Enabled False -PassThru
    $FwRule = "Windows Defender Firewall Remote Management"
    $GpoName = "Remote Management"
    
}

##############################      MAIN      ####################################
Function Main {
    param()    
    AssignStaticIP
    AssignDNSServerAddress
    RenameDomainController
    InstallActiveDirectory
    EnableRemoteManagement
}

# Entry point
Main
