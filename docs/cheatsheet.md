# Cheatsheet

## Shell

| Comando | Qué hace |
| --- | --- |
| `t` | Elegir proyecto y abrir su sesión de tmux |
| `z <parte del nombre>` | Saltar a una carpeta visitada |
| `Ctrl-r` | Buscar en el historial (fzf) |
| `Ctrl-t` | Insertar ruta de archivo (fzf) |
| `Alt-c` | Entrar a una subcarpeta (fzf) |
| `ll`, `tree` | Listar con detalles y estado de git |
| `lg` | lazygit |
| `mkenv`, `lock` | Crear `env/` y fijar dependencias con pip-tools |
| `dotfiles doctor` / `dotfiles update` | Revisar / actualizar este setup |

## tmux (prefijo Ctrl-a)

| Teclas | Qué hace |
| --- | --- |
| `f` | Saltar a otro proyecto |
| `c` / `1..9` / `,` | Ventana nueva / ir a ventana / renombrar |
| `\|` / `-` | Dividir vertical / horizontal |
| `Ctrl-h/j/k/l` (sin prefijo) | Moverse entre paneles y Neovim |
| `H/J/K/L` | Redimensionar panel |
| `z` | Zoom del panel |
| `x` | Cerrar panel |
| `d` | Salir de tmux (la sesión sigue viva) |
| `s` | Lista de sesiones |
| `[` | Modo copia: `v` seleccionar, `y` copiar |
| `C` | Claude Code en un panel lateral |
| `g` | lazygit flotante |
| `r` | Recargar configuración |
| `Ctrl-s` / `Ctrl-r` | Guardar / restaurar sesiones (también es automático) |
| `I` / `U` | Instalar / actualizar plugins de tmux |
| `?` | Ver todas las teclas |

## Neovim (líder Espacio)

| Teclas | Qué hace |
| --- | --- |
| `Espacio` (y esperar) | Mostrar todos los atajos |
| `Espacio Espacio`, `Espacio f f` | Buscar archivo |
| `Espacio f g` | Buscar texto en el proyecto |
| `Espacio f w` | Buscar la palabra bajo el cursor |
| `Espacio f b` / `f r` | Buffers abiertos / archivos recientes |
| `Espacio /` | Buscar en este archivo |
| `-` | Explorador de archivos (oil): edita, renombra y borra como texto, `:w` aplica |
| `gd` / `K` | Ir a definición / documentación |
| `grr` / `gri` / `grn` / `gra` | Referencias / implementación / renombrar / acciones de código |
| `Espacio d` | Ver el error de la línea |
| `]d` / `[d` | Siguiente / anterior error |
| `Espacio c f` | Formatear archivo |
| `:FormatToggle` | Activar / desactivar formateo al guardar |
| `]h` / `[h` | Siguiente / anterior cambio de git |
| `Espacio h p` / `h s` / `h r` / `h b` | Ver / preparar / deshacer cambio / blame |
| `Espacio g g` | lazygit |
| `gc` (visual) / `gcc` | Comentar selección / línea |
| `sa`, `sd`, `sr` | Agregar / borrar / reemplazar comillas o paréntesis (mini.surround) |
| `Espacio w` / `Espacio q` | Guardar / cerrar ventana |
| `:Mason` | Servidores de lenguaje y formateadores |
| `:PackUpdate` | Actualizar plugins (luego commit del lock) |
| `:checkhealth` | Diagnóstico general |
