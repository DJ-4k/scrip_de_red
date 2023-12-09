#!/bin/bash

uso_s=false
uso_c=false
uso_w=false
uso_p=false

###Abierta
abierta_inalambrica(){
	echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
		ip link set "$interfaz" up
		echo "REDES DISPONIBLES QUE HAN SIDO DETECTADAS, (procura seleccionar aquella que sea abierta en este caso)"
		iw dev "$interfaz" scan | grep SSID
		read -p "Escribe el nombre de la red que deseas conectarte ---> " red
		iw dev "$interfaz" connect "$red" || { echo "ERROR AL CONECTARSE"; exit 1;}
		dhclient "$interfaz" && echo "CONEXION EXITOSA HACIA LA RED $red :)"
        else
                echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1
        fi

}

abierta_manual(){
	echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
                ip link set "$interfaz" up
                echo "REDES DISPONIBLES QUE HAN SIDO DETECTADAS, (procura seleccionar aquella que sea abierta en este caso)"
                iw dev "$interfaz" scan | grep SSID
                echo "INGRESA LAS DIRECCIONES "
		read -p "Escribe el nombre de la red que deseas conectarte ---> " red
                echo "Formato de ip de tu host 192.168.100.0/24 (es un ejemplo)"
                read -p "IP DE LA MAQUINA ----> " ip
                echo "Formato de gateway o puerta de enlace 192.168.100.1 (no hace falta poner mascara de red)"
                read -p "Puerta de enlace o gateway ----> " gateway
                iw dev "$interfaz" connect "$red" || { echo "ERROR AL CONECTARSE"; exit 1;}
		ip addr add "$ip" dev "$interfaz"
                ip route add default via "$gateway"
		echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        else
                echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1
        fi

}

###Contraseña
contra_inalambrica(){
	echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
		ip link set "$interfaz" up
		echo "REDES DISPONIBLES QUE HAN SIDO DETECTADAS, (procura seleccionar aquella que sea abierta en este caso)"
                iw dev "$interfaz" scan | grep SSID
		read -p "Escribe el nombre de la red que deseas conectarte ---> " red
		read -p "Escribe el nombre de la red que deseas conectarte ---> " contra
		wpa_passphrase ""$red"" ""$contra"" > conexion.tempo
		wpa_supplicant -i "$interfaz" -c conexion.tempo -B || { echo "ERROR AL CONECTARSE A $red"; rm conexion.tempo; exit 1; }
		dhclient "$interfaz" && echo "CONEXION EXITOSA HACIA LA RED $red :)" && rm conexion.tempo
        else
                echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1
        fi
}

contra_manual(){
	echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
                ip link set "$interfaz" up
                echo "REDES DISPONIBLES QUE HAN SIDO DETECTADAS"
                iw dev "$interfaz" scan | grep SSID
                read -p "Escribe el nombre de la red que deseas conectarte ---> " red
                read -p "Escribe la contraseña ---> " -s contra
                wpa_passphrase ""$red"" ""$contra"" > conexion.tempo
                wpa_supplicant -i "$interfaz" -c conexion.tempo -B || { echo "ERROR AL CONECTARSE A $red"; rm conexion.tempo; exit 1; }
		echo "Conexion fisica establecida, ahora asigna los datos para la conexión logica"
		echo "INGRESA LAS DIRECCIONES "
                echo "Formato de ip de tu host 192.168.100.0/24 (es un ejemplo)"
                read -p "IP DE LA MAQUINA ----> " ip
                echo "Formato de gateway o puerta de enlace 192.168.100.1 (no hace falta poner mascara de red)"
                read -p "Puerta de enlace o gateway ----> " gateway
                iw dev "$interfaz" connect "$red" || { echo "ERROR AL CONECTARSE"; exit 1;}
                ip addr add "$ip" dev "$interfaz"
                ip route add default via "$gateway"
                echo "nameserver 8.8.8.8" >> /etc/resolv.conf && rm conexion.tempo
	else
		echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1
	fi
}

##wpa2
wpa2_inalambrica(){
        echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
                ip link set "$interfaz" up
                echo "REDES DISPONIBLES QUE HAN SIDO DETECTADAS, (procura seleccionar aquella que sea abierta en este caso)"
                iw dev "$interfaz" scan | grep SSID
                read -p "Escribe el nombre de la red que deseas conectarte ---> " red
                read -p "Escribe el nombre de la red que deseas conectarte ---> " contra
                wpa_passphrase ""$red"" ""$contra"" > conexion.tempo
                wpa_supplicant -i "$interfaz" -c conexion.tempo -B || { echo "ERROR AL CONECTARSE A $red"; rm conexion.tempo; exit 1; }
                dhclient "$interfaz" && echo "CONEXION EXITOSA HACIA LA RED $red :)" && rm conexion.tempo
        else
                echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1
        fi
}

wpa2_manual(){
        echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
                ip link set "$interfaz" up
                echo "REDES DISPONIBLES QUE HAN SIDO DETECTADAS"
                iw dev "$interfaz" scan | grep SSID
                read -p "Escribe el nombre de la red que deseas conectarte ---> " red
                read -p "Escribe la contraseña ---> " -s contra
                wpa_passphrase ""$red"" ""$contra"" > conexion.tempo
                wpa_supplicant -i "$interfaz" -c conexion.tempo -B || { echo "ERROR AL CONECTARSE A $red"; rm conexion.tempo; exit 1; }
                echo "Conexion fisica establecida, ahora asigna los datos para la conexión logica"
                echo "INGRESA LAS DIRECCIONES "
                echo "Formato de ip de tu host 192.168.100.0/24 (es un ejemplo)"
                read -p "IP DE LA MAQUINA ----> " ip
                echo "Formato de gateway o puerta de enlace 192.168.100.1 (no hace falta poner mascara de red)"
                read -p "Puerta de enlace o gateway ----> " gateway
                iw dev "$interfaz" connect "$red" || { echo "ERROR AL CONECTARSE"; exit 1;}
                ip addr add "$ip" dev "$interfaz"
                ip route add default via "$gateway"
                echo "nameserver 8.8.8.8" >> /etc/resolv.conf && rm conexion.tempo
        else
                echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1
        fi
}




