# Uv3doble – SU Force

**Versión:** 1.7  
**Autor:** Uv3doble (leury EA)

**Descripción:**  
Herramienta de fuerza bruta paralelizada para `su`, con hilos configurables, spinner y terminación instantánea al encontrar la contraseña.

**Requisitos:**  
- Bash  
- `timeout` (coreutils)  
- `xargs`

**Instalación:**  
```bash
chmod +x su_force.sh
````

**Uso:**

```bash
./su_force.sh USUARIO DICCIONARIO.txt [HILOS]
```

* `USUARIO`: cuenta local.
* `DICCIONARIO.txt`: archivo `.txt` legible.
* `HILOS`: procesos concurrentes (por defecto 4).

**Ejemplo:**

```bash
./su_force.sh redghost rockyou.txt 8
```

**Salida esperada:**

```text
[*] Iniciando ataque a 'redghost' con 'rockyou.txt' en 8 hilos...
[*] Ataque en curso... /
╔════════════════════════════════╗
║       RESULTADO DEL ATAQUE     ║
╠════════════════════════════════╣
║ Usuario    : redghost          ║
║ Diccionario: rockyou.txt       ║
║ Contraseña : estrella          ║
╚════════════════════════════════╝
```

**Notas:**
Ajusta `HILOS` según CPU/IO; un timeout muy bajo puede generar falsos negativos.

```
```
