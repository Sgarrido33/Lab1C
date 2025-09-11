# Sistema POS simple con React y Flask

Este proyecto es un sistema de Punto de Venta (POS) simple y funcional, desarrollado para demostrar habilidades en el control de versiones y automatización de despliegue.

La aplicación permite gestionar productos (agregar, eliminar, buscar), procesar ventas con un carrito de compras, calcular el cambio y ver un historial de transacciones.

---

## Características Principales

* **Gestión de Productos:** Crear, listar, eliminar y buscar productos en tiempo real.
* **Carrito:** Añadir, incrementar, decrementar y eliminar productos del carrito.
* **Ciclo de Venta:** Finalizar una venta, ingresar el monto pagado y calcular el cambio.
* **Historial de Ventas:** Visualizar un registro de todas las transacciones realizadas.
* **Interfaz:** UI construida con React y Pico.css.
* **Despliegue Automatizado:** Un solo script (`deploy_local.sh`) configura y lanza toda la aplicación.

---

## 🛠️ Stack de Tecnologías

* **Frontend:** React (con Vite), JavaScript, Pico.css
* **Backend:** Python, Flask, Flask-SQLAlchemy, Flask-CORS
* **Base de Datos:** SQLite
* **Control de Versiones:** Git (con Conventional Commits)
* **Automatización:** Bash Script

---

## 📋 Prerrequisitos

Asegúrate de tener instaladas las siguientes herramientas para poder ejecutar el proyecto:

* Git
* Python 3.x
* Node.js y npm

---

## ⚡ Ejecución

El proyecto está diseñado para ser desplegado con un **único comando**. El script se encargará de todo el proceso.

1.  Abre tu terminal en el directorio donde quieras clonar el proyecto.
2.  Ejecuta el script de despliegue:

    ```bash
    ./deploy_local.sh
    ```

El script clonará el repositorio, configurará los entornos, instalará todas las dependencias y levantará ambos servidores. La aplicación estará disponible en  `http://localhost:3000`.