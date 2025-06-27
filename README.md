
---

## Descripción

`Uv3doble – SU Force` es una herramienta de fuerza bruta paralelizada para probar contraseñas contra el comando `su`. Soporta múltiples hilos, spinner de progreso y detiene inmediatamente todos los procesos al encontrar la contraseña correcta.

---

## Características

- **Paralelismo configurable**: Numbero de hilos (`xargs -P`) ajustable.  
- **Spinner de actividad**: Muestra un indicador animado durante el ataque.  
- **Timeout corto**: Cada intento usa un timeout de 0.05 s para no bloquearse.  
- **Terminación instantánea**: Al hallar la contraseña, detiene todos los procesos y muestra el resultado.  
- **Validaciones**:  
  - Comprueba existencia y permisos del diccionario.  
  - Requiere extensión `.txt`.  

---

## Requisitos

- Bash (`#!/usr/bin/env bash`)  
- `timeout` (generalmente parte de `coreutils`)  
- `xargs`  

---

## Instalación

1. Clona o descarga este repositorio.
2. Dale permisos de ejecución al script:
   ```bash
   chmod +x su_force.sh
````

---

## Uso

```bash
./su_force.sh USUARIO DICCIONARIO.txt [HILOS]
```

* `USUARIO`: Cuenta de usuario local (para `su`).
* `DICCIONARIO.txt`: Ruta al archivo de contraseñas (extensión **.txt**, debe ser legible).
* `HILOS` (opcional): Número de procesos concurrentes (por defecto **4**).

---

## Ejemplos

* **Ataque con 4 hilos (por defecto):**

  ```bash
  ./su_force.sh redghost rockyou.txt
  ```

* **Ataque con 16 hilos:**

  ```bash
  ./su_force.sh redghost rockyou.txt 16
  ```

---

## Salida esperada

```text
╔═══════════════════════════════════════╗
║         Uv3doble - SU Force           ║
╚═══════════════════════════════════════╝
              by Uv3doble

[*] Iniciando ataque a 'redghost' con 'rockyou.txt' en 8 hilos...
[*] Ataque en curso... /

╔════════════════════════════════╗
║       RESULTADO DEL ATAQUE     ║
╠════════════════════════════════╣
║ Usuario    : redghost
║ Diccionario: rockyou.txt
║ Contraseña : estrella
╚════════════════════════════════╝
```

---

## Notas

* Ajusta el número de hilos según la capacidad CPU/IO de tu sistema.
* Un timeout muy pequeño puede generar falsos negativos en sistemas lentos.

---

## Licencia

Este proyecto se distribuye bajo la [MIT License](LICENSE).

```
```
