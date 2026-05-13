#!/usr/bin/env bash
set -e

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "=== Ottho Code Plugin — install ==="
echo ""

# ─── 1. Vérifier que la CLI claude est disponible ────────────────────

if ! command -v claude >/dev/null 2>&1; then
  echo "❌ La CLI 'claude' n'est pas installée ou pas dans le PATH."
  echo "   Installe Claude Code depuis https://claude.com/claude-code puis relance."
  exit 1
fi

# ─── 2. Ajouter le marketplace ───────────────────────────────────────

echo "▸ Enregistrement du marketplace local ($PLUGIN_DIR)..."
claude plugin marketplace add "$PLUGIN_DIR" 2>&1 | tail -3

# ─── 3. Installer le plugin ──────────────────────────────────────────

echo ""
echo "▸ Installation du plugin ottho-code..."
claude plugin install ottho-code@ottho-code 2>&1 | tail -3

# ─── 4. Confirmation ─────────────────────────────────────────────────

echo ""
echo "=== Installation terminée ==="
echo ""
echo "Slash commands disponibles :"
echo "  /ottho-code:new-feature   — démarre le cycle SDD (brainstorming + spec-writer)"
echo ""
echo "Agents :"
echo "  ottho-code:brainstorming  — 5 questions structurantes pour cadrer une feature"
echo "  ottho-code:spec-writer    — fiche SDD Given-When-Then complète"
echo ""
echo "MCP préconfigurés :"
echo "  supabase, resend, vercel, github"
echo ""
echo "Pour configurer tes credentials (Supabase, Resend, Vercel, GitHub),"
echo "redémarre Claude Code et tu seras prompté à l'enable du plugin."
echo ""
