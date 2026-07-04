$owner = "MartinGrziwa287"
$repos = @(
    "vela-control-panel",
    "vela-brand"
)

$projekteRoot = Split-Path -Parent $PSScriptRoot | Split-Path -Parent

foreach ($repo in $repos) {
    $target = Join-Path $projekteRoot $repo
    if (Test-Path $target) {
        Write-Host "Uebersprungen (existiert bereits): $target"
        continue
    }
    gh repo clone "$owner/$repo" $target
}
