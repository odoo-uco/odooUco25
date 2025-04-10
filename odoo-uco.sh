#!/bin/bash

clear

# Arte ASCII
art_ascii="

                      ███████        █████                                     
                    ███░░░░░███     ░░███                                      
                   ███     ░░███  ███████   ██████   ██████                    
                  ░███      ░███ ███░░███  ███░░███ ███░░███                   
                  ░███      ░███░███ ░███ ░███ ░███░███ ░███                   
                  ░░███     ███ ░███ ░███ ░███ ░███░███ ░███                   
                   ░░░███████░  ░░████████░░██████ ░░██████                    
                     ░░░░░░░     ░░░░░░░░  ░░░░░░   ░░░░░░                     
                                                                               
                                                                               
                                                                               
 █████  █████   █████████     ███████                      ████████  ██████████
░░███  ░░███   ███░░░░░███  ███░░░░░███                   ███░░░░███░███░░░░░░█
 ░███   ░███  ███     ░░░  ███     ░░███                 ░░░    ░███░███     ░ 
 ░███   ░███ ░███         ░███      ░███    ██████████      ███████ ░█████████ 
 ░███   ░███ ░███         ░███      ░███   ░░░░░░░░░░      ███░░░░  ░░░░░░░░███
 ░███   ░███ ░░███     ███░░███     ███                   ███      █ ███   ░███
 ░░████████   ░░█████████  ░░░███████░                   ░██████████░░████████ 
  ░░░░░░░░     ░░░░░░░░░     ░░░░░░░                     ░░░░░░░░░░  ░░░░░░░░  

"

echo -e "$art_ascii\n"

# Función para instalar Docker
install_docker() {
    echo "[+] Instalando Docker..."
    sudo apt update
    if [ "$?" -ne 0 ]
    then
        echo -e "\n[-] Ha surgido un error en la actualización de paquetes\n"
        echo -e "[-] Porfavor descarga docker para tu sistema operativo\n"
        exit -1
    fi

    sudo apt install -y docker.io
    if [ "$?" -ne 0 ]
    then
        echo -e "\n[-] Ha surgido un error en la descarga de docker\n"
        echo -e "[-] Porfavor descarga docker para tu sistema operativo\n"
        exit -1
    fi
}

# Función para instalar Docker Compose
install_docker_compose() {
    echo "[+] Instalando Docker Compose..."
    sudo apt update
    if [ "$?" -ne 0 ]
    then
        echo -e "\n[-] Ha surgido un error en la actualización de paquetes\n"
        echo -e "[-] Porfavor descarga docker-compose para tu sistema operativo\n"
        exit -1
    fi

    sudo apt install -y docker-compose
    if [ "$?" -ne 0 ]
    then
        echo -e "\n[-] Ha surgido un error en la descarga de docker\n"
        echo -e "[-] Porfavor descarga docker-compose para tu sistema operativo\n"
        exit -1
    fi
}

install_postgreesql() {
    echo "[+] Instalando PostgreeSQL..."
    sudo apt update
    if [ "$?" -ne 0 ]
    then
        echo -e "\n[-] Ha surgido un error en la actualización de paquetes\n"
        echo -e "[-] Porfavor descarga PostgreeSQL para tu sistema operativo\n"
        exit -1
    fi

    sudo apt install -y postgresql
    if [ "$?" -ne 0 ]
    then
        echo -e "\n[-] Ha surgido un error en la descarga de docker\n"
        echo -e "[-] Porfavor descarga PostgreeSQL para tu sistema operativo\n"
        exit -1
    fi
}

# Función para lanzar el contenedor
start_container() {
    echo -e "[+] Lanzando el contenedor con docker-compose up...\n"
    sudo docker-compose -f config/docker-compose.yml up -d

    if [ "$?" -eq 0 ]
    then
        echo -e "Para instalar un módulo muévelo al directorio external-addons\n"
        echo -e "[+] Volumen de instalación de addons creado con éxito...\n"

        echo -e "[+] Contenedor odoo-uco lanzado con éxito...\n"
        echo -e "http://localhost:8069\n"
        else
            echo -e "\n[-] Ha surgido un error en el lanzamiento\n"
            exit -1
    fi
}

# Función para detener el contenedor
stop_container() {
    echo -e "[+] Deteniendo el contenedor con docker-compose down...\n"
    sudo docker-compose -f config/docker-compose.yml down

    if [ "$?" -eq 0 ]
    then
        echo -e "\n[+] Contenedor odoo-uco finalizado con éxito...\n" 
        else
            echo -e "\n[-] Ha surgido un error en la finalización\n"
            exit -1
    fi
}

start_daemon() {
    echo -e "[+] Encendiendo el demonio de docker con systemctl...\n"
    sudo systemctl start docker

    if [ "$?" -eq 0 ]
    then
        echo -e "[+] Demonio encendido exitósamente...\n" 
        else
            echo -e "[-] Ha surgido un error en el inicio del demonio Docker\n"
            exit -1
    fi
}


# Comprobar si docker está instalado
if ! command -v docker &> /dev/null; then
    install_docker
fi

# Comprobar si docker-compose está instalado
if ! command -v docker-compose &> /dev/null; then
    install_docker_compose
fi

# Comprobar si docker-compose está instalado
if ! command -v posgreesql &> /dev/null; then
    install_postgreesql
fi


# Comprobar si Docker Deamon esta activo
if [ $(systemctl status docker | grep Active | sed -n 's/.*Active:[[:space:]]*\([^[:space:]]*\).*/\1/p') != "active" ]
then
    start_daemon
fi

# Comprobar opción elegida
if [ "$1" == "-start" ]; then
    start_container


elif [ "$1" == "-stop" ]; then
    stop_container

else
    echo "Uso: $0 { -start | -stop }"
    echo "  -start: Inicia el despliegue del contenedor"
    echo "  -stop: Detiene la ejecución del contenedor"
    exit 1
fi