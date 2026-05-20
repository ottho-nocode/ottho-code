---
description: Bootstrap un nouveau projet from scratch (Next.js init + structure SDD + settings + première feature)
---

# /ottho-code:new-project

Démarre un nouveau projet **from scratch**. Crée l'infrastructure technique (Next.js + Tailwind + shadcn/ui + Supabase + structure SDD) puis enchaîne sur la première feature avec `/ottho-code:new-feature`.

⚠️ **À utiliser uniquement dans un dossier vide ou ne contenant pas encore de `package.json`**. Pour ajouter une feature à un projet existant, utilise plutôt `/ottho-code:new-feature`.

## Séquence

### 1. Pré-check

- Vérifie qu'on est bien dans un dossier vide (ou sans `package.json`). Si du code existe déjà, **refuse** et redirige vers `/ottho-code:new-feature`.

- **Demande à l'utilisateur** :
  - Le nom court du projet (ex : `mon-outil-rh`, `crm-agence`, `feedback-cohorte`) — sera utilisé pour le repo, le projet Vercel/Supabase, et le `package.json`.
  - Une **description en une phrase** du projet (ex : "Mini-CRM agence pour tracker les leads entrants").

### 2. Init Next.js

Exécute via Bash :

```bash
npx create-next-app@latest . \
  --typescript \
  --tailwind \
  --app \
  --no-src-dir \
  --import-alias "@/*" \
  --no-turbopack \
  --use-npm
```

Attends que l'install npm se termine (~2-3 min selon la connexion).

### 3. Structure SDD

Crée à la racine du projet :

- `.claude/settings.json` avec le bloc `skillOverrides` complet (10 skills désactivées, voir `/ottho-code:new-feature` pour la liste).
- Dossier `briefs/` (futurs briefs de brainstorming).
- Dossier `specs/` (futures fiches SDD).
- Dossier `design/` (briefs design par feature + design system partagé).
- Dossier `plans/` (futurs plans techniques).
- Dossier `docs/` (documentation projet, optionnel).

Crée aussi un squelette de design system à `design/system.md` à partir du template `${CLAUDE_PLUGIN_ROOT}/templates/design-system.md.template`. Demande à l'utilisateur les choix initiaux :
- **Ton visuel** (sobre/professionnel, énergique, brutaliste, minimaliste, etc.)
- **Couleur primaire** (hex ou nom)
- **1-2 inspirations** (Linear, Stripe, Notion, etc.)

Pré-remplis le template avec ces valeurs. L'agent `ottho-code_designer` viendra l'enrichir au fil des features.

### 4. CLAUDE.md projet

Crée à la racine un fichier `CLAUDE.md` avec ce contenu (adapté au projet) :

```markdown
# {{NOM_DU_PROJET}}

> {{DESCRIPTION_DU_PROJET}}

## Stack imposée

- **Framework** : Next.js 16 App Router + TypeScript
- **UI** : Tailwind CSS + shadcn/ui
- **BDD** : Supabase (Postgres + RLS obligatoire) via `@supabase/ssr`
- **Email** : Resend SDK
- **Tests** : Vitest (Playwright optionnel)
- **CI/CD** : Vercel auto (PAS de GitHub Actions YAML)
- **Hébergement** : Vercel

## Direction visuelle

Lire systématiquement `design/system.md` avant de produire du code. Ce fichier contient la palette, la typographie, les composants shadcn installés et les patterns visuels du projet. Le mettre à jour quand on introduit un nouveau pattern.

## Méthode

Toute nouvelle feature passe par le **cycle SDD du plugin ottho-code** (6 phases) :

1. `/ottho-code:brainstorm` → `briefs/US-XX-<slug>.md`
2. `/ottho-code:spec` → `specs/US-XX-<slug>.md`
3. `/ottho-code:design` → `design/US-XX-<slug>.md` (+ MAJ `design/system.md`)
4. `/ottho-code:plan` → `plans/US-XX-<slug>.md`
5. `/ottho-code:code` → code sur `feature/US-XX-<slug>`
6. `/ottho-code:test` → tests Vitest + verdict

Ou tout en un : `/ottho-code:new-feature`.

Pour un design poussé (client design-sensitive, exigences UX fortes) : invoquer `/impeccable` ou `/frontend-design` entre la phase Design et la phase Plan.

## Workflow Git

- `main` : production. Jamais commiter directement.
- `feature/US-XX-<slug>` : une branche par US.
- PR via le MCP github. Preview deployment Vercel automatique sur chaque PR.

## À ne pas faire

- ❌ Drizzle, Prisma ou tout autre ORM (utiliser `@supabase/ssr` direct).
- ❌ UI library autre que shadcn/ui.
- ❌ Fichiers `.github/workflows/*` (Vercel s'occupe du CI/CD).
- ❌ Commit direct sur `main`.
- ❌ Table Supabase sans RLS activée.
```

### 5. .env.example

Crée à la racine `.env.example` avec les variables attendues :

```
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJxxx...
SUPABASE_SERVICE_ROLE_KEY=eyJxxx...
RESEND_API_KEY=re_xxx...
```

### 6. Setup Git + GitHub (optionnel)

Demande à l'utilisateur s'il veut initialiser Git et créer un repo GitHub maintenant :
- Si oui : `git init`, premier commit `chore: bootstrap project from /ottho-code:new-project`, créer le repo via le MCP `github`, push.
- Si non : on garde local pour l'instant.

### 7. Setup Supabase + Vercel (optionnel)

Demande à l'utilisateur s'il veut créer le projet Supabase et lier Vercel maintenant :
- Si oui : invoquer le MCP `supabase` pour créer le projet, récupérer les clés dans `.env.local`. Invoquer le MCP `vercel` pour `vercel link` + ajouter les env vars Preview/Production.
- Si non : ces étapes seront faites par le plan technique de la première feature (l'architect aura le détail).

### 8. Lancement de la première feature

Affiche :

```
✅ Projet bootstrappé.

Structure créée :
  - package.json (Next.js + Tailwind + TypeScript)
  - CLAUDE.md
  - .claude/settings.json (skillOverrides)
  - briefs/, specs/, plans/, docs/
  - .env.example

🎯 Prochaine étape : démarrer la première user story.

Lance : /ottho-code:new-feature
```

**Ne lance pas automatiquement** `new-feature`. Laisse l'utilisateur réfléchir à sa première US avant de passer au cadrage.

## Règles

- Tu **n'utilises pas** les agents `ottho-code_*` dans cette commande — c'est uniquement du setup technique.
- Si l'utilisateur veut cadrer la vision globale du produit (PRD multi-features), il peut faire `/ottho-code:brainstorm` après le bootstrap (le brief sera utilisé comme PRD informel).
- Tu **n'utilises pas** le mode plan natif Claude Code ni `write-plan`/`subagent-driven-development`.
