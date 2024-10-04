Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline

<#$DL = "DL_AllEmployees_ProTurf@senske.com"

# Import the CSV file
$data = Import-Csv -Path "C:\temp\groups.csv"

$Matched = import-csv -Path "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\MDTeam\MD_MatchedEmails_Revised.csv"

# Select the desired column and convert it to a comma-separated list
$list = $data | Select-Object -ExpandProperty OldUPN
$Members = $list.Trim() -join ","

New-DistributionGroup -Name "AllEmployees_ProTurf" -PrimarySmtpAddress $DL -Type "Security"#>

$Data = Import-Csv -Path "C:\Users\ZachThomas\Trusted Tech Team, Irvine\ProServices - Delivery - Documents\Clients\Vetcor\Shared_Distribution Groups - Distribution Groups.csv"
$Members = @()
foreach ($row in $data) {
    $Name = "Cheifs of Staff"
    $DL = "cos@vetcor.com"
    $members = @{aabbott@vetcor.com, aalderson@vetcor.com, abaffi@vetcor.com, abaley@vetcor.com, abanzhof@vetcor.com, abarnard@vetcor.com, abhan@vetcor.com, abizzul@vetcor.com, abraun@vetcor.com, aburrington@vetcor.com, acasaldi@vetcor.com, acasida@vetcor.com, achai@vetcor.com, acoppola@vetcor.com, acowell@vetcor.com, aczarnomski@vetcor.com, adahl@vetcor.com, adennis@vetcor.com, adiangelis@vetcor.com, adyal@vetcor.com, aernstberger@vetcor.com, afedash@vetcor.com, aforster@vetcor.com, agalanski@vetcor.com, agallagher@vetcor.com, agentili-lloyd@vetcor.com, ahakert@vetcor.com, ahampton@vetcor.com, ahansen@vetcor.com, aharrisonjackson@vetcor.com, ahelburn@vetcor.com, ahensen@vetcor.com, ahille@vetcor.com, ahoffman@vetcor.com, aholden@vetcor.com, ahurley@vetcor.com, ajackson@vetcor.com, ajenison@vetcor.com, ajenkins@vetcor.com, ajillson@vetcor.com, ajones@vetcor.com, akao@vetcor.com, akaser@vetcor.com, aklotz@vetcor.com, aklugbarrett@vetcor.com, akoenitzer@vetcor.com, alabesky@vetcor.com, alabib@vetcor.com, aladman@vetcor.com, alankirmayer@vetcor.com, alockwood@vetcor.com, amadden-heinzen@vetcor.com, amandawolf@vetcor.com, amane@vetcor.com, amathiak@vetcor.com, amaxwell@vetcor.com, amcintosh@vetcor.com, amercer@vetcor.com, ameyer@vetcor.com, amiller@vetcor.com, amisner@vetcor.com, amiz@vetcor.com, amoede@vetcor.com, amueller@vetcor.com, amulloy@vetcor.com, annalarson@vetcor.com, aodonnell@vetcor.com, aoliver@vetcor.com, aoratio@vetcor.com, apasallo@vetcor.com, apawlowski@vetcor.com, apinks@vetcor.com, apletscher@vetcor.com, apolizzi@vetcor.com, aportnoy@vetcor.com, aprudom@vetcor.com, ariddick@vetcor.com, aridenour@vetcor.com, aroberts@vetcor.com, arodeghiero@vetcor.com, aroe@vetcor.com, arosenblatt@vetcor.com, arudigier@vetcor.com, asekhon@vetcor.com, ashah@vetcor.com, ashleygallagher@vetcor.com, asinghsaini@vetcor.ca, asmiley@vetcor.com, asmith@vetcor.com, asmitley@vetcor.com, asoscia@vetcor.com, asprague@vetcor.com, astead@vetcor.com, asteckley@vetcor.com, astuart@vetcor.com, asumpter@vetcor.com, ataylor@vetcor.com, atucker@vetcor.com, awalkup@vetcor.com, awarbington@vetcor.com, awarburton@vetcor.com, awarren@vetcor.com, awolf@vetcor.com, azcalhoun@vetcor.com, badler@vetcor.com, bbanning@vetcor.com, bbarboni@vetcor.com, bbattier@vetcor.com, bbaum@vetcor.com, bbechtel@vetcor.com, bberrett@vetcor.com, bbuckiohm@vetcor.com, bcahoon@vetcor.com, bcohn@vetcor.com, bcox@vetcor.com, bdavis@vetcor.com, bdelanavarre@vetcor.com, bettertogether@vetcor.com, bhaag@vetcor.com, bhaning@vetcor.com, bhelms@vetcor.com, bhensley@vetcor.com, bhixson@vetcor.com, bholley@vetcor.com, bholt@vetcor.com, bholub@vetcor.com, bimus@vetcor.com, bkeller@vetcor.com, bkimla@vetcor.com, bknutson@vetcor.com, blaing@vetcor.ca, blandry@vetcor.com, blewis-strothmann@vetcor.com, bliebert@vetcor.com, blong@vetcor.com, bmidthun@vetcor.com, bmorse@vetcor.com, bmortimer@vetcor.com, bnelson@vetcor.com, bpanter@vetcor.com, bpigsley@vetcor.com, bpribyl@vetcor.com, bramsey@vetcor.com, brandismith@vetcor.com, breasmith@vetcor.com, brendonlaing@vetcor.ca, brianjones@vetcor.com, brobinson@vetcor.com, brohleder@vetcor.com, bsalinger@vetcor.com, bsantos@vetcor.com, bschumacher@vetcor.com, bsmith@vetcor.com, bspofford@vetcor.com, btalbot@vetcor.com, btemple@vetcor.com, btyler@vetcor.com, bvangorder@vetcor.com, bvitelli@vetcor.com, bwatson@vetcor.com, bweicht@vetcor.com, c.oneill@vetcor.com, calsford@vetcor.com, calwang@vetcor.com, cameronthompson@vetcor.com, cbaker@vetcor.com, cbond@vetcor.com, cbrackett@vetcor.com, cbrunner@vetcor.com, ccaffarella@vetcor.com, ccassidy@vetcor.com, ccavanaugh@vetcor.com, ccoe@vetcor.com, ccourtney@vetcor.com, cculham@vetcor.com, cdame@vetcor.com, cdotson@vetcor.com, cerickson@vetcor.com, cgoldsmith@vetcor.com, cgood@vetcor.com, cgrant@vetcor.com, cgrattan@vetcor.com, cgraybush@vetcor.com, cguidry@vetcor.com, cgunderson@vetcor.com, chadharris@vetcor.com, chall@vetcor.com, chammons@vetcor.com, channey@vetcor.com, charker@vetcor.com, charris@vetcor.com, chawn@vetcor.com, chicks@vetcor.com, chipbeall@vetcor.com, chornsby@vetcor.com, christucker@vetcor.com, cjaques@vetcor.com, ckacocha@vetcor.com, ckalwa@vetcor.com, ckay@vetcor.com}
    $MA = $members -split ", "
    New-DistributionGroup -Name $Name -PrimarySmtpAddress $DL -Type "Security"
    foreach ($member in $MA) {
        $mem = $member.Trim()
        Add-DistributionGroupMember -Identity $DL -Member $mem
    }
}


