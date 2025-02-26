<#
==========================================================================
Description : Création de comptes utilisateurs dans Active Directory avec OU spécifique

Auteur : FRTDev
Date : 26/02/2025

Version : 1
==========================================================================
#>

Import-Module ActiveDirectory

$domainDN = "DC=local,DC=anvers,DC=cub,DC=sioplc,DC=fr"
$baseOU = "OU=Utilisateurs,$domainDN"

function Create-ADUser {
    $firstName = Read-Host "Prénom"
    $lastName = Read-Host "Nom"
    $username = Read-Host "Nom d'utilisateur"
    $password = Read-Host "Mot de passe" -AsSecureString
    $email = Read-Host "Adresse e-mail"
    $department = Read-Host "Département"
    $jobTitle = Read-Host "Titre du poste"

    # Choix de l'OU
    Write-Host "Choisissez l'unité d'organisation :"
    Write-Host "1. Administration"
    Write-Host "2. Clients"
    Write-Host "3. Développeurs"
    Write-Host "4. Production"
    $ouChoice = Read-Host "Entrez le numéro de votre choix"

    switch ($ouChoice) {
        "1" { $ouPath = "OU=Administration,$baseOU" }
        "2" { $ouPath = "OU=Clients,$baseOU" }
        "3" { $ouPath = "OU=Développeurs,$baseOU" }
        "4" { $ouPath = "OU=Production,$baseOU" }
        default { $ouPath = $baseOU }
    }

    try {
        New-ADUser -Name "$firstName $lastName" `
                   -GivenName $firstName `
                   -Surname $lastName `
                   -SamAccountName $username `
                   -UserPrincipalName "$username@local.anvers.cub.sioplc.fr" `
                   -EmailAddress $email `
                   -Department $department `
                   -Title $jobTitle `
                   -AccountPassword $password `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true `
                   -Path $ouPath

        # Vérification de la création
        $newUser = Get-ADUser -Identity $username -Properties DistinguishedName
        if ($newUser) {
            Write-Host "Le compte utilisateur pour $firstName $lastName a été créé avec succès dans $($newUser.DistinguishedName)" -ForegroundColor Green
        } else {
            Write-Host "Erreur : Le compte utilisateur n'a pas été trouvé après la création." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Erreur lors de la création du compte utilisateur : $_" -ForegroundColor Red
    }
}

do {
    Create-ADUser
    $continue = Read-Host "Voulez-vous créer un autre compte utilisateur ? (O/N)"
} while ($continue -eq "O")

Write-Host "Fin du script de création de comptes utilisateurs." -ForegroundColor Cyan
