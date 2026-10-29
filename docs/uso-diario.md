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

## Python (env/ + pip-tools)

| Comando | Qué hace |
| --- | --- |
| `mkenv` | Crea `env/`, instala pip-tools y sincroniza `requirements*.txt` si existen |
| `lock` | `pip-compile` de cada `requirements*.in` y `pip-sync` |
| (automático) | Al entrar a una carpeta con `env/`, se activa; al salir, se desactiva |

Neovim usa el black, isort y basedpyright del `env/` del proyecto si existen; si no, los suyos.

## Con Claude Code

- Divido con `prefix |` y abro `claude` en el panel nuevo, junto al editor.
- Neovim recarga solo los archivos que Claude modifica (vim avisa y pregunta).
- Dentro de tmux, abro Claude siempre desde la carpeta del proyecto, nunca desde `~`.
