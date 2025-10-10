#!/bin/bash

# Detiene el script si un comando falla
set -e

# --- Variables de Configuración de AWS ---
AWS_REGION="us-east-2"
AWS_ACCOUNT_ID="183295430759"
ECR_REPOSITORY_NAME="pos-flask-app"
TAG="latest"

# --- Variables Derivadas ---
BUILD_CONTEXT="./backend"
LOCAL_IMAGE_NAME="${ECR_REPOSITORY_NAME}:${TAG}" 
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
ECR_IMAGE_NAME="${ECR_REGISTRY}/${ECR_REPOSITORY_NAME}:${TAG}" 

# --- Verificaciones Previas ---
if ! command -v docker &> /dev/null || ! command -v aws &> /dev/null
then
    echo "Error: Se requieren los comandos 'docker' y 'aws'."
    exit 1
fi

if [ ! -f "${BUILD_CONTEXT}/Dockerfile" ]; then
    echo "Error: No se encontró un Dockerfile en la carpeta '${BUILD_CONTEXT}'."
    exit 1
fi

echo "Verificaciones completadas."
echo "-----------------------------------------"
echo "Iniciando el push a AWS ECR..."
echo "Repositorio ECR: ${ECR_IMAGE_NAME}"
echo "-----------------------------------------"

# --- 1. Autenticar Docker con AWS ECR ---
echo "Autenticando con AWS ECR en la región ${AWS_REGION}..."
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REGISTRY}"
echo "Autenticación exitosa."

# --- 2. Construir la Imagen de Docker ---
echo "Construyendo la imagen Docker local: ${LOCAL_IMAGE_NAME}"
docker build -t "${LOCAL_IMAGE_NAME}" "${BUILD_CONTEXT}"
echo "Construcción finalizada."

# --- 3. Etiquetar la Imagen para ECR ---
echo "Etiquetando la imagen para ECR..."
docker tag "${LOCAL_IMAGE_NAME}" "${ECR_IMAGE_NAME}"
echo "Etiquetado finalizado."

# --- 4. Subir la Imagen a ECR ---
echo "⬆Subiendo la imagen a AWS ECR..."
docker push "${ECR_IMAGE_NAME}"

echo "-----------------------------------------"
echo "Imagen subida a AWS ECR."