#!/bin/bash

# Verificar si hay cambios sin commitear
cambios=$(git status --porcelain)

# Obtener fecha actual
fecha=$(date '+%d/%m/%Y %H:%M')

if [ -z "$cambios" ]; then
    echo "No hay cambios para commitear."
    echo "- Última revisión: $fecha – Sin cambios" >> README.md
else
    echo "Hay cambios. Realizando commit..."

    # Obtener cantidad de líneas modificadas
    # Este cálculo se hace antes del commit para que podamos agregarlo al README
    git diff --cached > diff.tmp
    lineas=$(grep -c '^+' diff.tmp)
    rm diff.tmp

    # Agregar mensaje al README (antes del commit)
    echo "- Último commit: $fecha – Se modificaron $lineas líneas" >> README.md

    # Agregar todos los cambios (incluyendo el README)
    git add .

    # Crear mensaje de commit con fecha
    mensaje="Commit automático: $fecha"
    git commit -m "$mensaje"

    # Subir a GitHub
    git push

    echo "Commit realizado y README actualizado."
fi

