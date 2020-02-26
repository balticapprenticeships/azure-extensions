<#
Group [string] #ResourceName
{
    GroupName = [string]
    [ Credential = [PSCredential] ]
    [ Description = [string[]] ]
    [ Members = [string[]] ]
    [ MembersToExclude = [string[]] ]
    [ MembersToInclude = [string[]] ]
    [ DependsOn = [string[]] ]
    [ Ensure = [string] { Absent | Present }  ]
    [ PsDscRunAsCredential = [PSCredential] ]
}

User [string] #ResourceName
{
    UserName = [string]
    [ Description = [string] ]
    [ Disabled = [bool] ]
    [ FullName = [string] ]
    [ Password = [PSCredential] ]
    [ PasswordChangeNotAllowed = [bool] ]
    [ PasswordChangeRequired = [bool] ]
    [ PasswordNeverExpires = [bool] ]
    [ DependsOn = [string[]] ]
    [ Ensure = [string] { Absent | Present }  ]
    [ PsDscRunAsCredential = [PSCredential] ]
}
#>

Configuration baLabServerCfg {

    Param (
        [ValidateNotNullOrEmpty()]
        [string]$nodeName,

        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$credential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $nodeName {

        # This resource block creates the user
        User Apprentice {
            UserName = $credential.UserName
            Description = "Baltic Apprentice"
            Disabled = $false
            FullName = "Baltic Apprentice"
            Password = $credential.Password # This needs to be a credentials object
            PasswordChangeNotAllowed = $false
            PasswordChangeRequired = $false
            PasswordNeverExpires = $true
            Ensure = "Present" # To ensure that the account does not exist and is created
        }
    }
}