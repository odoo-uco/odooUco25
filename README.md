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

## Flags del Script de instalación

- -start -> Inicia el servicio de Odoo

- -stop -> Para el servicio de Odoo

- -backup -> Crea localmente una copia de seguridad en config/

- -restore -> Restaura una copia de seguridad 

## Configuración

Este proyecto utiliza un archivo `.env` para configurar variables de entorno y un archivo `docker-compose.yml` para desplegar el contenedor.

Para visualizar el panel de Odoo, ve al navegador y busca `http://localhost:8069`



## Instrucciones para Instalar un Módulo de terceros en Odoo (local)

### 1. Descargar y Descomprimir el Módulo

1. Visita la Tienda de terceros de Odoo y descarga el módulo que desees instalar.
2. Descomprime el archivo descargado para obtener la carpeta del módulo.

### 2. Mover el Módulo a la Carpeta external-addons

```bash
sudo mv {nombre_del_modulo} odooUco25/external-addons/
```

### 3. Reiniciar el Servicio de Odoo

```bash
./odoo-uco.sh -stop
./odoo-uco.sh -start
```

### 4. Actualizar la Lista de Aplicaciones en Odoo

Accede a Odoo a través de tu navegador.

En la barra superior, ve a Aplicaciones y selecciona Actualizar Lista de Aplicaciones para que el sistema reconozca el nuevo módulo.

Si la opción Actualizar Lista de Aplicaciones no aparece, activa el modo desarrollador visitando la siguiente URL:

```bash
localhost:8069/web?debug=1
```

### 5. Activar el modulo

En la barra superior de odoo ve a Aplicaciones y en la barra de busqueda busca el nombre del modulo que acabas de añadir.

En caso de que no te aparezca elimina el filtro de "Aplicaciones" de la barra de busqueda

Activa el modulo


## Instrucciones para Instalar un Módulo de terceros en Odoo (AWS)

> [!WARNING]  
> Recordad hacer un backup con el script cada vez que realiceis un cambio importante en el servidor y veais que funciona correctamente.

Antes de instalar un módulo en la instancia de Odoo alojada en AWS, **comprueba primero en local que funcione perfectamente y sin problemas**. A continuación, se detallan los pasos a seguir:

### 1. Descargar y Descomprimir el Módulo

1. Visita la Tienda de terceros de Odoo y descarga el módulo que desees instalar.
2. Descomprime el archivo descargado para obtener la carpeta del módulo.

### 2. Transferir el Módulo al Servidor

Utiliza `scp` para copiar la carpeta del módulo al servidor a través de SSH, para podernos conectarnos a ssh debemos tener el archivo Odoo-UCO.pem (que se encuentra en Moodle, Documentos Seminario 2/Odoo-UCO.pem) en la carpeta la cual estamos ejecutando el comando. Por ejemplo:

```bash
scp -i "Odoo-UCO.pem" -r "{nombre_del_modulo}" ubuntu@ec2-34-243-55-38.eu-west-1.compute.amazonaws.com:~
```

### 3. Conectar al Servidor vía SSH

En este caso tambien debemos de tener el archivo Odoo-UCO.pem en la carpeta desde la que se ejecuta
```bash
ssh -i "Odoo-UCO.pem" ubuntu@ec2-34-243-55-38.eu-west-1.compute.amazonaws.com
```

### 4. Mover el Módulo a la Carpeta external-addons

```bash
sudo mv {nombre_del_modulo} odooUco25/external-addons/
```

### 5. Reiniciar el Servicio de Odoo

```bash
./odoo-uco.sh -stop
./odoo-uco.sh -start
```

### 6. Actualizar la Lista de Aplicaciones en Odoo

Accede a Odoo a través de tu navegador.

En la barra superior, ve a Aplicaciones y selecciona Actualizar Lista de Aplicaciones para que el sistema reconozca el nuevo módulo.

Si la opción Actualizar Lista de Aplicaciones no aparece, activa el modo desarrollador visitando la siguiente URL:

```bash
http://ec2-34-243-55-38.eu-west-1.compute.amazonaws.com/web?debug=1
```

### 7. Activar el modulo

En la barra superior de odoo ve a Aplicaciones y en la barra de busqueda busca el nombre del modulo que acabas de añadir.

En caso de que no te aparezca elimina el filtro de "Aplicaciones" de la barra de busqueda

Activa el modulo
