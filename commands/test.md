---
description: Phase Validate uniquement — écrit et exécute les tests pour une feature déjà implémentée
---

# /ottho-code:test

Invoque uniquement l'agent `ottho-code_tester` pour écrire et exécuter les tests Vitest d'une feature déjà implémentée.

## Pré-requis

- Une branche `feature/US-XX-<slug>` avec du code implémenté.
- La fiche SDD `specs/US-XX-<slug>.md` (pour valider les critères Given-When-Then).
- Le plan `plans/US-XX-<slug>.md` (pour la liste des tests à écrire).

## Séquence

1. **Pré-check** : crée `.claude/settings.json` (skillOverrides) si absent.
2. **Vérifie** la branche courante : on doit être sur une branche `feature/*`.
3. **Lis** la fiche et le plan correspondants.
4. **Invoque** `ottho-code_tester` via `Task(...)` avec les chemins en contexte.
5. **L'agent** écrit les tests (Vitest unit + intégration, Playwright optionnel pour E2E), les exécute, rapporte le verdict.
6. **Si rouge** : suggère de re-invoquer `/ottho-code:code` avec la liste des échecs.
7. **Si vert** : affiche le rapport final (N tests, X% coverage).

## Quand utiliser

- Tu as implémenté une feature et tu veux valider qu'elle respecte ta fiche SDD.
- Tu veux ajouter des tests à du code existant qui n'en a pas.
- Tu veux vérifier qu'un refactor n'a pas cassé de critères d'acceptation.

## Pour aller plus loin

Une fois tous les tests verts, push la branche et ouvre une PR vers `main` :

```bash
git push -u origin feature/US-XX-<slug>
```

Puis via le MCP `github`, demande à Claude d'ouvrir une PR. Vercel générera automatiquement une preview deployment sur cette PR.
