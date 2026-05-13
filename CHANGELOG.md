# Changelog

## [1.0.0] — 2026-05-13

### Ajouté

- **5 agents** couvrant le cycle SDD complet :
  - `ottho-code_brainstorming` (5 questions structurantes)
  - `ottho-code_spec-writer` (fiche SDD Given-When-Then)
  - `ottho-code_architect` (plan technique, stack stricte)
  - `ottho-code_developer` (implémentation code, branche feature)
  - `ottho-code_tester` (tests Vitest, verdict final)
- **1 skill** : `ottho-code_sdd-feature-cycle` — orchestre les 5 agents en séquence.
- **1 slash command** : `/ottho-code:new-feature` — démarre le cycle complet.
- **Stack imposée non-négociable** dans les agents architect/developer/tester : Next.js + Tailwind + shadcn/ui + Supabase + Resend + Vercel. Pas de Drizzle. Pas de GitHub Actions YAML.
- **Blocage explicite** du mode plan natif Claude Code dans les prompts (évite que Claude propose `Subagent-Driven`/`Parallel Session` après une phase).
- **4 MCP préconfigurés** : `supabase`, `resend`, `vercel`, `github`.
- **1 template** : `feature-spec.md.template`.
- **`userConfig`** : 4 credentials optionnels (Supabase, Resend, Vercel, GitHub), tous `sensitive`.
- README, LICENSE, CHANGELOG.

### Notes

- Version "lite" du plugin Ottho Code App, dimensionnée pour le cours 2h.
- 100 % générique : utilisable pour tout projet interne, sans présupposé sur le domaine.
- Pas de hooks, pas de scripts.
- Pour la version complète (9 agents, hooks de sécurité, phases Plan/Implement/Validate), voir `ottho-code-app`.
