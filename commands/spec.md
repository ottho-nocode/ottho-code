---
description: Phase Specify uniquement — transforme un brief existant en fiche SDD Given-When-Then, produit specs/US-XX-<slug>.md
---

# /ottho-code:spec

Invoque uniquement l'agent `ottho-code_spec-writer` pour transformer un brief existant en fiche SDD complète.

## Pré-requis

Un fichier `briefs/US-XX-<slug>.md` doit exister (produit par `/ottho-code:brainstorm` ou à la main).

Si l'utilisateur ne précise pas quel brief utiliser, **liste les briefs disponibles** dans `briefs/` et demande lequel cibler.

## Séquence

1. **Pré-check** : crée `.claude/settings.json` (skillOverrides) si absent. Crée `specs/` si absent.
2. **Lis le brief** ciblé : `briefs/US-XX-<slug>.md`.
3. **Invoque** `ottho-code_spec-writer` via `Task(...)` avec le chemin du brief en contexte.
4. **L'agent** produit la fiche dans `specs/US-XX-<slug>.md` (même numéro de US et même slug).
5. **Affiche** la fiche et termine — pas d'invocation automatique de l'agent suivant.

## Quand utiliser

- Tu as déjà un brief validé et tu veux le formaliser en fiche SDD.
- Tu veux itérer sur la fiche sans toucher au brief.
- Tu reprends un brief écrit à la main et tu veux le passer au spec-writer pour qu'il le structure proprement.

## Pour aller plus loin

Une fois la fiche prête, lance `/ottho-code:plan` pour produire le plan technique.
