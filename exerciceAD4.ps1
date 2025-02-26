<#
==========================================================================
Description : Création de comptes utilisateurs à partir d'un fichier CSV

Auteur : FRTDev
Date : 26/02/2025

Version : 1
==========================================================================
#>

Import-Module ActiveDirectory

# Définir le chemin du domaine
$domainDN = "DC=local,DC=anvers,DC=cub,DC=sioplc,DC=fr"

# Fonction pour créer un utilisateur
function Create-ADUser {
    param (
        [string]$FirstName,
        [string]$LastName,
        [string]$OU
    )

    $fullName = "$FirstName $LastName"
    $username = "$($FirstName.ToLower()).$($LastName.ToLower())"
    $ouPath = "OU=$OU,OU=Utilisateurs,$domainDN"

    try {
        New-ADUser -Name $fullName `
                   -GivenName $FirstName `
                   -Surname $LastName `
                   -SamAccountName $username `
                   -UserPrincipalName "$username@local.anvers.cub.sioplc.fr" `
                   -Path $ouPath `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true `
                   -AccountPassword (ConvertTo-SecureString "ChangeMe123!" -AsPlainText -Force)

        Write-Host "Compte créé avec succès pour $fullName" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Erreur lors de la création du compte pour $fullName : $_" -ForegroundColor Red
        return $false
    }
}

# Vérifier si le fichier CSV existe
$csvPath = "C:\Users\Administrateur\Desktop\script\contextecubsituation9\import.csv"
if (-not (Test-Path $csvPath)) {
    Write-Host "Le fichier import.csv n'a pas été, veuillez changer le chemin du fichier." -ForegroundColor Red
    exit
}

# Lire le fichier CSV et créer les utilisateurs
$users = Import-Csv -Path $csvPath -Delimiter ";"
$failedUsers = @()

foreach ($user in $users) {
    $success = Create-ADUser -FirstName $user.firstName -LastName $user.lastName -OU $user.OU
    if (-not $success) {
        $failedUsers += "$($user.firstName) $($user.lastName)"
    }
}

# Afficher un résumé
Write-Host "`nRésumé de la création des comptes :" -ForegroundColor Cyan
Write-Host "Nombre total de comptes traités : $($users.Count)"
Write-Host "Nombre de comptes créés avec succès : $($users.Count - $failedUsers.Count)"
if ($failedUsers.Count -gt 0) {
    Write-Host "Utilisateurs non créés :" -ForegroundColor Yellow
    $failedUsers | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
}
