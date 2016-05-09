$ErrorActionPreference = 'Stop'; # stop on all errors

# See http://www.scootersoftware.com/support.php?zz=kb_vcs for suggested settings for various version control systems

$backupFolder = $env:chocolateyPackageFolder

if ($backupFolder -eq $null)
{
    # for testing in ISE only
    $backupFolder = $env:TEMP
}

# Git for Windows
where.exe git /q

if ($LASTEXITCODE -eq 0)
{
    Write-Verbose "Configuring git.exe"

    $gitconfig = "$($env:USERPROFILE)\.gitconfig"

    $backupPath = Join-Path -Path $backupFolder (".gitconfig." + [DateTime]::UtcNow.ToString("yyyyMMddHHmm"))

    Copy-Item -Path $gitconfig -Destination $backupPath
    Write-Warning "Created backup of .gitconfig at $backupPath"

    git config --global diff.tool bc
    git config --global difftool.bc.path "c:/Program Files (x86)/Beyond Compare 4/bcomp.exe"

    git config --global merge.tool bc
    git config --global mergetool.bc.path "c:/Program Files (x86)/Beyond Compare 4/bcomp.exe"
}

# TortoiseGit
if (Test-Path HKCU:\SOFTWARE\TortoiseGit)
{
    Write-Verbose "Configuring TortoiseGit"

    $keySoftware = get-item HKCU:\SOFTWARE

    $r = $keySoftware.OpenSubKey("TortoiseGit", $true)
    $old = $r.GetValue("Diff")
    if ($old -ne $null)
    {
        Write-Warning ("Old Registry value (HKCU\SOFTWARE\TortoiseGit\Diff): " + $old)
    }
    $r.SetValue("Diff", '"C:\Program Files (x86)\Beyond Compare 4\BComp.exe" %base %mine /title1=%bname /title2=%yname /leftreadonly', [Microsoft.Win32.RegistryValueKind]::String)

    $old = $r.GetValue("Merge")
    if ($old)
    {
        Write-Warning ("Old Registry value (HKCU\SOFTWARE\TortoiseGit\Merge): " + $old)
    }
    $r.SetValue("Merge", '"C:\Program Files (x86)\Beyond Compare 4\BComp.exe" %mine %theirs %base %merged /title1=%yname /title2=%tname /title3=%bname /title4=%mname', [Microsoft.Win32.RegistryValueKind]::String)
    $r.Close()
    $keySoftware.Close()
}

# TortoiseSVN
if (Test-Path HKCU:\SOFTWARE\TortoiseSVN)
{
    Write-Verbose "Configuring TortoiseSVN"

    $keySoftware = get-item HKCU:\SOFTWARE

    $r = $keySoftware.OpenSubKey("TortoiseSVN", $true)

    $old = $r.GetValue("Diff")
    if ($old -ne $null)
    {
        Write-Warning ("Old Registry value (HKCU\SOFTWARE\TortoiseSVN\Diff): " + $old)
    }
    $r.SetValue("Diff", '"C:\Program Files (x86)\Beyond Compare 4\BComp.exe" %base %mine /title1=%bname /title2=%yname /leftreadonly', [Microsoft.Win32.RegistryValueKind]::String)

    $old = $r.GetValue("Merge")
    if ($old)
    {
        Write-Warning ("Old Registry value (HKCU\SOFTWARE\TortoiseSVN\Merge): " + $old)
    }
    $r.SetValue("Merge", '"C:\Program Files (x86)\Beyond Compare 4\BComp.exe" %mine %theirs %base %merged /title1=%yname /title2=%tname /title3=%bname /title4=%mname', [Microsoft.Win32.RegistryValueKind]::String)
    $r.Close()
    $keySoftware.Close()
}
