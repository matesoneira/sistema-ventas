#!/bin/bash

# Obtener fecha actual
fecha=$(date '+%d/%m/%Y %H:%M')

# Verificar si hay cambios
cambios=$(git status --porcelain)

if [ -z "$cambios" ]; then
    echo "No hay cambios para commitear."
    echo "- Última revisión: $fecha – Sin cambios" >> README.md
    git add README.md
    git commit -m "Registro de revisión sin cambios: $fecha"
    git push
else
    echo "Hay cambios. Preparando commit..."

    # Agregar todos los cambios (incluso README, que vamos a modificar en breve)
    git add .

    # Crear commit temporal (sin hacer push) para poder calcular diferencias
    mensaje="Commit automático: $fecha"
    git commit -m "$mensaje"

    # Obtener resumen de diferencia con el commit anterior
    resumen=$(git diff --shortstat HEAD~1 HEAD)

    # Extraer número total de líneas cambiadas (agregadas + borradas)
    lineas=$(echo "$resumen" | grep -o '[0-9]\+ insert' | grep -o '[0-9]\+')
    [ -z "$lineas" ] && lineas=0
    borradas=$(echo "$resumen" | grep -o '[0-9]\+ delet' | grep -o '[0-9]\+')
    [ -z "$borradas" ] && borradas=0
    total=$((lineas + borradas))

    # Escribir resultado en README.md
    echo "- Último commit: $fecha – Se modificaron $total líneas (insertadas: $lineas, eliminadas: $borradas)" >> README.md

    # Agregar y commitear el nuevo README.md
    git add README.md
    git commit -m "Actualización de README con resumen de cambios: $fecha"

    # Push final
    git push

    echo "Commits realizados y README actualizado con $total líneas modificadas."
fi
