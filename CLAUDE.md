# 2025_CTMA_BCEREUS_GENOMES — consignes du projet

- Type : bioinformatique (CTMA). Les règles globales sont dans `~/.claude/CLAUDE.md`.
- Objet : Génomes B. cereus : assemblage, mapping phages, variants.
- Arborescence standard : voir `README.md` (script/, results/, documentation/, env/, data/, data_proc/).
- `data/` et `data_proc/` sont des liens vers `~/Documents/Sequencing_Laptop/projects_data/2025_CTMA_BCEREUS_GENOMES/` ;
  données brutes sur le NAS. Ne jamais commiter de données ni de fichier > 50 Mo.
- Chemins : `source env/load_env.sh` (bash) charge `env/paths.env`, le profil machine puis `env/paths.local.env`.
- Le code et les résultats légers sont copiés chaque nuit vers le partage UCL
  (`ctma/Labo/Emile_Van_Cau/Projects/01_Bioinformatics/2025_CTMA_BCEREUS_GENOMES`) par `~/bin/mirror_bioinfo_to_ucl.sh`.
