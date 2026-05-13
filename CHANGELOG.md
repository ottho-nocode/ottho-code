# Changelog

## [1.0.0] — 2026-05-13

### Ajouté

- **2 agents** : `ottho-code_brainstorming` (5 questions structurantes), `ottho-code_spec-writer` (fiche SDD Given-When-Then).
- **1 skill** : `ottho-code_sdd-feature-cycle` — orchestre Brainstorm → Specify.
- **1 slash command** : `/new-feature` — démarre le cycle de cadrage.
- **4 MCP préconfigurés** : `supabase`, `resend`, `vercel`, `github`.
- **1 template** : `feature-spec.md.template`.
- **`userConfig`** : 4 credentials optionnels (Supabase, Resend, Vercel, GitHub), tous `sensitive`.
- README, LICENSE, CHANGELOG.

### Notes

- Version "lite" du plugin Ottho Code App, dimensionnée pour le cours 2h.
- 100 % générique : utilisable pour tout projet interne, sans présupposé sur le domaine.
- Pas de hooks, pas de scripts.
- Pour la version complète (9 agents, hooks de sécurité, phases Plan/Implement/Validate), voir `ottho-code-app`.
