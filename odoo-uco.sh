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

make_backup() {
    echo -e "[+] Haciendo copia de seguridad...\n"
    cd config
    if [ -f backup_postgres.sql ]
    then
        mv backup_postgres.sql backup_postgres_ant.sql
    fi

    sudo docker-compose exec postgres pg_dumpall -U admin > backup_postgres.sql

    if [ "$?" -eq 0 ]
    then
        echo -e "[+] Copia de seguridad creada con exito...\n"

        name=backup_$(date '+%d-%m-%Y_%H-%M')_manual.sql

        cp backup_postgres.sql ../backups/"$name"

        if [ -f backup_postgres_ant.sql ]
        then
            echo -e "[+] Eliminando copia de seguridad antigua de config/...\n"
            rm backup_postgres_ant.sql
        fi
        else
            echo -e "[-] Ha surgido un error en la creación de la copia de seguridad\n"
            if [ -f backup_postgres_ant.sql ]
            then
                echo -e "[-] Manteniendo ultima copia de seguridad\n"
                if [ -f backup_postgres.sql ]
                then
                    rm backup_postgres.sql
                fi
                mv backup_postgres_ant.sql backup_postgres.sql
            fi
            exit -1
    fi
    cd ..
}

restore_backup() {
    echo -e "[/] ¿Estas seguro de querer restaurar todo?"
    read -p "[/] Perderas todo el progreso que no se haya guardado [y/N]:  " opc

    if [[ "$opc" == "y" || "$opc" == "Y" ]]
    then
        echo -e "\n[/] Elige que backup utilizar (ruta relativa)"
        read -p "[/] Por omisión config/backup_postgres.sql (Ultima Creada):  " back

        if [ "$back" == "" ]
        then
            back=config/backup_postgres.sql
        fi
        if [ ! -f "$back" ]
        then
            echo -e "\n[-] El fichero $back no existe\n"
            exit -1
        fi

        echo -e "\n[+] Restaurando copia de seguridad...\n"
        echo -e "[+] Eliminando base de datos anteriór...\n"
        cd config

        sudo docker-compose down --rmi all -v
        if [ "$?" -ne 0 ]
        then
            echo -e "[-] Ha surgido un error en el borrado de la BBDD anterior\n"
            exit -1
        fi
        cd ..

        start_container

        echo -e "[+] Restaurando base de datos...\n"
        sleep 5
        cat "$back" | sudo docker-compose -f config/docker-compose.yml exec -T postgres psql -U admin -d postgres
        if [ "$?" -ne 0 ]
        then
            echo -e "[-] Ha surgido un error en la restauración de la BBDD\n"
            exit -1
        fi
        echo -e "[+] Restauración realizada con éxito...\n"

        else
            echo -e "[+] Cancelando restauración de la copia de seguridad...\n"
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

# Comprobar si postgresql está instalado
if ! command -v psql &> /dev/null; then
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

elif [ "$1" == "-backup" ]
then
    make_backup

elif [ "$1" == "-restore" ]
then
    restore_backup

else
    echo "Uso: $0 { -start | -stop | -backup | -restore }"
    echo "  -start: Inicia el despliegue del contenedor"
    echo "  -stop: Detiene la ejecución del contenedor"
    echo "  -backup: Hace una copia de seguridad de todo"
    echo "  -restore: Restaura una copia de seguridad creada"
    exit 1
fi
