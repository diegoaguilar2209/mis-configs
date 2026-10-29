# De vim a Neovim

**Recomendación: pasar a Neovim para programar, de a poco.** vim sigue instalado y con mi config, así que no pierdo nada mientras me acostumbro.

## Por qué

| | Mi vim hoy | Neovim en este repo |
| --- | --- | --- |
| Autocompletado e ir a definición | YouCompleteMe: hay que compilarlo en cada laptop (cmake, Java) | Servidores de lenguaje incluidos, se instalan solos |
| Errores en Python | Syntastic (desactivado en mi lista) | Errores y tipos mientras escribo (basedpyright) |
| F3 carpetas | NERDTree | nvim-tree: misma barra lateral y teclas parecidas |
| F4 funciones | Tagbar (necesita ctags) | aerial: misma barra con clases y funciones, usando el servidor de lenguaje |
| Buscar | CtrlP | fzf-lua: mismos atajos (`,e` `,g` `,m`…), más rápido, y búsqueda de texto en todo el proyecto |
| Formatear | A mano | isort + black al guardar (`:FormatToggle` lo apaga) |
| Versiones de plugins | Las que bajen ese día | Fijas en `nvim-pack-lock.json`: iguales en todas las laptops |

## Mis atajos en los dos

| Atajo | vim | Neovim |
| --- | --- | --- |
| `F3` | NERDTree | Árbol de carpetas (nvim-tree) |
| `,t` | Mostrar el archivo actual en NERDTree | Mostrar el archivo actual en el árbol |
| `F4` | Tagbar (con foco) | Clases y funciones (aerial, con foco) |
| `,e` / `,m` / `,c` | CtrlP archivos / recientes / comandos | fzf-lua, lo mismo |
| `,g` / `,G` / `,f` | Símbolos del archivo / de todos / líneas | Igual |
| `,we` `,wg` `,wG` `,wf` `,wm` `,wc` `,pe` | Lo mismo con la palabra bajo el cursor | Igual |
| `gd` `gD` `gt` `gi` | YouCompleteMe | Servidor de lenguaje |
| `,d` `,o` `,a` `,D` | Jedi | Servidor de lenguaje |
| `\l` `\h` `\d` `\bl` | Buffers | Igual (las pestañas de buffers arriba, como airline) |
| `Ctrl-s` | Guardar | Igual |
| `\e` | Errores de Syntastic | Errores del archivo en la location list |
| `\sn` `\sp` `\se` `\sl` | Location list | Igual |

### Dentro del árbol (F3)

| Tecla | Qué hace |
| --- | --- |
| `o` o `Enter` | Abrir |
| `s` / `i` / `t` | Abrir en split vertical / horizontal / pestaña nueva (como NERDTree) |
| `a` / `r` / `d` | Crear / renombrar / borrar archivo o carpeta |
| `H` | Mostrar u ocultar archivos ocultos |
| `R` | Refrescar |
| `g?` | Ver todas las teclas |

### Dentro del panel de funciones (F4)

| Tecla | Qué hace |
| --- | --- |
| `Enter` | Ir a esa función o clase |
| `o` / `za` | Abrir o cerrar un nivel |
| `{` / `}` | Anterior / siguiente símbolo |
| `q` | Cerrar |
| `?` | Ver todas las teclas |

## Qué hay de nuevo en Neovim

| Atajo | Qué hace |
| --- | --- |
| `,r` | Buscar texto en todo el proyecto |
| `K` | Documentación de lo que está bajo el cursor |
| `grn` / `gra` | Renombrar en todo el proyecto / acciones de código |
| `]c` / `[c`, `\gp` | Saltar entre cambios de git / ver el cambio |
| `\gg` | lazygit |
| `\cf` | Formatear |
| `\` o `,` y esperar | Lista de atajos disponibles |

## Plan de cambio

1. **Semana 1:** uso `nvim` solo en un proyecto de Python. Si algo me frena, vuelvo a `vim` para esa tarea.
2. **Semana 2:** si ya no lo extraño, lo hago mi editor por defecto en `~/.bashrc.local`:
   ```bash
   export EDITOR=nvim VISUAL=nvim
   ```
3. **Si extraño algo de vim:** lo agrego en `nvim/lua/team/keymaps.lua` (o en `nvim/lua/user/init.lua` si es solo para esta máquina), commit y push.

Cosas que no copié de mi vimrc a propósito: `autochdir`, porque rompe la búsqueda en todo el proyecto. Si lo necesito, `vim.opt.autochdir = true` en `nvim/lua/user/init.lua`.
