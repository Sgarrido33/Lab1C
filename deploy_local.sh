#!/bin/bash

# El comando existe?
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detener la ejecucion si un comando falla
set -e

# Funcion para limpiar procesos en segundo plano al salir del script
cleanup() {
    echo "Deteniendo todos los servidores..."
    kill 0
}
trap cleanup EXIT

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


# --- Configuración Frontend ---
echo "Configurando entorno del frontend..."

cd frontend
if [ ! -d "node_modules" ]; then
    echo "Instalando dependencias de Node.js"
    npm install
else
    echo "Dependencias de Node.js ya instaladas."
fi
cd ..

echo "Frontend configurado"


# --- Levantando servidores ---
echo "Levantando los servidores"

# Iniciar backend en segundo plano
echo "Iniciando servidor backend en segundo plano (http://127.0.0.1:5000)."

# Ocurre en el subshell, basicamente se ejecuta en segundo plano para poder seguir usando terminal
(cd backend && source venv/Scripts/activate && flask run &)

# Unos segundos para que el backend inicie
sleep 3

# Iniciar frontend en primer plano
echo "Iniciando servidor frontend"
echo "Aplicacion disponible en http://localhost:3000"
echo "Presiona Ctrl + C en esta ventana para cerrar"
(cd frontend && node server.js)