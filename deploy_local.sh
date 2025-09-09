#!/bin/bash

# El comando existe?
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detener la ejecucion si un comando falla
set -e

echo "Iniciando despliegue local del Sistema POS..."

# --- Verificacion de Dependencias ---
echo "Verificando dependencias"

dependencies=("git" "python" "node")

for cmd in "${dependencies[@]}"; do
    if command_exists "$cmd"; then
        echo "$cmd está instalado."
    else
        echo "Error: $cmd no está instalado. Instalar pls."
        exit 1
    fi
done

echo "Verificación de dependencias completada"


# --- Configuracion Backend ---
echo "Configurando entorno del backend..."

cd backend
if [ ! -d "venv" ]; then
    echo "Creando entorno virtual..."
    python -m venv venv
fi

echo "Instalando dependencias de Python..."
source venv/Scripts/activate  # Esto es para git bash en windows por eso usa Scripts en vez de bin.
pip install -r requirements.txt
deactivate 
cd .. 
echo "Backend configurado."

echo "Backend configurado"


# --- Configuración Frontend ---
echo "Configurando entorno del frontend..."

echo "Frontend configurado"


# --- Finalizacion ---
echo "Despliegue exitoso"

#Base del script hecho, logica real se implementara despues