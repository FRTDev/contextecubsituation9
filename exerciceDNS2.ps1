<#
==========================================================================
Description : G�rer le service DNS (Enregistrement A ou CNAME)

Auteur : FRTDev
Date : 26/02/2025

Version : 2
==========================================================================
#>

# Demande le nombre d'h�tes � enregistrer
$nombreHotes = Read-Host "Combien d'h�tes souhaitez-vous enregistrer ?"

# Boucle pour chaque h�te
for ($i = 1; $i -le $nombreHotes; $i++) {
    # Demande le type d'enregistrement avec v�rification
    do {
        $typeEnregistrement = Read-Host "Quel type d'enregistrement souhaitez-vous pour l'h�te $i ? (A/CNAME)"
        if ($typeEnregistrement -ne "A" -and $typeEnregistrement -ne "CNAME") {
            Write-Host "Type d'enregistrement non reconnu. Veuillez choisir A ou CNAME." -ForegroundColor Yellow
        }
    } while ($typeEnregistrement -ne "A" -and $typeEnregistrement -ne "CNAME")

    $nomHote = Read-Host "Entrez le nom de l'h�te $i"

    if ($typeEnregistrement -eq "A") {
        $adresseIP = Read-Host "Entrez l'adresse IP pour $nomHote"

        try {
            # Ajout de l'enregistrement DNS de type A
            Add-DnsServerResourceRecordA -Name $nomHote -ZoneName "local.anvers.cub.sioplc.fr" -IPv4Address $adresseIP -ErrorAction Stop
            Write-Host "L'enregistrement A pour $nomHote ($adresseIP) a �t� ajout� avec succ�s." -ForegroundColor Green
        }
        catch {
            Write-Host "Erreur lors de l'ajout de l'enregistrement A pour $nomHote : $_" -ForegroundColor Red
        }
    }
    else {
        $hostCible = Read-Host "Entrez le nom de l'h�te cible pour le CNAME $nomHote"

        try {
            # Ajout de l'enregistrement DNS de type CNAME
            Add-DnsServerResourceRecordCName -Name $nomHote -HostNameAlias $hostCible -ZoneName "local.anvers.cub.sioplc.fr" -ErrorAction Stop
            Write-Host "L'enregistrement CNAME pour $nomHote (pointant vers $hostCible) a �t� ajout� avec succ�s." -ForegroundColor Green
        }
        catch {
            Write-Host "Erreur lors de l'ajout de l'enregistrement CNAME pour $nomHote : $_" -ForegroundColor Red
        }
    }
}
