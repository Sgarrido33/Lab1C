#!/bin/bash

# Detener la ejecución si un comando falla
set -e

echo "Iniciando la ejecución de todas las pruebas..."

# --- Pruebas del Backend ---
echo "Ejecutando pruebas del backend con Pytest..."
cd backend
source venv/Scripts/activate # Activar el entorno virtual
pytest # El comando para las pruebas de Pytest
deactivate
cd .. 
echo "Pruebas del backend completadas."

echo "-----------------------------------------"

# --- Pruebas del Frontend ---
echo "Ejecutando pruebas del frontend con Vitest..."
cd frontend
npm test # El comando para correr pruebas en proyectos de Node.js
cd .. 
echo "Pruebas del frontend completadas."

echo "Todas las pruebas se ejecutaron exitosamente"