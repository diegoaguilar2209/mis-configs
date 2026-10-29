# Mantener el repo

## La regla

Todo cambio pasa por el repo: edito, `git commit`, `git push`. En las otras máquinas, `mis-configs update`.

## Tareas comunes

| Quiero… | Cómo |
| --- | --- |
| Cambiar algo de tmux o vim | Edito `~/.tmux.conf` o `~/.vimrc` (son el repo), luego commit y push |
| Guardar algo que cambié directo en `~/.tmux/` o `~/.vim/` | `mis-configs import`, reviso con `git diff`, commit y push |
| Agregar un plugin de tmux | Una línea `set -g @plugin 'autor/plugin'` en `tmux/tmux.conf` y `./install.sh` (o `prefix I`) |
| Agregar un plugin de vim | Una línea `Plug '...'` en `vim/vpm/sources.vim` y `:PlugInstall` |
| Agregar un plugin de Neovim | En `nvim/lua/team/plugins.lua`, con una línea que diga para qué sirve; al abrir Neovim se instala y queda fijo en `nvim-pack-lock.json` |
| Quitar un plugin de Neovim | Borrarlo de `plugins.lua`; el próximo `./install.sh` lo elimina del disco |
| Actualizar plugins de Neovim | `:PackUpdate`, reviso, `:w` para aceptar, commit de `nvim/nvim-pack-lock.json` |
| Subir de versión Neovim, fzf, lazygit… | Cambio el número en `versions.env`, `./install.sh`, pruebo y commit |
| Algo solo para esta máquina | `~/.bashrc.local` o `nvim/lua/user/init.lua` (no se suben) |
| Ver qué falta subir | `mis-configs status` |

## La prueba automática

En cada `git push`, GitHub crea un Ubuntu limpio y comprueba que:

1. los scripts no tienen errores (shellcheck);
2. `install.sh` instala todo desde cero;
3. Neovim arranca sin errores;
4. mi tmux carga y el prefijo es Ctrl-a;
5. mi vimrc carga sin errores;
6. `mis-configs doctor` pasa.

```bash
gh run list --limit 3        # ✓ verde, X rojo, * corriendo
gh run watch                 # seguir la última
gh run view --log-failed     # ver qué falló
```

Si sale en rojo, no actualizo otras máquinas hasta arreglarlo.

## Convención de commits

`tipo: descripción` con `feat` (algo nuevo), `fix` (arreglo), `docs`, `ci` o `chore`. Ejemplo: `feat: atajo F5 para correr pytest`.
