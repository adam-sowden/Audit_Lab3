param (
    [string]$filename
)

Get-Content -Path $filename | ForEach-Object {
    $output=$(nslookup $_ 2>error.txt)
    if ($output -match "^.*Name:.*") {
        $out=$output -split ("Address:")
        Write-Output "$_   -- $($out[7])"
    } else {
        Write-Output "No results found for $_"
    }
}
