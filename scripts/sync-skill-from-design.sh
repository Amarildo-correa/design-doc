#!/usr/bin/env bash
# Sincroniza skills/design-doc/SKILL.md com o DESIGN.md do repositório
# criar-perfil, preservando o cabeçalho YAML (name/description) já
# existente no SKILL.md.
set -euo pipefail

SKILL_FILE="skills/design-doc/SKILL.md"
SOURCE_URL="https://raw.githubusercontent.com/Amarildo-correa/criar-perfil/main/DESIGN.md"

if [ ! -f "$SKILL_FILE" ]; then
    echo "Erro: $SKILL_FILE não encontrado. Rode este script a partir da raiz do repositório design-doc." >&2
    exit 1
fi

frontmatter=$(awk '/^---$/{c++; print; if (c==2) exit; next} c==1{print}' "$SKILL_FILE")

if [ -z "$frontmatter" ]; then
    echo "Erro: não foi possível extrair o cabeçalho YAML de $SKILL_FILE." >&2
    exit 1
fi

body=$(curl -fsSL "$SOURCE_URL")

{
    printf '%s\n' "$frontmatter"
    printf '\n'
    printf '%s\n' "$body"
} > "$SKILL_FILE"

echo "SKILL.md sincronizado a partir de $SOURCE_URL"
