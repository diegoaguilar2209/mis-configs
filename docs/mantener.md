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
| Subir de versión Neovim, fzf, lazygit… | Llega solo: el día 1 de cada mes GitHub busca versiones nuevas, las instala en un Ubuntu limpio y, si todo funciona, abre un PR. Lo reviso y hago merge (o lo cierro). A mano: `scripts/check-versions.sh`, `./install.sh`, pruebo y commit |
| Algo solo para esta máquina | `~/.bashrc.local` o `nvim/lua/user/init.lua` (no se suben) |
| Ver qué falta subir | `mis-configs status` |

## La prueba automática

En cada `git push`, GitHub crea un Ubuntu limpio y comprueba que:

1. los scripts no tienen errores (shellcheck);
2. `install.sh` instala todo desde cero;
3. no hay secretos en ningún commit del historial (gitleaks);
4. Neovim arranca sin errores;
5. mi tmux carga y el prefijo es Ctrl-a;
6. mi vimrc carga sin errores;
7. `mis-configs doctor` pasa.

Los pasos 4 a 7 están en `scripts/ci-checks.sh`, que también usa el PR mensual de versiones.

```bash
gh run list --limit 3        # ✓ verde, X rojo, * corriendo
gh run watch                 # seguir la última
gh run view --log-failed     # ver qué falló
```

Si sale en rojo, no actualizo otras máquinas hasta arreglarlo.

## Secretos

El repo es público. Antes de cada commit, gitleaks revisa lo que voy a subir y **bloquea el commit** si encuentra una llave, token o contraseña. Si es un falso positivo: `git commit --no-verify`, y solo si estoy seguro. Si es real: lo saco del archivo (va en `~/.bashrc.local`, que no se sube).

## PR mensual de versiones

Una sola vez en GitHub: **Settings → Actions → General → Workflow permissions → "Allow GitHub Actions to create and approve pull requests"**. Para probarlo sin esperar al día 1: `gh workflow run versions` y luego `gh pr list`.

## Convención de commits

`tipo: descripción` con `feat` (algo nuevo), `fix` (arreglo), `docs`, `ci` o `chore`. Ejemplo: `feat: atajo F5 para correr pytest`.
