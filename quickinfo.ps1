################################################################################
#### quickM365userInfo - https://github.com/martelrotschy/quickM365userInfo ####
################################################################################

# Prompt for Office 365 credentials
$credential = Get-Credential -Message "Enter your Office 365 credentials"

# Connect to Exchange Online
Connect-ExchangeOnline -Credential $credential

# Get a list of users in the Office 365 tenant
$users = Get-EXOMailbox -ResultSize Unlimited

# Display a numbered list of users for selection
Write-Host "Users:"
for ($i = 0; $i -lt $users.Count; $i++) {
    Write-Host ("{0}. {1}" -f ($i + 1), $users[$i].UserPrincipalName)
}

# Prompt user to select a user
$userIndex = Read-Host "Enter the number corresponding to the user:"

# Validate user selection
if (![int]::TryParse($userIndex, [ref]$null) -or $userIndex -lt 1 -or $userIndex -gt $users.Count) {
    Write-Host "Invalid selection. Please enter a valid number."
    return
}

# Get the selected user
$selectedUser = $users[$userIndex - 1]

# Display Exchange Online information for the selected user
Write-Host "User Information for $($selectedUser.UserPrincipalName):"
Get-EXOMailbox -Identity $selectedUser.UserPrincipalName | Select-Object Name, PrimarySmtpAddress, RecipientTypeDetails, WhenCreated, WhenChanged
