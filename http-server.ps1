param([int]$Port = 8080)

$url = "http://localhost:$Port/"

$http = [System.Net.HttpListener]::new()
$http.Prefixes.Add($url)
$http.Start()
    
if ($http.IsListening) {
    Write-Host "Listening to $url"
    Start-Process $url
}
    
function Invoke-Response ([System.Net.HttpListenerContext]$Context, [string] $FileName) {
    $path = "html-out\$FileName"
    
    if (!(Test-Path $path)) {
        Write-Warning "$($context.Request.UserHostAddress)  => Not found: GET $($context.Request.Url)"
        $Context.Response.StatusCode = 404
        return
    }
    
    # image content
    if ($context.Request.RawUrl.EndsWith('jpg')) {
        $buffer = Get-Content $path
    
        $content = [System.IO.File]::ReadAllBytes($path)
        $Context.Response.ContentLength64 = $content.Count
        $Context.Response.OutputStream.Write($content, 0, $content.Length);
        return
    }
    
    # text content
    [string]$html = Get-Content $path
    
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
    $Context.Response.ContentLength64 = $buffer.Length
    $Context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
    $Context.Response.OutputStream.Close()    
}

while ($http.IsListening) {
    $context = $http.GetContext()
    if ($context.Request.HttpMethod -Ne 'GET') { continue }
    
    Write-Host "$($context.Request.UserHostAddress)  =>  GET $($context.Request.Url)"
    if ($context.Request.RawUrl -Eq '/') {
        Invoke-Response $context index.html
    }
    if ($context.Request.RawUrl -Ne '/') {
        Invoke-Response $context $context.Request.RawUrl
    }
}