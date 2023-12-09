#!/bin/bash

automatico_cableada(){
	echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
	read -p "ESCOGE UNA INTERFAZ CABLEADA (respeta mayusculas y minusculas) ---> " interfaz
	info=$(iwconfig "$interfaz")
	if [[ "$info" == *ESSID* ]]; then
		echo "La interfaz $interfaz es INALAMBRICA, no CABLEADA" && exit 1
	else
		dhclient -v "$interfaz"
	fi

}

manual_cableada(){
	echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ CABLEADA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
                echo "La interfaz $interfaz es INALAMBRICA, no CABLEADA" && exit 1
        else
                echo "INGRESA LAS DIRECCIONES "
		echo "Formato de ip de tu host 192.168.100.0/24 (es un ejemplo)"
		read -p "IP DE LA MAQUINA ----> " ip
		echo "Formato de gateway o puerta de enlace 192.168.100.1 (no hace falta poner mascara de red)"
		read -p "Puerta de enlace o gateway ----> " gateway

		ip addr add "$ip" dev "$interfaz"
		ip route add default via "$gateway"

        fi
}

uso_a=false
uso_m=false
while getopts ":a:m:" opt; do
    case "$opt" in
        a)
                if "$uso_m"; then
                        echo "YA SE USO -m" && { ayuda; exit 1; }
                fi
                uso_a=true
		echo "REALIZANDO CONEXION CABLEADA DE FORMA AUTOMATICA"
		automatico_cableada
            ;;
        m)
                if "$uso_a"; then
                        echo "YA SE USO -a" && { ayuda; exit 1; }
                fi
                uso_m=true
		echo "REALIZANDO CONEXION CABLEADA DE FORMA MANUAL"
		manual_cableada
            ;;
	:)
                echo "Se esperaba un parámetro en -$OPTARG";
                ayuda;
                exit 1;
            ;;
    esac
done

shift $((OPTIND-1)) #borrar todos los params que ya procesó getopts
