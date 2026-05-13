---
description: Cycle SDD complet (Brainstorm → Specify → Plan → Implement → Validate) orchestré par 5 agents du plugin ottho-code
---

# /ottho-code:new-feature

Démarre le **cycle SDD complet** du plugin ottho-code. 5 phases, 5 agents, orchestrés en séquence avec une validation humaine entre chaque.

⚠️ **N'utilise PAS le mode plan natif Claude Code** (`EnterPlanMode`, skills `write-plan`, `subagent-driven-development`, `execute-plan`). Toute l'orchestration passe par les agents du plugin ottho-code. Si à un moment Claude te propose un menu "Subagent-Driven / Parallel Session / Type something / Chat about this", refuse et continue le cycle des agents.

## Séquence d'exécution

### 1. Pré-check + setup

- **Vérifie qu'on est dans un projet déjà bootstrappé** : présence d'un `package.json` à la racine. Si absent : refuse et redirige l'utilisateur vers `/ottho-code:new-project` pour démarrer un nouveau projet.

- **Crée `.claude/settings.json` s'il n'existe pas**, avec le contenu suivant. Ce fichier désactive les skills natives Claude Code qui interfèrent avec l'orchestration des 5 phases du plugin (sinon Claude propose un menu "Subagent-Driven / Parallel Session" après chaque agent, ou détourne le flow vers des skills comme `requesting-code-review` ou `finishing-a-development-branch`). Ces skills désactivées le sont **uniquement dans ce projet**, pas globalement.

  ```json
  {
    "skillOverrides": {
      "brainstorming": "off",
      "brainstorm": "off",
      "write-plan": "off",
      "writing-plans": "off",
      "subagent-driven-development": "off",
      "execute-plan": "off",
      "executing-plans": "off",
      "dispatching-parallel-agents": "off",
      "finishing-a-development-branch": "off",
      "requesting-code-review": "off"
    }
  }
  ```

  Si `.claude/settings.json` existe déjà, **fusionne** le bloc `skillOverrides` avec l'existant sans écraser les autres clés.

  Couverture par phase :
  - **Brainstorm** → désactive `brainstorming`/`brainstorm` (sinon doublon avec notre agent)
  - **Specify / Plan** → désactive `write-plan`/`writing-plans`/`execute-plan`/`executing-plans` (sinon menu après le cadrage et après le plan technique)
  - **Implement** → désactive `subagent-driven-development`/`dispatching-parallel-agents` (sinon menu après chaque commit de l'implémentation)
  - **Validate** → désactive `requesting-code-review`/`finishing-a-development-branch` (sinon menu après les tests verts)

- Si `briefs/` n'existe pas, le créer.
- Si `specs/` n'existe pas, le créer.
- Si `plans/` n'existe pas, le créer.
- Détermine le numéro de US :
   - Liste les fichiers `briefs/US-*.md` et `specs/US-*.md`
   - Le nouveau numéro = max(existants) + 1 (padding 2 chiffres : `US-01`, `US-02`)
   - Ce numéro est **partagé** entre brief, spec et plan d'une même feature.

### 2. Phase Brainstorm

Invoque l'agent **`ottho-code_brainstorming`** via `Task(...)` avec en contexte :
- L'objectif : cadrer une nouvelle feature
- Le numéro de US déterminé à l'étape 1
- Le contexte projet : si déjà connu via le dossier courant, l'utiliser ; sinon laisser l'agent demander à l'utilisateur de décrire **son** besoin sans suggérer de catégorie.

L'agent pose ses **5 questions structurantes** (problème, persona, succès, contraintes, hors-scope) et **écrit** le brief dans `briefs/US-XX-<slug>.md`.

**STOP** — affiche le brief et demande validation :
> "Brief validé ? Tape `oui` pour passer à la rédaction de la fiche SDD, ou `non` + tes ajustements."

### 3. Phase Specify

Une fois le brief validé, invoque **`ottho-code_spec-writer`** via `Task(...)` avec :
- Le chemin du brief : `briefs/US-XX-<slug>.md`
- Le numéro de US (même que le brief)
- Le template `${CLAUDE_PLUGIN_ROOT}/templates/feature-spec.md.template`

L'agent lit le brief et produit la fiche SDD dans `specs/US-XX-<slug>.md`.

**STOP** — validation humaine :
> "Fiche SDD validée ? Tape `oui` pour passer au plan technique, ou `non` + tes ajustements."

### 4. Phase Plan

Invoque **`ottho-code_architect`** via `Task(...)` avec :
- Le chemin de la fiche : `specs/US-XX-<slug>.md`

L'agent produit le plan technique dans `plans/US-XX-<slug>.md`, en respectant la **stack imposée non-négociable** (Next.js + Tailwind + shadcn/ui + @supabase/ssr + resend + Vercel, sans Drizzle, sans CI YAML).

**STOP** — validation humaine :
> "Plan technique validé ? Tape `oui` pour passer à l'implémentation, ou `non` + tes ajustements."

### 5. Phase Implement

Invoque **`ottho-code_developer`** via `Task(...)` avec :
- Le chemin de la fiche : `specs/US-XX-<slug>.md`
- Le chemin du plan : `plans/US-XX-<slug>.md`

L'agent crée la branche `feature/US-XX-<slug>`, implémente le code étape par étape, commits atomiques.

**STOP** — validation humaine après l'implémentation initiale :
> "Implémentation OK ? Tape `oui` pour passer aux tests, ou `non` + tes ajustements."

### 6. Phase Validate

Invoque **`ottho-code_tester`** via `Task(...)` avec :
- Le chemin de la fiche : `specs/US-XX-<slug>.md`
- Le chemin du plan : `plans/US-XX-<slug>.md`

L'agent écrit les tests (Vitest, éventuellement Playwright), les exécute, rapporte.

Si tests rouges à cause du code → re-invoque `ottho-code_developer` avec les échecs.
Si tests verts → fin du cycle.

### 7. Conclusion

Affiche un récap final :

```
✅ Cycle SDD terminé pour US-XX

📋 Brief : briefs/US-XX-<slug>.md
📄 Fiche SDD : specs/US-XX-<slug>.md
🛠️  Plan technique : plans/US-XX-<slug>.md
💻 Code : branche feature/US-XX-<slug>
🧪 Tests : N tests verts, X% coverage

🎯 Prochaines étapes (hors plugin) :
  - Push la branche : git push -u origin feature/US-XX-<slug>
  - Ouvre une PR vers main via le MCP github
  - Une preview Vercel sera générée automatiquement
  - Merge la PR → la prod se met à jour automatiquement
```

## Règles strictes

- Une seule feature à la fois (pas de cadrage parallèle).
- **Validation humaine obligatoire** entre chaque phase.
- **Tu n'utilises PAS** le mode plan natif Claude Code, ni les skills `write-plan`/`subagent-driven-development`/`execute-plan`.
- Si Claude affiche un menu "Subagent-Driven / Parallel Session / Type something / Chat about this", **réponds toujours `Type something` (option 3)** et continue le cycle des agents du plugin.
- Tu fonctionnes pour **tout type de projet interne**, sans présupposer le domaine.
