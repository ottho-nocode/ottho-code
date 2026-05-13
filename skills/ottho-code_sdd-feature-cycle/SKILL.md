---
name: ottho-code_sdd-feature-cycle
description: Use when the user wants to add a new feature, build a new module, implement a user story, start a new internal project, or asks "how do I build X". Guides through the complete SDD cycle (5 phases) using 5 agents of the ottho-code plugin: brainstorming → spec-writer → architect → developer → tester. Triggers on phrases like "nouvelle feature", "ajouter une fonctionnalité", "nouveau projet interne", "je veux construire".
---

# Cycle SDD complet — Ottho Code (5 phases)

Quand l'utilisateur veut **ajouter une fonctionnalité** / **démarrer un nouveau projet interne** / **construire un module** / **implémenter une user story**, applique ce cycle.

## Principe

5 phases, 5 agents, **toutes orchestrées par le plugin ottho-code**. Tu **n'utilises pas** le mode plan natif Claude Code (`EnterPlanMode`, skills `write-plan`, `subagent-driven-development`, `execute-plan`).

Si à un moment Claude te propose un menu "Subagent-Driven / Parallel Session / Type something / Chat about this", **refuse** et continue le cycle des agents du plugin.

## Les 5 phases

### Phase 1 — Brainstorm

Invoque l'agent **`ottho-code_brainstorming`** via `Task(...)`.

- Il pose les **5 questions structurantes** : problème, persona, succès, dépendances/contraintes, hors-scope.
- Il produit un **cadrage** structuré.

**Validation humaine obligatoire** avant la phase 2.

### Phase 2 — Specify

Invoque l'agent **`ottho-code_spec-writer`** via `Task(...)`.

- Transforme le cadrage en **fiche SDD** complète (`specs/US-XX-<slug>.md`).
- Critères d'acceptation au format Given-When-Then.

**Validation humaine** avant la phase 3.

### Phase 3 — Plan

Invoque l'agent **`ottho-code_architect`** via `Task(...)`.

- Lit la fiche SDD.
- Produit le **plan technique** (`plans/US-XX-<slug>.md`).
- Stack imposée : Next.js + Tailwind + shadcn/ui + @supabase/ssr + resend + Vercel.

**Validation humaine** avant la phase 4.

### Phase 4 — Implement

Invoque l'agent **`ottho-code_developer`** via `Task(...)`.

- Crée la branche `feature/US-XX-<slug>`.
- Implémente le code étape par étape, commits atomiques.
- Respecte la stack imposée et les conventions définies par l'architect.

**Validation humaine** avant la phase 5.

### Phase 5 — Validate

Invoque l'agent **`ottho-code_tester`** via `Task(...)`.

- Écrit les tests (Vitest + éventuellement Playwright).
- Couvre chaque critère Given-When-Then de la fiche.
- Exécute la suite, rapporte les résultats.

Si tests rouges → re-invoque `ottho-code_developer`. Sinon → fin du cycle.

## Templates de référence

- Fiche SDD : `${CLAUDE_PLUGIN_ROOT}/templates/feature-spec.md.template`

## Récapitulatif visuel

```
ottho-code_brainstorming  ← 5 questions
   ↓ validation humaine
ottho-code_spec-writer    ← fiche SDD Given-When-Then
   ↓ validation humaine
ottho-code_architect      ← plan technique (stack stricte)
   ↓ validation humaine
ottho-code_developer      ← code sur branche feature
   ↓ validation humaine
ottho-code_tester         ← tests Vitest + verdict
```

## Stack imposée — non-négociable

| Couche | Choix |
|---|---|
| Framework | Next.js 16 App Router |
| Style | Tailwind CSS + shadcn/ui |
| BDD | Supabase + `@supabase/ssr` (PAS de Drizzle) |
| Email | Resend SDK direct |
| Validation | Zod |
| Tests | Vitest (Playwright optionnel) |
| CI | Vercel auto (PAS de GitHub Actions YAML) |
| Hébergement | Vercel |

## Pour aller plus loin

Cette version lite couvre les 5 phases essentielles. La méthode complète Ottho (plugin `ottho-code-app`) ajoute :
- Agent `designer` (wireframes + maquettes)
- Agent `code-reviewer` (audit qualité/sécurité)
- Agent `devops` (CI/CD pro, multi-environnements)
- Agent `doc-writer` (README, doc API)
- Hooks de sécurité Git
