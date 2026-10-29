# Uso diario

## Empezar el día

```bash
t                       # elijo un proyecto de ~/dev con fzf: abre o retoma su sesión de tmux
# o, sin fzf:
tmux new -s <proyecto> -c ~/dev/<proyecto>
```

Dentro del proyecto, `env/` se activa solo y el prompt muestra la rama de git.

## tmux (prefijo Ctrl-a)

Es mi config de siempre, con sus plugins:

| Qué | Teclas |
| --- | --- |
| Dividir panel | `prefix \|` vertical, `prefix -` horizontal (tmux-pain-control) |
| Moverme / redimensionar | `prefix h/j/k/l` / `prefix H/J/K/L` |
| Cambiar de sesión | `prefix O` (tmux-sessionx) |
| Menú fzf de tmux | `prefix F` (tmux-fzf) |
| Copiar | `prefix [`, `v` selecciona, `y` copia. `yank.sh` lo manda al portapapeles de Windows |
| Pegar | `prefix p` |
| Ocultar la barra | `prefix C-t` |
| Desconectar a los demás | `prefix D` |
| Sesiones | Se guardan y restauran solas (resurrect + continuum) |

## vim

Mi `.vimrc` tal cual: NERDTree en `F3`, Tagbar en `F4`, CtrlP en `,e`, YouCompleteMe, airline y mis atajos `\l` `\h` `\d`. Los plugins están en `vim/vpm/sources.vim`.

## Neovim

`nvim` (o `v`) abre Neovim; `vim` sigue siendo vim. Tiene los mismos atajos, y F3 y F4 funcionan igual que en vim. Detalle y equivalencias: [De vim a Neovim](vim-a-neovim.md).

## Shell

| Comando | Qué hace |
| --- | --- |
| `z <parte del nombre>` | Saltar a una carpeta ya visitada |
| `Ctrl-r` | Buscar en el historial con fzf |
| `Ctrl-t` / `Alt-c` | Insertar una ruta / entrar a una subcarpeta con fzf |
| `ll`, `lt` | Listar con estado de git / árbol (ls sigue siendo ls) |
| `lg` | lazygit |
| `gs`, `gl` | git status corto / log en grafo |

## Python (env/ + requirements)

| Comando | Qué hace |
| --- | --- |
| `mkenv` | Crea `env/` e instala `requirements*.txt` si existen |
| `lock` | Compila cada `requirements*.in` a su `.txt` con versiones fijas y deja `env/` exactamente así (si no hay `env/`, lo crea) |
| (automático) | Al entrar a una carpeta con `env/`, se activa; al salir, se desactiva |

Usan **uv** (10 a 100 veces más rápido que pip); si una máquina no lo tiene, usan pip-tools. Los archivos son los mismos de siempre (`requirements.in` → `requirements.txt`), así que el resto del equipo puede seguir con pip.

Neovim usa el black, isort, basedpyright, pytest y debugpy del `env/` del proyecto si existen; si no, los suyos.

## Con Claude Code

Dos formas, según el momento:

- **Dentro de Neovim:** `\ac` abre Claude en un panel a la derecha, ya conectado al editor: ve el archivo abierto y lo que tengo seleccionado. `\as` (con texto seleccionado) le manda esa parte, `\ab` le agrega el archivo actual. Cuando propone un cambio, lo muestra como diff en Neovim: `\aa` acepta, `\ad` rechaza.
- **En un panel de tmux:** `prefix |` y `claude`. Para conectarlo a un Neovim abierto, escribo `/ide` dentro de Claude y elijo Neovim.

En los dos casos:

- Neovim recarga solo los archivos que Claude modifica (vim avisa y pregunta).
- Abro Claude siempre desde la carpeta del proyecto, nunca desde `~`.
- Shift-Enter hace salto de línea en Claude también dentro de tmux (`extended-keys` en `tmux.conf`).

## Tests y depurador (Neovim, Python)

| Atajo | Qué hace |
| --- | --- |
| `\tt` / `\tf` / `\ts` | Correr el test bajo el cursor / del archivo / todos (pytest, en un panel abajo) |
| `\tl` / `\tv` | Repetir el último / ir al último archivo de tests |
| `F9` | Poner o quitar un punto de parada (`\B`: con condición) |
| `F5` | Depurar el archivo (o continuar si ya está parado) |
| `\td` | Depurar el test bajo el cursor |
| `F10` / `F6` / `F7` | Siguiente línea / entrar a la función / salir de ella |
| `F8` | Mostrar u ocultar los paneles del depurador (variables, pila, puntos de parada) |

El depurador usa el Python de `env/` si existe.
