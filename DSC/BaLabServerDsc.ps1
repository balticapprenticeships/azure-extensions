Configuration BaLabServerCfg {

    Param (
        # Sets the Computer/Node name
        [Parameter(Mandatory=$true)]
        [string]
        $nodeName,

        # User credentials
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $nodeName {

        # This resource block creates the user
        User "CreateUserAccount" {
            UserName = Split-Path -Path $Credential.UserName -Leaf
            Description = "Baltic Apprentice"
            Disabled = $false
            FullName = "Baltic Apprentice"
            Password = $Credential # This needs to be a credentials object
            PasswordChangeNotAllowed = $true
            PasswordChangeRequired = $false
            PasswordNeverExpires = $true
            Ensure = "Present" # To ensure that the account does not exist and is created
        }

        # This resource block adds the user to a group
        Group "AddUserToLocalRemoteDesktopUsersGroup" {
            GroupName = "Remote Desktop Users" #Group name
            MembersToInclude = "Apprentice" #Adds the selected user
            DependsOn = "[User]CreateUserAccount" #Ensures that the user is created before added to the group
            Ensure = "Present" #Ensures that the group is present
        }

        # This resource block adds the user to a group
        Group "AddUserToLocalHypervAdministrators" {
            GroupName = "Hyper-V Administrators" #Group name
            MembersToInclude = "Apprentice" #Adds the selected user
            DependsOn = "[User]CreateUserAccount" #Ensures that the user is created before added to the group
            Ensure = "Present" #Ensures that the group is present
        }

        # This resource block ensures hat Hyper-V feature is enabled
        WindowsFeature "HyperV" {
            Name = "Hyper-V"
            IncludeAllSubFeature = $true
            Ensure = "Present"
        }

        # This resource block ensures hat Hyper-V feature is enabled
        WindowsFeature "HyperVTools" {
            Name = "Hyper-V-Tools"
            IncludeAllSubFeature = $true
            Ensure = "Present"
            DependsOn = "[WindowsFeature]HyperV"
        }

        # This resource block ensures hat Hyper-V feature is enabled
        WindowsFeature "HyperVPowershell" {
            Name = "Hyper-V-Powershell"
            IncludeAllSubFeature = $true
            Ensure = "Present"
            DependsOn = "[WindowsFeature]HyperV"
        }
    }
}

