#!/usr/bin/env bash
set -e

echo ""
echo "=== Ottho Code Plugin — uninstall ==="
echo ""

if ! command -v claude >/dev/null 2>&1; then
  echo "❌ La CLI 'claude' n'est pas installée ou pas dans le PATH."
  exit 1
fi

# ─── 1. Désinstaller le plugin ───────────────────────────────────────

echo "▸ Désinstallation du plugin ottho-code..."
claude plugin uninstall ottho-code 2>&1 | tail -3 || true

# ─── 2. Retirer le marketplace ───────────────────────────────────────

echo ""
echo "▸ Suppression du marketplace ottho-code..."
claude plugin marketplace remove ottho-code 2>&1 | tail -3 || true

# ─── 3. Confirmation ─────────────────────────────────────────────────

echo ""
echo "=== Désinstallation terminée ==="
echo ""
echo "Plugin et marketplace ottho-code retirés."
echo "Les fichiers du repo restent à leur emplacement actuel."
echo "Pour les supprimer aussi : rm -rf ~/.claude/plugins/ottho-code/"
echo ""
