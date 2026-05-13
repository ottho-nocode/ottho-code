---
name: ottho-code_sdd-feature-cycle
description: Use when the user wants to add a new feature, build a new module, implement a user story, start a new internal project, or asks "how do I build X". Guides through the SDD Specify phase using 2 agents (brainstorming → spec-writer) before any code is written. Triggers on phrases like "nouvelle feature", "ajouter une fonctionnalité", "nouveau projet interne", "je veux construire".
---

# Cycle SDD — phase Specify (version lite)

Quand l'utilisateur veut **ajouter une fonctionnalité** / **démarrer un nouveau projet interne** / **construire un module** / **implémenter une user story**, applique ce cycle court.

## Principe

Avant d'écrire **une seule ligne de code**, on cadre :

1. **Brainstorm** : poser les 5 questions structurantes (problème, persona, succès, contraintes, hors-scope).
2. **Specify** : transformer le cadrage en fiche fonctionnalité SDD avec critères Given-When-Then testables.

**Puis seulement** on génère le code, en s'appuyant sur la fiche comme cahier des charges.

## Étapes

### Étape 1 — Brainstorm

Invoque l'agent **`ottho-code_brainstorming`** via `Task(...)`.

- Il pose les 5 questions structurantes.
- Il refuse de continuer tant qu'une réponse est vague.
- Il produit un **cadrage** structuré (problème, persona, signaux de succès, dépendances, hors-scope).

**Validation humaine obligatoire** avant l'étape 2.

### Étape 2 — Specify

Invoque l'agent **`ottho-code_spec-writer`** via `Task(...)`.

- Il transforme le cadrage en fiche SDD complète.
- Il utilise le template `${CLAUDE_PLUGIN_ROOT}/templates/feature-spec.md.template`.
- Il écrit dans `specs/US-XX-<slug>.md` à la racine du projet.

**Validation humaine de la fiche.**

### Étape 3 (hors plugin) — Génération du code

À ce stade, le plugin a fait son travail. La suite est du dialogue libre avec Claude :

- "Génère le code Next.js de cette feature à partir de `specs/US-XX-<slug>.md`."
- "Utilise le MCP `supabase` pour créer les tables nécessaires avec RLS activée."
- "Utilise le MCP `resend` pour envoyer les emails."
- "Déploie en preview sur Vercel via le MCP `vercel`."
- "Crée le repo GitHub et pousse via le MCP `github`."

La fiche SDD reste la **source de vérité** : à chaque fois que tu hésites, tu reviens à la fiche.

## Récapitulatif rapide

```
ottho-code_brainstorming   ← 5 questions structurantes
   ↓ validation humaine
ottho-code_spec-writer     ← fiche SDD Given-When-Then
   ↓ validation humaine
[dialogue libre]     ← Claude génère le code en s'appuyant sur la fiche
                       (MCP supabase, resend, vercel, github)
```

## Template de référence

- Fiche feature : `${CLAUDE_PLUGIN_ROOT}/templates/feature-spec.md.template`

## Pour aller plus loin

Cette version lite couvre uniquement la phase **Specify** du SDD. La méthode complète Ottho ajoute :
- Phase **Plan** (architecte technique)
- Phase **Implement** (developer dédié)
- Phase **Validate** (code-reviewer + tester)
- Hooks de sécurité Git
- 7 agents supplémentaires

→ Voir le plugin complet `ottho-code-app` quand vous voulez monter en gamme.
