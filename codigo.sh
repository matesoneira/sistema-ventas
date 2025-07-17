#!/usr/bin/env bash

# Variable global para usuario autenticado
AUTH_USER=""

USERS_FILE="users.db"
touch "$USERS_FILE"

# Pausa para que el usuario vea los mensajes
pause() {
  read -rp "Presiona ENTER para continuar..."
}

registro_usuario() {
  echo -e "\n== Registro de usuario =="
  read -rp "Nombre de usuario: " user

  if grep -q "^${user}:" "$USERS_FILE"; then
    echo "⚠️  El usuario '${user}' ya existe."
    return
  fi

  read -rp "Contraseña: " pass

  echo "${user}:${pass}" >> "$USERS_FILE"
  echo -e "\nUsuario ${user} registrado correctamente."
  pause
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
        registro_usuario
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
