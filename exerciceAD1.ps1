<#
==========================================================================
Description : Cr�ation d'unit�s d'organisation (OU) dans Active Directory

Auteur : FRTDev
Date : 26/02/2025

Version : 1
==========================================================================
#>

Import-Module ActiveDirectory

$domainDN = "DC=local,DC=anvers,DC=cub,DC=sioplc,DC=fr"

function Create-NewOU {
    $ouName = Read-Host "Entrez le nom de la nouvelle unit� d'organisation"
    $parentOU = Read-Host "Entrez le nom de l'OU parente (laissez vide si aucune)"

    if ($parentOU) {
        $ouPath = "OU=$parentOU,$domainDN"
    } else {
        $ouPath = $domainDN
    }

    try {
        New-ADOrganizationalUnit -Name $ouName -Path $ouPath -ProtectedFromAccidentalDeletion $true
        $newOU = Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -SearchBase $ouPath -SearchScope OneLevel
        
        if ($newOU) {
            Write-Host "L'OU '$ouName' a �t� cr��e avec succ�s dans $ouPath" -ForegroundColor Green
        } else {
            Write-Host "Erreur : L'OU n'a pas �t� trouv�e apr�s la cr�ation." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Erreur lors de la cr�ation de l'OU : $_" -ForegroundColor Red
    }
}

do {
    Create-NewOU
    $continue = Read-Host "Voulez-vous cr�er une autre OU ? (O/N)"
} while ($continue -eq "O")

Write-Host "Fin du script de cr�ation d'OU." -ForegroundColor Cyan
