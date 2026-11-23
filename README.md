Link to the slides with visuals of project

https://docs.google.com/presentation/d/195vroUGU1HZ8cTDkSDWmbZXop2TN0MsnH6BqUS43RFo/edit?usp=sharing

## Organisation (standard CTMA bioinfo)

| Dossier | Contenu | GitHub / partage UCL |
|---|---|---|
| `script/` | code d'analyse (numéroté si séquentiel) | oui |
| `results/` | résultats légers : tables, figures, rapports | oui |
| `documentation/` | notes, protocoles, décisions, `MIGRATION.md` | oui |
| `env/` | `paths.env`, `load_env.sh` (+ `paths.local.env` propre à la machine) | oui (sauf `paths.local.env`) |
| `data/` | lien → `~/Documents/Sequencing_Laptop/projects_data/2025_CTMA_BCEREUS_GENOMES/data` (+ liens vers les runs du NAS) | **non** |
| `data_proc/` | lien → `~/Documents/Sequencing_Laptop/projects_data/2025_CTMA_BCEREUS_GENOMES/data_proc` | **non** |

Données brutes de séquençage : NAS `smb://192.168.235.221/nas-ngs/data MinION/`.
Les données ne vont jamais sur GitHub ni sur le partage UCL (voir `.gitignore`).

Migré le 2026-11-23 depuis OneDrive (`2_NoGH_REPO/2025_CTMA_BCEREUS_GENOMES`) — détails dans `documentation/MIGRATION.md`.
