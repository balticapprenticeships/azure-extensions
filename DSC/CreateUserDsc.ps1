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
                
        # Credentials
        [System.Management.Automation.PSCredential]$credential
    )

    [System.Management.Automation.PSCredential]$userName = New-Object System.Management.Automation.PSCredential ($credential.UserName)
    [System.Management.Automation.PSCredential]$userPassword = New-Object System.Management.Automation.PSCredential ($credential.Password)

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node localhost {

        # This resource block creates the user
        User Apprentice {
            UserName = $userName
            Description = "Baltic Apprentice"
            Disabled = $false
            FullName = "Baltic Apprentice"
            Password = $userPassword # This needs to be a credentials object
            PasswordChangeNotAllowed = $false
            PasswordChangeRequired = $false
            PasswordNeverExpires = $true
            Ensure = "Present" # To ensure that the account does not exist and is created
        }
    }
}