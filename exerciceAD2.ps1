<#
==========================================================================
Description : Création de comptes utilisateurs dans Active Directory

Auteur : FRTDev
Date : 26/02/2025

Version : 1
==========================================================================
#>

Import-Module ActiveDirectory

function Create-ADUser {
    $firstName = Read-Host "Prénom"
    $lastName = Read-Host "Nom"
    $username = Read-Host "Nom d'utilisateur"
    $password = Read-Host "Mot de passe" -AsSecureString
    $email = Read-Host "Adresse e-mail"
    $department = Read-Host "Département"
    $jobTitle = Read-Host "Titre du poste"

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
                   -ChangePasswordAtLogon $true

        # Vérification de la création
        $newUser = Get-ADUser -Identity $username
        if ($newUser) {
            Write-Host "Le compte utilisateur pour $firstName $lastName a été créé avec succès." -ForegroundColor Green
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
