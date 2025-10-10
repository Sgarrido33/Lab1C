#!/bin/bash

# Detiene el script si un comando falla
set -e

# --- Variables de Configuración ---
DOCKERHUB_USERNAME="sgarrido3"
IMAGE_NAME="pos-flask-app"
TAG="latest"

DOCKER_IMAGE_NAME="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"
BUILD_CONTEXT="./backend"

# --- Verificaciones Previas ---
if ! command -v docker &> /dev/null
then
    echo "Error: El comando 'docker' no fue encontrado."
    exit 1
fi

if [ ! -f "${BUILD_CONTEXT}/Dockerfile" ]; then
    echo "Error: No se encontró un Dockerfile en la carpeta '${BUILD_CONTEXT}'."
    exit 1
fi

echo "Verificaciones completadas."
echo "-----------------------------------------"
echo "Iniciando el push a Docker Hub..."
echo "Imagen a construir: ${DOCKER_IMAGE_NAME}"
echo "-----------------------------------------"


# --- 1. Construir la Imagen de Docker ---
echo "Construyendo la imagen Docker desde '${BUILD_CONTEXT}'..."
docker build -t "${DOCKER_IMAGE_NAME}" "${BUILD_CONTEXT}"
echo "Construcción finalizada."


# --- 2. Subir la Imagen a Docker Hub ---
echo "⬆Subiendo la imagen a Docker Hub..."
docker push "${DOCKER_IMAGE_NAME}"

echo "-----------------------------------------"
echo "Imagen subida a Docker Hub."
echo "Puedes verla en: https://hub.docker.com/r/${DOCKERHUB_USERNAME}/${IMAGE_NAME}"