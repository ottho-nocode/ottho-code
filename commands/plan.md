---
description: Phase Plan uniquement — produit le plan technique d'une fiche SDD existante, plans/US-XX-<slug>.md
---

# /ottho-code:plan

Invoque uniquement l'agent `ottho-code_architect` pour produire le plan technique d'une fiche SDD existante.

## Pré-requis

Un fichier `specs/US-XX-<slug>.md` doit exister (produit par `/ottho-code:spec` ou à la main).

Si l'utilisateur ne précise pas quelle fiche utiliser, **liste les fiches disponibles** dans `specs/` et demande laquelle cibler.

## Séquence

1. **Pré-check** : crée `.claude/settings.json` (skillOverrides) si absent. Crée `plans/` si absent.
2. **Lis la fiche** ciblée : `specs/US-XX-<slug>.md`.
3. **Invoque** `ottho-code_architect` via `Task(...)` avec le chemin de la fiche en contexte.
4. **L'agent** produit le plan dans `plans/US-XX-<slug>.md` selon la stack imposée (Next.js + Tailwind + shadcn/ui + @supabase/ssr + resend + Vercel).
5. **Affiche** le plan et termine — pas d'invocation automatique de l'agent suivant.

## Quand utiliser

- Tu as une fiche SDD validée et tu veux le plan technique.
- Tu veux itérer sur l'architecture sans toucher au code (refondre les composants, changer le schéma BDD, ajuster les Server Actions).
- Tu veux comparer deux plans avant de choisir lequel implémenter.

## Pour aller plus loin

Une fois le plan validé, lance `/ottho-code:code` pour démarrer l'implémentation.
