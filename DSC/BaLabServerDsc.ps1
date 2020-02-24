Configuration BaLabServerCfg {

    Param (
        [string]$nodeName,
        [securestring]$passwordCred
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $nodeName {

        # This resource block ensures hat Hyper-V feature is enabled
        WindowsFeature Hyper-V {
            Name = "Hyper-V"
            IncludeAllSubFeature = $true
            Ensure = "Present"
        }

        # This resource block ensures hat Hyper-V feature is enabled
        WindowsFeature Hyper-V-Powershell {
            Name = "Hyper-V-Powershell"
            IncludeAllSubFeature = $true
            Ensure = "Present"
        }

        # This resource block creates the user
        User Apprentice {
            UserName = "Apprentice"
            Description = "Baltic Apprentice"
            Disabled = $false
            FullName = "Baltic Apprentice"
            Password = $passwordCred # This needs to be a credentials object
            PasswordChangeNotAllowed = $false
            PasswordChangeRequired = $false
            PasswordNeverExpires = $true
            Ensure = "Present" # To ensure that the account does not exist and is created
        }

        # This resource block adds the user to a group
        Group AddUserToLocalRemoteDesktopUsersGroup {
            GroupName = "Remote Desktop Users" #Group name
            MembersToInclude = "Apprentice" #Adds the selected user
            DependsOn = "[User]Apprentice" #Ensures that the user is created before added to the group
            Ensure = "Present" #Ensures that the group is present
        }

        # This resource block adds the user to a group
        Group AddUserToLocalHypervAdministrators {
            GroupName = "Hyper-V Administrators" #Group name
            MembersToInclude = "Apprentice" #Adds the selected user
            DependsOn = "[User]Apprentice" #Ensures that the user is created before added to the group
            Ensure = "Present" #Ensures that the group is present
        }
    }
}