# Sistema POS simple con React y Flask

Este proyecto es un sistema de Punto de Venta (POS) multiusuario simple y funcional, desarrollado para demostrar habilidades en el control de versiones, pruebas automatizadas, la contenerización y despliegue de aplicaciones.

La aplicación requiere que los usuarios se registren y creen una cuenta. Una vez autenticados, cada usuario tiene acceso a su propia instancia del POS, con sus productos y un historial de ventas aislado del resto de los usuarios.
---

## Características Principales

* **Sistema de Autenticación:** Registro de nuevos usuarios, inicio de sesión y cierre de sesión. 
* **Multi-Tenancy:** Cada usuario tiene acceso únicamente a sus propios productos y su propio historial de ventas.
* **Gestión de Productos:** Crear, listar, eliminar y buscar productos en tiempo real.
* **Carrito:** Añadir, incrementar, decrementar y eliminar productos del carrito.
* **Ciclo de Venta:** Finalizar una venta, ingresar el monto pagado y calcular el cambio.
* **Historial de Ventas:** Visualizar un registro de todas las transacciones realizadas.
* **Interfaz:** UI construida con React y Pico.css.
* **Despliegue Automatizado:** Scripts para el despliegue local y para la publicación de imágenes en registros.

---

## Stack de Tecnologías

* **Frontend:** React (con Vite), JavaScript, Pico.css
* **Backend:** Python, Flask, Flask-SQLAlchemy, PyJWT, Werkzeug
* **Base de Datos:** SQLite y MySQL (entorno dockerizado)
* **Contenerización y Orquestación:** Docker, Docker Compose
* **Reverse Proxy:** Nginx
* **Control de Versiones:** Git (con Conventional Commits)
* **Automatización:** Bash Script

---

## Prerrequisitos

Asegúrate de tener instaladas las siguientes herramientas para poder ejecutar el proyecto:

* Git
* Python 3.x
* Node.js y npm
* Docker y Docker Compose


---

## Ejecución en Local

El proyecto está diseñado para ser desplegado con un **único comando**. El script se encargará de todo el proceso.

1.  Abre tu terminal en el directorio donde quieras clonar el proyecto.
2.  Ejecuta el script de despliegue:

    ```bash
    ./deploy_local.sh
    ```

El script clonará el repositorio, configurará los entornos, instalará todas las dependencias y levantará ambos servidores. La aplicación estará disponible en  `http://localhost:3000`.

---

## Pruebas Automatizadas

El proyecto incluye un conjunto de pruebas unitarias para el backend y el frontend. Se ha creado un script para ejecutar todas las pruebas de forma automática.

1.  Asegúrate de estar en la raíz del proyecto.
2.  Ejecuta el script de pruebas:

    ```bash
    ./run_tests.sh
    ```

El script navegará a cada directorio, activará los entornos correspondientes y ejecutará las pruebas con Pytest y Vitest.

## Ejecución con Docker

Este modo utiliza Docker Compose para levantar la aplicación completa con todos sus servicios (web, base de datos y nginx) sin contar con el frontend.

1.  Crea el archivo de entorno .env.dev y .env dentro de laboratorio_02. Puedes guiarte de .env.example
2.  Construye y levanta los contenedores usando el siguiente comando:
    
    ```bash
    docker compose up --build -d
    ```
3. Verifica los tres servicios con docker compose ps
4. Prueba las rutas correspondientes en el navegador. http://localhost:8080/api/products (ejemplo)

Cabe considerar que para probar las rutas correctamente, se deberá usar Postman para enviar peticiones POST para confirmar que los servicios corren perfectamente. Alternativamente puedes revisar lo que devuelven algunas rutas que son GET.