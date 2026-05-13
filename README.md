# Ottho Code App — Lite

> Plugin compagnon du cours Ottho **"Créer une application avec Claude Code"** (2h).
>
> Méthode SDD légère pour générer rapidement des projets internes (Next.js + Supabase + Resend + Vercel) sans coder à l'aveugle.

---

## Pour qui

- Apprenants du cours Ottho (non-techniques avec bases création de site).
- Toute personne qui veut **cadrer une feature avant de coder**, en gardant la simplicité.
- Utilisable pour **tout projet interne** : pas de présupposé sur le domaine.

## Ce que vous obtenez

- **5 agents spécialisés** qui couvrent le cycle SDD complet, **chacun produisant un livrable `.md`** :
  - `ottho-code_brainstorming` → `briefs/US-XX-<slug>.md` (cadrage 5 questions)
  - `ottho-code_spec-writer` → `specs/US-XX-<slug>.md` (fiche Given-When-Then)
  - `ottho-code_architect` → `plans/US-XX-<slug>.md` (plan technique)
  - `ottho-code_developer` → code sur `feature/US-XX-<slug>`
  - `ottho-code_tester` → tests Vitest + verdict
- **1 skill** : `ottho-code_sdd-feature-cycle` — orchestre les 5 agents en séquence
- **7 slash commands** : une commande maître `/ottho-code:new-feature` + une commande par phase pour les workflows partiels (voir tableau ci-dessous)
- **4 MCP préconfigurés** : `supabase`, `resend`, `vercel`, `github`
- **2 templates** : `brief.md.template`, `feature-spec.md.template`

**Stack imposée non-négociable** : Next.js 16 + Tailwind + shadcn/ui + Supabase (via `@supabase/ssr`, sans ORM) + Resend SDK + Vercel. Pas de Drizzle. Pas de GitHub Actions YAML. Pas de complexité moderne superflue.

---

## Installation

```bash
claude plugin marketplace add ottho-nocode/ottho-code
claude plugin install ottho-code@ottho-code
```

À la première activation, Claude Code te demande tes credentials :

| Token | Récupération | Obligatoire ? |
|---|---|---|
| `supabase_access_token` | https://supabase.com/dashboard/account/tokens | Oui pour le MCP supabase |
| `resend_api_key` | https://resend.com/api-keys | Oui pour les emails (l'instructeur fournit la sienne en cours) |
| `vercel_token` | https://vercel.com/account/tokens | Oui pour le déploiement |
| `github_token` | https://github.com/settings/tokens | Optionnel (OAuth auto sinon) |

Tous les tokens sont **sensitive** : stockés dans le keychain système, jamais en clair dans `settings.json`.

### Désinstallation

```bash
claude plugin uninstall ottho-code
claude plugin marketplace remove ottho-code
```

### Install alternative (clone + script, style ottho-design)

```bash
git clone https://github.com/ottho-nocode/ottho-code.git ~/.claude/plugins/ottho-code
~/.claude/plugins/ottho-code/install.sh
```

Identique fonctionnellement, mais permet de garder le repo localement pour inspection/contribution.

---

## Slash commands disponibles

7 commandes au total. La maîtresse `/ottho-code:new-feature` orchestre tout. Les 5 phases peuvent aussi être lancées individuellement pour itérer.

| Commande | Phase SDD | Livrable produit | Pré-requis |
|---|---|---|---|
| `/ottho-code:new-feature` | Cycle complet (5 phases) | brief + spec + plan + code + tests | aucun |
| `/ottho-code:brainstorm` | Brainstorm | `briefs/US-XX-<slug>.md` | aucun |
| `/ottho-code:spec` | Specify | `specs/US-XX-<slug>.md` | un brief existant |
| `/ottho-code:plan` | Plan | `plans/US-XX-<slug>.md` | une spec existante |
| `/ottho-code:code` | Implement | code sur `feature/US-XX-<slug>` | un plan existant |
| `/ottho-code:test` | Validate | tests Vitest + rapport | du code sur une branche feature |
| `/ottho-code:status` | (utilitaire) | tableau d'état du projet | aucun |

### Démarrer une nouvelle feature de bout en bout

