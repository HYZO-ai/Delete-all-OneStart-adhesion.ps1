# Supprime OneStart complétement

# Définir le chemin valide des fichiers OneStart
$valid_paths = @(
    "C:\Users\*\AppData\Roaming\OneStart\*",
    "C:\Users\*\AppData\Local\OneStart*\*"
)

# Définir le nom des process en rapprot avec OneStart
$process_names = @("DBar")

foreach ($proc in $process_names) {
    $OL_processes = Get-Process -Name $proc -ErrorAction SilentlyContinue

    if (-not $OL_processes) {
        Write-Output "Aucun processus en cours n'a ete trouve pour : $proc."
    } else {
        foreach ($process in $OL_processes) {
            try {
                Stop-Process -Id $process.Id -Force -ErrorAction Stop
                Write-Output "Processus '$proc' (PID: $($process.Id)) a ete arrete."
            } catch {
                Write-Output "Echec de l'arret du processus : '$proc': $_"
            }
        }
    }
}

Start-Sleep -Seconds 2

# Supprime tout les répertoire OneStart pour tout les utilisateurs
$file_paths = @(
    "\AppData\Roaming\OneStart\",
    "\AppData\Local\OneStart.ai",
    "\AppData\Local\OneStart*\*"  
)

foreach ($userFolder in Get-ChildItem C:\Users -Directory) {
    foreach ($fpath in $file_paths) {
        $fullPath = Join-Path $userFolder.FullName $fpath
        if (Test-Path $fullPath) {
            try {
                Remove-Item -Path $fullPath -Recurse -Force -ErrorAction Stop
                Write-Output "Supprime : $fullPath"
            } catch {
                Write-Output "Echec de la suppression : $fullPath - $_"
            }
        }
    }
}

# Supprime les clés de registre en rapport avec OneStart
$reg_paths = @("\Software\OneStart.ai")

foreach ($registry_hive in Get-ChildItem Registry::HKEY_USERS) {
    foreach ($regpath in $reg_paths) {
        $fullRegPath = "Registry::$($registry_hive.PSChildName)$regpath"
        if (Test-Path $fullRegPath) {
            try {
                Remove-Item -Path $fullRegPath -Recurse -Force -ErrorAction Stop
                Write-Output "Cle de registre supprimee : $fullRegPath"
            } catch {
                Write-Output "Echec de la suppression de la cle de registre : $fullRegPath - $_"
            }
        }
    }
}

# Supprime les propriété de registre en rapport avec les clés
$reg_properties = @("OneStartBar", "OneStartBarUpdate", "OneStartUpdate")

foreach ($registry_hive in Get-ChildItem Registry::HKEY_USERS) {
    $runKeyPath = "Registry::$($registry_hive.PSChildName)\Software\Microsoft\Windows\CurrentVersion\Run"
    
    if (Test-Path $runKeyPath) {
        foreach ($property in $reg_properties) {
            try {
                Remove-ItemProperty -Path $runKeyPath -Name $property -ErrorAction Stop
                Write-Output "Valeur de registre supprimee : $property from $runKeyPath"
            } catch {
                Write-Output "Echec de la suppression de la valeur de registre : $property from $runKeyPath - $_"
            }
        }
    }
}

# Supprime les tâches planifiées
$schtasknames = @("OneStart Chromium", "OneStart Updater")

$c = 0
foreach ($task in $schtasknames) {
    $clear_tasks = Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue

    if ($clear_tasks) {
        try {
            Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction Stop
            Write-Output "Suppression d'une tache planifiee : '$task'."
            $c++
        } catch {
            Write-Output "Echec de la suppression de la tache planifiee : '$task' - $_"
        }
    }
}

if ($c -eq 0) {
    Write-Output "Aucune tache programmee OneStart n'a ete trouvee."
}
