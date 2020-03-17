Configuration xBaLabServerCfg {
    [CmdletBinding()]

    Param (
        
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    $features = @("Hyper-V", "RSAT-Hyper-V-Tools", "Hyper-V-Tools", "Hyper-V-PowerShell")

    Node localhost {

        LocalConfigurationManager {
            RebootNodeIfNeeded = $true
        }

        # This resource block create a local user
        xUser "CreateUserAccount" {
            Ensure = "Present"
            UserName = Split-Path -Path $Credential.UserName -Leaf
            Password = $Credential
            FullName = "Baltic Apprentice"
            Description = "Baltic Apprentice"
            PasswordNeverExpires = $true
            PasswordChangeRequired = $false
            PasswordChangeNotAllowed = $true
        }

        # This resource block adds user to a spacific group
        xGroup "AddRemoteDesktopUser"
        {
            GroupName = "Remote Desktop Users"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }

        # This resource block adds user to a spacific group
        xGroup "AddHyperVAdministrator"
        {
            GroupName = "Hyper-V Administrators"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }

        # This resource block ensures that a Windows Features (Roles) is present
        xWindowsFeatureSet "AddHyperVFeatures"
        {
            Name = $features
            Ensure = "Present"
            IncludeAllSubFeature = $true
        }
    }
    
}

Configuration xBaTestClientCfg {
    [CmdletBinding()]

    Param (
        
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    Import-DscResource -ModuleName ComputermanagementDsc, xPSDesiredStateConfiguration

    Node localhost {

        LocalConfigurationManager {
            RebootNodeIfNeeded = $true
        }

        # This resource block set the Execution Policy for the curent user
        PowerShellExecutionPolicy "ExecutionPolicyCurrentUser" 
        {
            ExecutionPolicyScope = "CurrentUser"
            ExecutionPolicy = "RemoteSigned"
        }

        # This resource block create a local user
        xUser "CreateUserAccount" 
        {
            Ensure = "Present"
            UserName = Split-Path -Path $Credential.UserName -Leaf
            Password = $Credential
            FullName = "Baltic Apprentice"
            Description = "Baltic Apprentice"
            PasswordNeverExpires = $true
            PasswordChangeRequired = $false
            PasswordChangeNotAllowed = $true
        }

        # This resource block adds user to a spacific group
        xGroup "AddRemoteDesktopUser"
        {
            GroupName = "Remote Desktop Users"
            Ensure = "Present"
            MembersToInclude = "Apprentice"
            DependsOn = "[xUser]CreateUserAccount"
        }

    }

}