# Delete-all-OneStart-adhesion

## Description

`Delete-all-OneStart-adhesion.ps1` est un script PowerShell conçu pour désinstaller complètement l'application OneStart et supprimer toutes les traces associées sur un poste Windows. Il est destiné à un usage en entreprise, dans un contexte de désinfection ou de nettoyage automatisé.

Le script effectue une série d'actions pour garantir la suppression complète de OneStart, notamment :

- L'arrêt des processus liés à OneStart
- La suppression des fichiers dans les répertoires utilisateur
- Le nettoyage des clés et valeurs de registre
- La suppression des tâches planifiées créées par l'application

## Fonctionnalités

- Arrête les processus liés à OneStart (`DBar`)
- Supprime les répertoires OneStart dans :
  - `AppData\Roaming\OneStart`
  - `AppData\Local\OneStart*`
- Supprime les clés de registre :
  - `\Software\OneStart.ai` dans toutes les ruche `HKEY_USERS`
- Supprime les valeurs de registre de démarrage automatique :
  - `OneStartBar`, `OneStartBarUpdate`, `OneStartUpdate`
- Supprime les tâches planifiées :
  - `OneStart Chromium`
  - `OneStart Updater`
- Analyse tous les profils utilisateurs dans `C:\Users`

## Prérequis

- Exécution en tant qu'administrateur
- PowerShell 5.1 ou version ultérieure
- Le module `ScheduledTasks` est requis (natif à partir de Windows 8 / Server 2012)
- Autorisation d’exécution de scripts (si nécessaire) :
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope Process
