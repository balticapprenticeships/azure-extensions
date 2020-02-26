Configuration xUser_CreateUserConfig {
    [CmdletBinding()]

    Param (

        [Parameter(Mandatory = $true)]
        [string]
        $nodeName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    Node $nodeName {
        xUser 'CreateUserAccount' {
            Ensure = 'Present'
            UserName = Split-Path -Path $Credentials.UserName -Leaf
            Password = $Credentials
        }
    }
    
}