```
/ottho-code:new-feature
```

Le plugin orchestre les 5 phases avec une validation humaine entre chaque. Sortie : code mergeable sur `develop`/`main`.

### Itérer phase par phase

Si tu veux contrôle plus fin (par exemple, refondre uniquement le plan technique sans toucher au reste) :

```
/ottho-code:plan
```

Le plugin liste les fiches existantes (`specs/US-*.md`), tu choisis laquelle, l'agent `ottho-code_architect` produit un nouveau plan.

### Voir où tu en es

```
/ottho-code:status
```

Affiche un tableau de toutes les US du projet et leur phase courante.

---

## Workflow complet (du cadrage à la prod)

```
1. /ottho-code:new-feature
   → ottho-code_brainstorming pose 5 questions sur TON projet
   → ottho-code_spec-writer écrit specs/US-01-<slug>.md

2. Prompt Claude : "Initialise un projet Next.js dans ce dossier"
   → npx create-next-app exécuté

3. Prompt Claude : "Crée un projet Supabase et configure-le pour cette feature"
   → MCP supabase crée le projet, applique les migrations, active RLS

4. Prompt Claude : "Génère la page et la Server Action depuis ma fiche"
   → code généré, test local OK

5. Prompt Claude : "Ajoute l'envoi d'emails Resend selon ma fiche"
   → code complété, test local OK

6. Prompt Claude : "Déploie en preview sur Vercel + crée le repo GitHub"
   → MCP vercel + MCP github

7. Prompt Claude : "Crée une branche, fais une modif, ouvre une PR"
   → workflow Git complet en CLI

8. Prompt Claude : "Merge la PR et promote en production"
   → preview → prod
```

8 prompts pour passer d'une idée à une app déployée. La fiche SDD au point 1 reste la **source de vérité** tout du long.

---

## Les 5 agents

| Agent | Rôle | Modèle |
|---|---|---|
| `ottho-code_brainstorming` | Pose les 5 questions structurantes pour cadrer une feature | opus |
| `ottho-code_spec-writer` | Transforme le cadrage en fiche SDD Given-When-Then | sonnet |
| `ottho-code_architect` | Produit le plan technique selon la stack imposée | opus |
| `ottho-code_developer` | Implémente le code sur branche feature, commits atomiques | sonnet |
| `ottho-code_tester` | Écrit et exécute les tests Vitest, donne le verdict final | sonnet |

Chaque agent **recommande** explicitement le suivant à la fin de sa réponse. L'orchestration est faite par le thread principal ou par la slash command `/ottho-code:new-feature`.

⚠️ Le plugin **bloque** explicitement le mode plan natif Claude Code (`EnterPlanMode`, `write-plan`, `subagent-driven-development`) pour garder le contrôle de l'orchestration. Si Claude te propose un menu *"Subagent-Driven / Parallel Session / ..."* après une phase, refuse et continue le cycle des agents.

---

## Les 4 MCP

| MCP | Usage typique |
|---|---|
| `supabase` | Créer un projet, appliquer des migrations, activer RLS, générer les types |
| `resend` | Envoyer des emails transactionnels |
| `vercel` | Déployer en preview / production, gérer les env vars |
| `github` | Créer le repo, gérer branches et PR |

---

## Différence avec le plugin complet

| | Lite | Complet (`ottho-code-app`) |
|---|---|---|
| Agents | 2 | 9 |
| Phases SDD | Specify | Specify + Plan + Implement + Validate |
| MCP | 4 | 10 |
| Hooks de sécurité Git | aucun | 3 (branch-guard, git-safe, secret-scan) |
| Templates | 1 | 5 |
| Cible | Cours 2h, projets internes | Production agence |

Quand vous monterez en gamme, migrez vers le plugin complet.

---

## Désinstallation

```bash
claude plugin uninstall ottho-code
```

---

## Licence

MIT — cf `LICENSE`.

---

## Liens

- Cours Ottho "Créer une application avec Claude Code" : https://ottho.co
- Documentation Claude Code Plugins : https://code.claude.com/docs/en/plugins-reference
- Spec Kit GitHub (référence SDD) : https://github.com/github/spec-kit
