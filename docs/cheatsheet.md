# Cheatsheet

## Shell

| Comando | Qué hace |
| --- | --- |
| `t` | Elegir proyecto y abrir su sesión de tmux |
| `z <parte del nombre>` | Saltar a una carpeta visitada |
| `Ctrl-r` | Buscar en el historial (fzf) |
| `Ctrl-t` | Insertar ruta de archivo (fzf) |
| `Alt-c` | Entrar a una subcarpeta (fzf) |
| `ll`, `lt` | Listar con detalles y estado de git / árbol |
| `lg` | lazygit |
| `mkenv`, `lock` | Crear `env/` y fijar dependencias (uv, o pip-tools si no hay uv) |
| `mis-configs doctor` / `update` / `import` / `status` | Revisar / actualizar / guardar cambios hechos en ~/.tmux o ~/.vim / ver qué falta subir |

## tmux (prefijo Ctrl-a)

| Teclas | Qué hace |
| --- | --- |
| `p` | Pegar (mi atajo) |
| `d` / `D` | Desconectarme / desconectar a los demás clientes |
| `C-t` | Ocultar o mostrar la barra |
| `\|` `-` / `\\` `_` | Dividir vertical u horizontal: solo el panel o a lo ancho (pain-control) |
| `h/j/k/l` | Moverse entre paneles (pain-control) |
| `H/J/K/L` | Redimensionar panel (pain-control) |
| `O` | Buscar y cambiar de sesión (tmux-sessionx) |
| `F` | Menú fzf de tmux (tmux-fzf) |
| `c` / `1..9` / `,` | Ventana nueva / ir a ventana / renombrar |
| `z` | Zoom del panel |
| `[` | Modo copia: `v` selecciona, `y` o `Enter` copia, `Y` la línea, `D` hasta el final, `A` añade |
| `Ctrl-s` / `Ctrl-r` | Guardar / restaurar sesiones (también es automático) |
| `I` / `U` | Instalar / actualizar plugins |
| `?` | Ver todas las teclas |

## Neovim (líder `\`, líder local `,`)

| Teclas | Qué hace |
| --- | --- |
| `\l` / `\h` | Buffer siguiente / anterior |
| `\d` | Cerrar buffer sin cerrar la ventana |
| `\bl` | Listar buffers |
| `Ctrl-s` | Guardar |
| `,e` | Buscar archivo |
| `,g` / `,G` | Símbolos del archivo / del proyecto |
| `,f` | Buscar en líneas de los buffers abiertos |
| `,m` / `,c` | Archivos recientes / comandos |
| `,we` `,wg` `,wG` `,wf` `,wm` `,wc` | Lo mismo, con la palabra bajo el cursor |
| `,pe` | Buscar el archivo cuya ruta está bajo el cursor |
| `,r` | Buscar texto en todo el proyecto (nuevo) |
| `F3` / `,t` | Árbol de carpetas a la izquierda / mostrar ahí el archivo actual (dentro: `o` abrir, `s` `i` `t` splits y pestaña, `a` `r` `d` crear, renombrar y borrar, `g?` ayuda) |
| `F4` | Imports, variables, clases y funciones a la derecha, como Tagbar (dentro: `Enter` ir, `{` `}` anterior y siguiente, `q` cerrar) |
| `gd` `gD` `gt` `gi` | Definición, declaración, tipo, implementación |
| `,d` `,o` `,a` `,D` | Definición, referencias, asignación, definición en pestaña nueva |
| `K` / `grn` / `gra` | Documentación / renombrar / acciones de código |
| `\e` | Errores del archivo en la location list |
| `\sn` `\sp` `\se` `\sl` | Siguiente, anterior, abrir y listar la location list |
| `]c` / `[c` | Siguiente / anterior cambio de git |
| `\gp` `\gs` `\gr` `\gb` | Ver, preparar, deshacer cambio / blame |
| `\gB` / `\gd` | Blame del archivo / diff contra git (fugitive) |
| `\gg` | lazygit |
| `Tab` / `Ctrl-j` `Ctrl-k` | Expandir snippet / saltar entre sus campos |
| `\tt` `\tf` `\ts` `\tl` `\tv` | Test bajo el cursor / archivo / todos / repetir / ir al archivo de tests |
| `F5` `F9` `\B` | Depurar o continuar / punto de parada / con condición |
| `F10` `F6` `F7` `F8` `\td` | Siguiente / entrar / salir / paneles / depurar el test bajo el cursor |
| `\ac` `\af` `\ab` `\as` | Claude: abrir / enfocar / agregar archivo / enviar selección |
| `\aa` `\ad` | Aceptar / rechazar el cambio que propone Claude |
| `\cf` / `:FormatToggle` | Formatear / activar o desactivar el formateo al guardar |
| `gcc` / `gc` (visual) | Comentar línea / selección |
| `:Mason`, `:PackUpdate`, `:checkhealth` | Servidores, actualizar plugins, diagnóstico |
