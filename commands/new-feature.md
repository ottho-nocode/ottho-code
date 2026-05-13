---
description: Démarre le cycle SDD light pour cadrer une nouvelle feature (brainstorming + spec-writer)
---

# /new-feature

Démarre la phase **Specify** du cycle SDD : cadrer la feature en deux étapes avec deux agents spécialisés, avant d'écrire la moindre ligne de code.

## Séquence d'exécution

### 1. Pré-check

- Vérifie qu'on est bien dans un dossier projet (ou propose d'en créer un : "Tu veux que je crée un dossier projet ici ?").
- Si le dossier `specs/` n'existe pas, on le créera à l'étape 3.
- Détermine le numéro de US :
   - Liste les fichiers existants `specs/US-*.md`
   - Le nouveau numéro = max(existants) + 1, padding sur 2 chiffres (`US-01`, `US-02`, ...)

### 2. Brainstorm

Invoque l'agent `brainstorming` via `Task(...)` avec en contexte :
- L'objectif : cadrer une nouvelle feature
- Le contexte projet (si déjà connu) ou demander à l'utilisateur "C'est quel type de projet — CRM, outil RH, suivi clients, autre ?"

L'agent pose ses **5 questions structurantes** (problème, persona, succès, contraintes, hors-scope) et produit un **cadrage** structuré.

**STOP** — affiche le cadrage et demande validation :
> "Cadrage validé ? Tape `oui` pour passer à la rédaction de la fiche SDD, ou `non` + tes ajustements."

### 3. Specify

Une fois le cadrage validé, invoque l'agent `spec-writer` via `Task(...)` avec en contexte :
- Le cadrage produit par `brainstorming`
- Le numéro de US déterminé à l'étape 1
- Le template `${CLAUDE_PLUGIN_ROOT}/templates/feature-spec.md.template`

`spec-writer` produit la fiche dans `specs/US-XX-<slug>.md`.

### 4. Conclusion

Affiche un récap :

```
✅ Phase Specify terminée

📄 Fiche : specs/US-XX-<slug>.md
🎯 Prochaine étape : génère le code en t'appuyant sur la fiche.

Exemple de prompt :
"À partir de ma fiche specs/US-XX-<slug>.md, génère le code Next.js de cette feature.
Utilise le MCP supabase pour créer les tables avec RLS activée."

Les MCP disponibles :
- supabase  → BDD, migrations, RLS, types
- resend    → emails transactionnels
- vercel    → déploiement (preview + prod)
- github    → repo, branches, PR
```

## Règles strictes

- Une seule feature à la fois (pas de cadrage parallèle).
- Validation humaine obligatoire entre Brainstorm et Specify.
- Tu n'écris **pas** de code dans cette commande — elle ne fait que produire la fiche SDD.
- Tu fonctionnes pour **tout type de projet interne** (CRM, RH, suivi clients, sondage, dashboard, etc.).
