$global:config = @{   
    networkConfig         = @{    
        interfaceIndex = 8
        interfaceAlias = "Ethernet0"
        IPAddress      = "192.168.233.53"
        prefixLength   = 24
        defaultGateway = "192.168.233.2"
        serverAddress  = "127.0.0.1"
    }

    activeDirectoryConfig = @{
        netbiosName    = "NULLPTR"
        domainName     = "nullptr.local"
        safeModePasswd = "qwerty123?"
        computerName   = "DC01"
    }
}