###WPS
wps_inalambrica(){
	 echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
		ip link set "$interfaz" up
		read -p "PRESIONE ENTER PARA EMPEZAR EL SCANEO WPS" -r
		wpa_supplicant -t -Dnl80211 -i "$interfaz" -c /etc/wpa_supplicant.conf -B
		wpa_cli wps_pbc &> /dev/null && dhclient "$interfaz" && echo "Conexion establecida" || { echo "ERROR INESPERADO"; exit 1; }
	else
		echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1 
	fi
}
wps_pin(){
	echo "INTERFACES DISPONIBLES" && ip link show | awk -F ': ' '/^[0-9]+:/{print $2}'
        read -p "ESCOGE UNA INTERFAZ INALAMBRICA (respeta mayusculas y minusculas) ---> " interfaz
        info=$(iwconfig "$interfaz")
        if [[ "$info" == *ESSID* ]]; then
                ip link set "$interfaz" up
	read -p "Escribe el PIN de la conexion WPS---> " pin
                wpa_supplicant -t -Dnl80211 -i "$interfaz" -c /etc/wpa_supplicant.conf -B
                wpa_cli wps_pin any "$pin" &> /dev/null && dhclient "$interfaz" && echo "Conexion establecida" || { echo "ERROR INESPERADO"; exit 1; }
        else
                echo "La interfaz $interfaz es CABLEADA, no INALAMBRICA" && exit 1 
        fi

}

while getopts ":s:c:w:p:" opt; do
    case "$opt" in
        s)
                if $uso_c || $uso_w || $uso_p; then
                        echo "YA SE USO OTRA OPCION" && { exit 1; }
                fi
                uso_s=true
		read -p "Escriba auto si quiere conectarse de forma automatica, en caso contrario escriba manual ---> " abiopt
                if [ "$abiopt" = "auto" ]; then
	                echo "REALIZANDO CONEXION INALAMBRICA SIN CONTRASEÑA DE FORMA AUTOMATICA"
                        abierta_inalambrica
                elif [ "$abiopt" = "manual" ]; then
                        echo "REALIZANDO CONEXION INALAMBRICA SIN CONTRASEÑA DE FORMA MANUAL"
                        abierta_manual
                else
                        echo "La variable no contiene ni 'pbc' ni 'pin'" && exit 1
                fi

                echo "REALIZANDO CONEXION INALAMBRICA SIN CONTRASEÑA"
            ;;
        c)
                if $uso_s || $uso_w || $uso_p; then
                        echo "YA SE USO OTRA OPCION" && { exit 1; }
                fi
                uso_c=true
                read -p "Escriba auto si quiere conectarse de forma automatica, en caso contrario escriba manual ---> " contraopt
                if [ "$contraopt" = "auto" ]; then
                        echo "REALIZANDO CONEXION INALAMBRICA CON CONTRASEÑA DE FORMA AUTOMATICA"
                        contra_inalambrica
                elif [ "$contraopt" = "manual" ]; then
                        echo "REALIZANDO CONEXION INALAMBRICA CON CONTRASEÑA DE FORMA MANUAL"
                        contra_manual
                else
                        echo "La variable no contiene ni 'auto' ni 'manual'" && exit 1
                fi
            ;;
        w)
                if $uso_s || $uso_c || $uso_p; then
                        echo "YA SE USO OTRA OPCION" && { exit 1; }
                fi
                uso_w=true
                read -p "Escriba auto si quiere conectarse de forma automatica, en caso contrario escriba manual ---> " contraopt
                if [ "$contraopt" = "auto" ]; then
                        echo "REALIZANDO CONEXION INALAMBRICA A RED DE WPA2  DE FORMA AUTOMATICA"
                        wpa2_inalambrica
                elif [ "$contraopt" = "manual" ]; then
                        echo "REALIZANDO CONEXION INALAMBRICA A RED DE WPA2 FORMA MANUAL"
                        wpa2_manual
                else
                        echo "La variable no contiene ni 'auto' ni 'manual'" && exit 1
                fi

            ;;
        p)
                if $uso_s || $uso_c || $uso_w; then
                        echo "YA SE USO OTRA OPCION" && { exit 1; }
                fi
                uso_p=true
		read -p "Escriba pbc si solo quiere conectarse con el metodo push bottom, en caso contrario escriba pin ---> " wpsopt
		if [ "$wpsopt" = "pbc" ]; then
		echo "REALIZANDO CONEXION INALAMBRICA WPS"
			wps_inalambrica
		elif [ "$wpsopt" = "pin" ]; then
			echo "REALIZANDO CONEXION INALAMBRICA WPS"
			wps_pin
		else
			echo "La variable no contiene ni 'pbc' ni 'pin'" && exit 1
		fi

            ;;
        :)
                echo "Se esperaba un parámetro en -$OPTARG";
                ayuda;
                exit 1;
            ;;
    esac
done

shift $((OPTIND-1)) #borrar todos los params que ya procesó getopts
