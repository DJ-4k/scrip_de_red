#!/bin/bash

ayuda(){
	echo "$0 -[OPCION] [PARAMETRO]"
	echo "$0 -c a	Este orden indica que quieres iniciar una conexion cableada de manera automatica"
	echo "	-[OPCION] Tienen los posibles valores"
	echo "		-c Es para hacer conexion cableada"
	echo "		-i Es para hacer conexion inalambrica"
	echo "		-? Es para desplegar este menu"
	echo ""
	echo "	-c espera solo dos posibles parametros"
	echo "		'a' que sirve para indicar que vas a realizar una conexion cableada de forma automatica"
	echo "		'm' que sirve para indicar que vas a realizar una conexion cableada de forma manual"
	echo "	-i espera solo cuatro posibles parametos"
	echo "		's' Es para inidcar que vas a realizar una conexiona una red inalambrica sin contraseña"
	echo "		'c' Es para indicar que vas a realizar una conexion a una red con contraseña"
	echo "		'w' Es para indicar que vas a realizar una conexion a una red con contraseña y cifrado wpa2"
	echo "		'p' Es para indicar que vas a realizar una conexion a una red mediante el metodo wps"
	echo "		//////////////Solo los parametros 's', 'c' y 'w' cuentan con el metodo automatico y manual"
	echo "		//////////////El parametro 'p' cuenta con las opciones de wps por pbc y pin"
}
uso_c=false
uso_i=false


while getopts ":c:i:" opt; do
    case "$opt" in
        c)
                if "$uso_i"; then
                        echo "YA SE USO -i" && { ayuda; exit 1; }
                fi
                uso_c=true
		case "$2" in
			a)
				./cableada.sh -a "$2"
			;;
			m)
				./cableada.sh -m "$2"
			;;
			:)
				echo "opcino no valida para -c" && { ayuda; exit 1; }
			;;
		esac
            ;;
        i)
                if "$uso_c"; then
                        echo "YA SE USO -c" && { ayuda; exit 1; }
                fi
		uso_c=true
                case "$2" in
                         s)
                                ./inalambrica.sh -s "$2"
                        ;;
                        c)
                                ./inalambrica.sh -c "$2"
                        ;;
			w)
				./inalambrica.sh -w "$2"
			;;
			p)
				./inalambrica.sh -p "$2"
			;;
                        :)
                                echo "opcino no valida para -i" && { ayuda; exit 1; }
                        ;;
                esac

            ;;
        "?")
		ayuda;
                exit 1;
            ;;
        :)
                echo "Se esperaba un parámetro en -$OPTARG";
                ayuda;
                exit 1;
            ;;
    esac
done

shift $((OPTIND-1)) #borrar todos los params que ya procesó getopts
