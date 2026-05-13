---
description: Affiche l'état du projet — liste les briefs, specs, plans, et branches feature existants
---

# /ottho-code:status

Affiche un récap de l'état SDD du projet courant : briefs, specs, plans, branches feature, et phase actuelle de chaque US.

## Séquence

1. **Liste** les fichiers de chaque dossier :
   - `briefs/US-*.md`
   - `specs/US-*.md`
   - `plans/US-*.md`
2. **Liste** les branches `feature/US-*` via `git branch --list`.
3. **Pour chaque US trouvée**, détermine sa phase actuelle :
   - **Brief uniquement** → phase Brainstorm
   - **Brief + Spec** → phase Specify validée
   - **Brief + Spec + Plan** → phase Plan validée
   - **Brief + Spec + Plan + branche `feature/...` commitée** → phase Implement en cours
   - **Brief + Spec + Plan + branche mergée** → feature shipped
4. **Affiche un tableau** récapitulatif :

```
État du projet (5 US trouvées)

  US-01 — formulaire-contact         ✅ Shipped    (PR #12 mergée)
  US-02 — dashboard-leads            🧪 Validate   (branche feature/US-02-..., tests rouges)
  US-03 — export-csv                 💻 Implement  (branche feature/US-03-...)
  US-04 — admin-auth                 🛠️  Plan       (plans/US-04-...md, pas de code)
  US-05 — notifications-mobile       📋 Brief      (briefs/US-05-..., pas de spec)

Prochaines actions suggérées :
  - US-02 : re-invoquer /ottho-code:code pour corriger les tests rouges
  - US-04 : passer en phase Implement avec /ottho-code:code
  - US-05 : passer en phase Specify avec /ottho-code:spec
```

## Quand utiliser

- Tu reprends un projet après plusieurs jours et tu veux savoir où tu en es.
- Tu veux voir si plusieurs US sont en cours en parallèle.
- Tu veux identifier les US bloquées (par exemple un brief sans spec depuis 2 semaines).

## Lecture seule

Cette commande **ne modifie rien**. Elle inspecte les fichiers et `git` pour produire un récap.
