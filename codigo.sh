#!/usr/bin/env bash

# Variable global para usuario autenticado
AUTH_USER=""

# Pausa para que el usuario vea los mensajes
pause() {
  read -rp "Presiona ENTER para continuar..."
}

# --- Menú principal ---
menu_principal() {
  while true; do
    clear
    echo "=== Sistema de Gestión de Ventas ==="
    echo "1) Registrarse"
    echo "2) Iniciar sesión"
    echo "0) Salir"
    read -rp "Elige una opción: " opcion

    case $opcion in
      1)
        echo -e "\nHas elegido Registrarse"
        pause
        ;;
      2)
        echo -e "\nHas elegido Iniciar sesión"
        pause
        ;;
      0)
        echo -e "\n¡Hasta luego!"
        exit 0
        ;;
      *)
        echo -e "\nOpción no válida."
        pause
        ;;
    esac
  done
}

# --- Inicio del script ---
menu_principal
