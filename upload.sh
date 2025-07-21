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

    # Agregar todos los cambios
    git add .

    # Crear mensaje de commit con fecha
    mensaje="Commit automático: $fecha"
    git commit -m "$mensaje"

    # Subir a GitHub
    git push

    # Obtener cantidad de líneas modificadas
    resumen=$(git diff --shortstat HEAD~1 HEAD)
    lineas=$(echo "$resumen" | grep -o '[0-9]\+ insert' | grep -o '[0-9]\+')

    # Si no encuentra inserciones, pone 0
    if [ -z "$lineas" ]; then
        lineas=0
    fi

    echo "- Último commit: $fecha – Se modificaron $lineas líneas" >> README.md
    echo "Commit realizado y README actualizado."
fi