$memlist = foreach ($row in $data) {
    $members = $row.Members
    $MA = $members -split "`n"
    foreach ($member in $MA) {
        $m = $null
        $mem = $member.Trim()
        if ($mem -notlike "*mdteam.com*" -and $mem -notlike "*cardinalaluminum.com*" -and $mem -notlike "*caulksandsealants.com*" -and $mem -notlike "*customdoorthresholds.com*" -and $mem -notlike "*designermoulding.com*" -and $mem -notlike "*loxcreen.com*" -and $mem -notlike "*loxcreenflooring.com*" -and $mem -notlike "*macdunc.com*" -and $mem -notlike "*mdintellishade.com*" -and $mem -notlike "*reliablehomeproducts.com*" -and $mem -notlike "*towersealants.com*" -and $mem -notlike "*trustedhomeproducts.com*") {
            $m = $mem
        }
        if ($m) {
        $List = [PSCustomObject]@{
            Member = $m
        }
        $List
    }
    }
}

$memlist | Export-Csv -Path "C:\temp\Contacts_MDTeam.csv" -NoTypeInformation


#NewContacts

$Contacts = Import-Csv -Path "C:\temp\Contacts_MDTeam.csv"

$contacts | foreach {
    $Contact = $_.Member
    $Parts = $Contact -split "@", 2
    $name = $Parts[0]
    New-MailContact -Name $Name -ExternalEmailAddress $Contact
}


#UpdateGroups

$Groups = @()
$Groups = $Data.Email

foreach ($row in $Groups) {
    Set-DistributionGroup -Identity $row -RequireSenderAuthenticationEnabled $false
}







