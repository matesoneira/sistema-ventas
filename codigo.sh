#!/usr/bin/env bash

# Variable global para usuario autenticado
AUTH_USER=""

# Archivo de usuarios
USERS_FILE="users.db"
touch "$USERS_FILE"

# Archivo de productos
PRODUCTS_FILE="products.db"
touch "$PRODUCTS_FILE"

# Pausa para que el usuario vea los mensajes
pause() {
  read -rp "Presiona ENTER para continuar..."
}

registro_usuario() {
  echo -e "\n== Registro de usuario =="
  read -rp "Nombre de usuario: " user

  if grep -q "^${user}:" "$USERS_FILE"; then
    echo "⚠  El usuario '${user}' ya existe."
    pause
    return
  fi

  read -rp "Contraseña: " pass

  echo "${user}:${pass}" >> "$USERS_FILE"
  echo -e "\nUsuario ${user} registrado correctamente."
  pause
}

login_usuario() {
  echo -e "\n== Inicio de sesión =="
  read -rp "Nombre de usuario: " user

  if ! grep -q "^${user}:" "$USERS_FILE"; then
    echo "Usuario '${user}' no encontrado."
    pause
    return 1
  fi

  read -rp "Contraseña: " pass
  stored_pass=$(grep "^${user}:" "$USERS_FILE" | head -n1 | cut -d: -f2)

  if [[ "$pass" != "$stored_pass" ]]; then
    echo "Contraseña incorrecta. Ingrese nuevamente"
    pause
    return 1
  fi

  AUTH_USER="$user"
  clear
  echo -e "\nBienvenido/a ${user}!"
  pause
  return 0
}

agregar_producto() {
  echo -e "\n== Alta de producto =="
  read -rp "Nombre: " name
  read -rp "Descripción: " desc
  read -rp "Precio: " price
  read -rp "Stock: " stock

  echo "${name}|${desc}|${price}|${stock}" >> "$PRODUCTS_FILE"
  echo -e "\nProducto ${name} agregado correctamente."
  pause
}

listar_productos() {
  echo -e "\n== Lista de productos =="
  while IFS="|" read -r name desc price stock; do
    echo "Nombre: $name | Precio: $price | Stock: $stock"
  done < "$PRODUCTS_FILE"
  pause
}

vender_producto() {
  echo -e "\n== Venta de producto =="
  read -rp "Nombre del producto a comprar: " prod

  # Busca el producto
  line=$(grep -m1 "^${prod}|" "$PRODUCTS_FILE")
  if [[ -z "$line" ]]; then
    echo "Producto '${prod}' no encontrado."
    pause
    return
  fi

  # Separa campos
  IFS="|" read -r name desc price stock <<< "$line"

  # Pide cantidad
  read -rp "Cantidad a comprar: " qty
  if ! [[ "$qty" =~ ^[0-9]+$ ]] || (( qty <= 0 )); then
    echo "Cantidad inválida."
    pause
    return
  fi

  # Verifica stock
  if (( qty > stock )); then
    echo "Stock insuficiente. Solo quedan ${stock} unidades."
    pause
    return
  fi

  # Calcula nuevo stock y actualiza el archivo
  newstock=$((stock - qty))
  awk -F"|" -v prod="$prod" -v newstock="$newstock" 'BEGIN{OFS=FS}
    $1==prod { $4=newstock }
    { print }
  ' "$PRODUCTS_FILE" > tmp.$$ && mv tmp.$$ "$PRODUCTS_FILE"

  echo "Compra realizada. Stock restante: ${newstock}."
  pause
}

menu_usuario() {
  while true; do
    clear
    echo "=== Menú de $AUTH_USER ==="
    echo "1) Agregar producto"
    echo "2) Listar productos"
    echo "3) Vender producto"
    echo "4) Cerrar sesión"
    read -rp "Opción: " opt

    case $opt in
      1) agregar_producto ;;
      2) listar_productos ;;
      3) vender_producto ;;
      4)
        AUTH_USER=""
        break
        ;;
      *)
        echo "Opción inválida."
        pause
        ;;
    esac
  done
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
      1) registro_usuario ;;
      2)
        if login_usuario; then
          menu_usuario
        fi
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