$nsxManagerIP = "nsxmgr-l-01a.corp.local"

$nsxManagerUser = "admin"
$nsxManagerPasswd = "VMware1!"

$nsxManagerAuthorization = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($nsxManagerUser + ":" + $nsxManagerPasswd))

function invokeNSXCLICmd($commandToInvoke){
    Write-Host -ForeGroundColor Yellow "`nNote: CLI Command Invoked:" $commandToInvoke
    
    $nsxMgrCliApiURL = $nsxManagerIP+"/api/1.0/nsx/cli?action=execute"
    if ($nsxMgrCliApiURL.StartsWith("http://")){$nsxMgrCliApiURL -replace "http://", "https://"}
    elseif($nsxMgrCliApiURL.StartsWith("https://")){}
    else{$nsxMgrCliApiURL = "https://"+$nsxMgrCliApiURL}

    $xmlBody = "<nsxcli> <command> $commandToInvoke </command> </nsxcli>"
    $curlHead = @{"Accept"="text/plain"; "Content-type"="Application/xml"; "Authorization"="Basic $nsxManagerAuthorization"}

    $nsxCLIResponceweb = Invoke-WebRequest -uri $nsxMgrCliApiURL -Body $xmlBody -Headers $curlHead -Method Post
    return $nsxCLIResponceweb.content
}

invokeNSXCLICmd -commandToInvoke "show cluster all"