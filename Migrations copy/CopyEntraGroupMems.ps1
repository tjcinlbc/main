$OldGroupID = "4c76c2a0-043a-420d-83b6-31212d8f2cfd"
$NewGroupID = "c45f3a92-d4a1-4ed7-ba42-f80b03ea6f31"

Connect-AzureAD 

$OldMem = Get-AzureADGroupMember -ObjectId $OldGroupID -All $true

foreach ($ID in $OldMem.ObjectId) {
    Add-AzureADGroupMember -ObjectId $NewGroupID -RefObjectId $ID
}