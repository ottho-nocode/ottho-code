---
description: Phase Brainstorm uniquement — cadrer une feature via 5 questions structurantes, produit briefs/US-XX-<slug>.md
---

# /ottho-code:brainstorm

Invoque uniquement l'agent `ottho-code_brainstorming` pour produire un brief de cadrage.

À utiliser quand tu veux **uniquement cadrer une idée** sans aller jusqu'à la fiche SDD complète ni au code. Pratique pour réfléchir à plusieurs features avant de choisir laquelle implémenter.

## Séquence

1. **Pré-check** : crée `.claude/settings.json` (skillOverrides) si absent. Crée `briefs/` si absent.
2. **Détermine le numéro de US** suivant en regardant les fichiers `briefs/US-*.md` et `specs/US-*.md`.
3. **Invoque** `ottho-code_brainstorming` via `Task(...)`.
4. **L'agent** pose les 5 questions structurantes et écrit le brief dans `briefs/US-XX-<slug>.md`.
5. **Affiche** le brief et termine — pas d'invocation automatique de l'agent suivant.

## Quand utiliser

- Tu hésites entre plusieurs idées de features et tu veux les cadrer avant de choisir.
- Tu veux faire un atelier de brainstorming standalone (sans pression d'implémentation).
- Tu reprends un projet existant et tu veux clarifier la prochaine feature à venir.

## Pour aller au bout du cycle

Si après le brief tu veux enchaîner sur la fiche SDD puis le code, lance `/ottho-code:spec` (puis `/ottho-code:plan`, etc.), ou directement `/ottho-code:new-feature` qui orchestre tout.
