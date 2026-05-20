---
description: Phase Design uniquement — produit le brief design d'une fiche SDD existante, et met à jour le design system du projet
---

# /ottho-code:design

Invoque uniquement l'agent `ottho-code_designer` pour produire la direction visuelle d'une fiche SDD existante.

## Pré-requis

Un fichier `specs/US-XX-<slug>.md` doit exister (produit par `/ottho-code:spec` ou par `/ottho-code:new-feature` jusqu'à la phase Specify).

Si l'utilisateur ne précise pas quelle fiche utiliser, **liste les fiches disponibles** dans `specs/` et demande laquelle cibler.

## Séquence

1. **Pré-check** : crée `.claude/settings.json` (skillOverrides) si absent. Crée `design/` si absent.
2. **Lis la fiche** ciblée : `specs/US-XX-<slug>.md`.
3. **Invoque** `ottho-code_designer` via `Task(...)` avec le chemin de la fiche en contexte.
4. **L'agent** produit `design/US-XX-<slug>.md` et met à jour `design/system.md` si nécessaire.
5. **Affiche** le brief design et termine — pas d'invocation automatique de l'agent suivant.

## Quand utiliser

- Tu as une fiche SDD validée et tu veux **uniquement** travailler la direction visuelle sans toucher au plan technique ni au code.
- Tu veux refondre le design d'une feature existante (relancer `designer` sur une fiche, il mettra à jour les fichiers `design/`).
- Tu veux **rattraper le design** d'un projet qui a été codé en mode shadcn-vanilla générique. Combine ensuite avec `/impeccable` ou `/frontend-design` pour élever le résultat visuel.

## Pour aller plus loin

Une fois le brief design validé, lance `/ottho-code:plan` pour produire le plan technique aligné. Pour un design encore plus poussé : lance `/impeccable` ou `/frontend-design` avant le plan.
