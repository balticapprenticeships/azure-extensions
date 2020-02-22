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

Configuration BaLabServerCfg {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node 'localhost' {

        # This resource block creates the user group
        Group AddUserToLocalApprenticeGroup {
            GroupName = "Apprenticegroup"
            Description = "Local Apprentice group"
            Ensure = "Present" #Ensures that the group is created
        }

        # This resource block creates the user
        User Apprentice {
            UserName = [string]
            Description = "Baltic Apprentice"
            Disabled = $false
            FullName = "Baltic Apprentice"
            Password = $passwordCred # This needs to be a credentials object
            PasswordChangeNotAllowed = $false
            PasswordChangeRequired = false
            PasswordNeverExpires = $true
            DependsOn = "[Group]Apprentice" #This will ensure that the group is configured first
            Ensure = "Present" # To ensure that the account does not exist and is created
            PsDscRunAsCredential = [PSCredential]
        }
    }
}