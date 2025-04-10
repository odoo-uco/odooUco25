# Proyecto Odoo-Uco

## Descripción

El proyecto Odoo-Uco es una solución basada en Docker que permite desplegar una instancia del sistema ERP/CRM Odoo 14.0.

Se puede utilizar como plantilla para el seminario 2 de Sistemas de Información del Grado de Ingeniería Informática de la Universidad de Córdoba.

<p align="center">

                      ███████        █████
                    ███░░░░░███     ░░███
                   ███     ░░███  ███████   ██████   ██████
                  ░███      ░███ ███░░███  ███░░███ ███░░███
                  ░███      ░███░███ ░███ ░███ ░███░███ ░███
                  ░░███     ███ ░███ ░███ ░███ ░███░███ ░███
                   ░░░███████░  ░░████████░░██████ ░░██████
                     ░░░░░░░     ░░░░░░░░  ░░░░░░   ░░░░░░

</p>

## Dependencias

Debes tener los siguientes paquetes descargados en tu ordenador para el correcto funcionamiento

> [!NOTE]  
> El script de despliege lo instala automaticamente en distros basadas en Debian

- [PostgreeSQL](https://www.postgresql.org/download/)

- [Docker](https://docs.docker.com/engine/install/)

- [Docker-Compose](https://docs.docker.com/compose/install/)

## Instalación

Para instalar y ejecutar este proyecto en tu entorno local, sigue estos pasos:

1. **Clonar el repositorio:**

   Clona este repositorio utilizando:

   ```bash
   git clone https://github.com/odoo-uco/odooUco25
   ```

2. **Navegar al directorio del proyecto:**

   Navega al directorio del proyecto:

   ```bash
   cd odooUco25
   ```

3. **Ejecutar el script de despliegue/instalación:**

   Ejecuta el script de despliegue `odoo-uco.sh -start` para instalar las dependencias necesarias en distros basadas en Debian y desplegar el contenedor. Puedes hacerlo con el siguiente comando:

   ```bash
   ./odoo-uco.sh -start
   ```

## Configuración

Este proyecto utiliza un archivo `.env` para configurar variables de entorno y un archivo `docker-compose.yml` para desplegar el contenedor.

Para visualizar el panel de Odoo, ve al navegador y busca `http://localhost:8069`
