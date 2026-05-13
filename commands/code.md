---
description: Phase Implement uniquement — implémente le code d'une feature à partir d'un plan technique existant
---

# /ottho-code:code

Invoque uniquement l'agent `ottho-code_developer` pour implémenter le code d'une feature à partir de son plan technique.

## Pré-requis

Un fichier `plans/US-XX-<slug>.md` doit exister (produit par `/ottho-code:plan` ou à la main).
La fiche SDD `specs/US-XX-<slug>.md` doit aussi exister.

Si l'utilisateur ne précise pas quelle US implémenter, **liste les plans disponibles** dans `plans/` et demande lequel cibler.

## Séquence

1. **Pré-check** : crée `.claude/settings.json` (skillOverrides) si absent.
2. **Vérifie** la branche courante : si pas sur `feature/US-XX-<slug>`, propose de la créer depuis `main` ou `develop`.
3. **Lis** la fiche `specs/US-XX-<slug>.md` et le plan `plans/US-XX-<slug>.md`.
4. **Invoque** `ottho-code_developer` via `Task(...)` avec les chemins en contexte.
5. **L'agent** implémente le code étape par étape, commits atomiques `feat(US-XX): ...`.
6. **Affiche** le résumé des changements et termine — pas d'invocation automatique de `ottho-code_tester`.

## Quand utiliser

- Tu as un plan technique validé et tu veux passer au code.
- Tu veux reprendre une implémentation interrompue.
- Tu veux séparer code et tests pour mieux contrôler.

## Pour aller plus loin

Une fois le code prêt, lance `/ottho-code:test` pour écrire les tests et valider la feature.
