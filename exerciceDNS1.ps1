<#
==========================================================================
Description : G�rer le service DNS (Enregistrement A)

Auteur : FRTDev
Date : 26/02/2025

Version : 1
==========================================================================
#>

# Demande le nombre d'h�tes � enregistrer
$nombreHotes = Read-Host "Combien d'h�tes de type A souhaitez-vous enregistrer ?"

# Boucle pour chaque h�te
for ($i = 1; $i -le $nombreHotes; $i++) {
    $nomHote = Read-Host "Entrez le nom de l'h�te $i"
    $adresseIP = Read-Host "Entrez l'adresse IP pour $nomHote"

    try {
        # Ajout de l'enregistrement DNS de type A
        Add-DnsServerResourceRecordA -Name $nomHote -ZoneName "local.anvers.cub.sioplc.fr" -IPv4Address $adresseIP -ErrorAction Stop
        Write-Host "L'enregistrement pour $nomHote ($adresseIP) a �t� ajout� avec succ�s." -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur lors de l'ajout de l'enregistrement pour $nomHote : $_" -ForegroundColor Red
    }
}
