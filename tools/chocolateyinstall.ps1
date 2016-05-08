$ErrorActionPreference = 'Stop'; # stop on all errors

# http://www.scootersoftware.com/support.php?zz=kb_vcs

# Git for Windows
where.exe git /q

if ($LASTEXITCODE -eq 0)
{
    Write-Verbose "Configuring git.exe"

    git config --global diff.tool bc3
    git config --global difftool.bc3.path "c:/Program Files (x86)/Beyond Compare 4/bcomp.exe"

    git config --global merge.tool bc3
    git config --global mergetool.bc3.path "c:/Program Files (x86)/Beyond Compare 4/bcomp.exe"
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
        Write-Warning ("Old value - Diff: " + $old)
    }
    $r.SetValue("Diff", '"C:\Program Files (x86)\Beyond Compare 4\BComp.exe" %base %mine /title1=%bname /title2=%yname /leftreadonly', [Microsoft.Win32.RegistryValueKind]::String)

    $old = $r.GetValue("Merge")
    if ($old)
    {
        Write-Warning ("Old value - Merge: " + $old)
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
        Write-Warning ("Old value - Diff: " + $old)
    }
    $r.SetValue("Diff", '"C:\Program Files (x86)\Beyond Compare 4\BComp.exe" %base %mine /title1=%bname /title2=%yname /leftreadonly', [Microsoft.Win32.RegistryValueKind]::String)

    $old = $r.GetValue("Merge")
    if ($old)
    {
        Write-Warning ("Old value - Merge: " + $old)
    }
    $r.SetValue("Merge", '"C:\Program Files (x86)\Beyond Compare 4\BComp.exe" %mine %theirs %base %merged /title1=%yname /title2=%tname /title3=%bname /title4=%mname', [Microsoft.Win32.RegistryValueKind]::String)
    $r.Close()
    $keySoftware.Close()
}
