# Define the username, password, display name, and description
$username = "@username@"
$password = "@password@"  # Change this to the desired password
$displayName = "@userDisplayName@"  # Change this to the desired display name
$description = "@userDescription"  # Change this to the desired description

# Check if the user already exists
$existingUser = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

if ($existingUser -eq $null) {
    # User does not exist, create it and enable the account
    New-LocalUser -Name $username -Password (ConvertTo-SecureString $password -AsPlainText -Force) -Description $description -FullName $displayName -AccountNeverExpires -PasswordNeverExpires -UserMayNotChangePassword
    Write-Host "User '$username' created and enabled successfully."

    # Add the user to the 'users' local group
    Add-LocalGroupMember -Group "Users" -Member $username
    Write-Host "User '$username' added to the 'Users' local group."
} else {
    # User already exists, update the password, display name, description, and enable the account if it's not already enabled
    Set-LocalUser -Name $username -Password (ConvertTo-SecureString $password -AsPlainText -Force) -Description $description -FullName $displayName -PasswordNeverExpires -UserMayNotChangePassword
    Write-Host "User '$username' password, display name, description, and enabled status updated successfully."

    # Check if the account is not enabled and enable it
    if ($existinser.Enabled -eq $false) {
        Enable-LocalUser -Name $username
        Write-Host "User '$username' has been enabled."
    }
    # Check if the user is not a member of the 'users' local group and add them
    if (-not (Get-LocalGroupMember -Group "Users" | Where-Object { $_.Name -eq $username })) {
        Add-LocalGroupMember -Group "Users" -Member $username
        Write-Host "User '$username' added to the 'Users' local group."
    }
}
