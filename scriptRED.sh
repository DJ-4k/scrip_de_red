#!/bin/bash

ayuda(){
	echo "en desarrollo"
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
