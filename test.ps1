
Connect-AzureAD -TenantId "1b8b93e0-fc23-441e-ab35-a908300672d3"


$appName = "TailwindTradersSalesApp"
$appURI = "https://tailwindtraderssalesapp.twtmitt.onmicrosoft.com"
$appHomePageUrl = "http://www.tailwindtraders.com/"
$appReplyURLs = @($appURI, $appHomePageURL, "https://localhost:1234")

$myApp = New-AzureADApplication -DisplayName $appName -IdentifierUris $appURI -Homepage $appHomePageUrl -ReplyUrls $appReplyURLs    
