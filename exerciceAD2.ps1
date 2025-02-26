<#
==========================================================================
Description : Cr�ation de comptes utilisateurs dans Active Directory

Auteur : FRTDev
Date : 26/02/2025

Version : 1
==========================================================================
#>

Import-Module ActiveDirectory

function Create-ADUser {
    $firstName = Read-Host "Pr�nom"
    $lastName = Read-Host "Nom"
    $username = Read-Host "Nom d'utilisateur"
    $password = Read-Host "Mot de passe" -AsSecureString
    $email = Read-Host "Adresse e-mail"
    $department = Read-Host "D�partement"
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

        # V�rification de la cr�ation
        $newUser = Get-ADUser -Identity $username
        if ($newUser) {
            Write-Host "Le compte utilisateur pour $firstName $lastName a �t� cr�� avec succ�s." -ForegroundColor Green
        } else {
            Write-Host "Erreur : Le compte utilisateur n'a pas �t� trouv� apr�s la cr�ation." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Erreur lors de la cr�ation du compte utilisateur : $_" -ForegroundColor Red
    }
}

do {
    Create-ADUser
    $continue = Read-Host "Voulez-vous cr�er un autre compte utilisateur ? (O/N)"
} while ($continue -eq "O")

Write-Host "Fin du script de cr�ation de comptes utilisateurs." -ForegroundColor Cyan
