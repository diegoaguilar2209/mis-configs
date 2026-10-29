# mis-configs

Una terminal lista para programar en minutos: **Neovim, tmux y herramientas modernas de línea de comandos**, ya configurados y probados juntos. Un comando instala todo en WSL2, Ubuntu o Debian, y cada persona del equipo obtiene exactamente lo mismo.

## Qué obtienes

| | |
| --- | --- |
| **Editor** | Neovim con autocompletado, errores mientras escribes, ir a definición, formateo al guardar, árbol de carpetas (`F3`), lista de funciones (`F4`), búsqueda en todo el proyecto, tests y depurador. Viene con vim clásico configurado, por si lo prefieres. |
| **IA** | Claude Code integrado en el editor: ve el archivo y lo que seleccionas, y te muestra sus cambios como diff para aceptarlos o rechazarlos. |
| **Terminal** | tmux con sesiones que se guardan solas, paneles con atajos simples y copiar al portapapeles (también el de Windows). `t` abre cualquier proyecto en su propia sesión. |
| **Shell** | Historial con búsqueda (fzf), saltar a carpetas con `z`, prompt con la rama de git, lazygit, delta para diffs más legibles. |
| **Python** | `mkenv` crea el entorno virtual e instala dependencias con uv (mucho más rápido que pip). El entorno se activa solo al entrar a la carpeta. |
| **Seguridad** | Cada commit se revisa con gitleaks: si trae una llave o un token, se bloquea. |

Las versiones están fijas (`versions.env` y `nvim/nvim-pack-lock.json`), así que todos tienen las mismas. Una vez al mes, GitHub busca versiones nuevas, las prueba en un Ubuntu limpio y abre un PR.

## Instalar

Requisitos: WSL2 (Ubuntu 22.04 o 24.04), Ubuntu o Debian, y `git`. En Windows, instala también una Nerd Font para ver los íconos: [windows/README.md](windows/README.md).

```bash
mkdir -p ~/dev && git clone https://github.com/diegoaguilar2209/mis-configs.git ~/dev/mis-configs
cd ~/dev/mis-configs
./scripts/backup-old.sh   # copia tus configs actuales a ~/mis-configs-old
./install.sh              # pide sudo una vez; tarda unos minutos
source ~/.bashrc
mis-configs doctor        # confirma que todo quedó bien
```

El instalador no copia archivos: **enlaza** tu home a este repo (`~/.config/nvim → ~/dev/mis-configs/nvim`, etc.). Antes de reemplazar algo, pregunta y lo guarda en `~/.mis-configs-backup/`. Puedes correrlo las veces que quieras.

Opciones: `--yes` no pregunta, `--no-apt` instala sin sudo, `--no-node` instala sin Node.js. Detalle y cómo volver atrás: [docs/instalar.md](docs/instalar.md).

> Mantén tus proyectos en `~/dev` (dentro de Linux), no en `/mnt/c`: ahí todo es mucho más lento.

## Primeros 5 minutos

```bash
t                 # elige un proyecto de ~/dev y abre su sesión de tmux
nvim archivo.py   # abre el editor
```

| Atajo | Dónde | Qué hace |
| --- | --- | --- |
| `Ctrl-a` y luego `\|` / `-` | tmux | Dividir el panel vertical / horizontal |
| `Ctrl-a` y luego `h` `j` `k` `l` | tmux | Moverte entre paneles |
| `,e` / `,r` | Neovim | Buscar archivo / buscar texto en el proyecto |
| `F3` / `F4` | Neovim | Árbol de carpetas / funciones y variables del archivo |
| `gd` / `K` | Neovim | Ir a la definición / ver documentación |
| `\tf` / `F9` + `F5` | Neovim | Correr los tests del archivo / depurar con un punto de parada |
| `\ac` | Neovim | Abrir Claude Code junto al código |
| `\` o `,` y esperar | Neovim | Ver todos los atajos disponibles |

Todos los atajos en una hoja: [docs/cheatsheet.md](docs/cheatsheet.md).

## Hacerlo tuyo

- **Solo en tu máquina** (no se sube): alias y variables en `~/.bashrc.local`; ajustes de Neovim en `nvim/lua/user/init.lua`.
- **Para todo el equipo**: haz fork del repo, edita los archivos (por ejemplo `~/.tmux.conf`, que ya es el repo), commit y push. En las demás máquinas: `mis-configs update`.

## Comando `mis-configs`

| Comando | Qué hace |
| --- | --- |
| `mis-configs doctor` | Revisa versiones, enlaces y si falta algo |
| `mis-configs update` | Trae los últimos cambios del repo y reinstala lo necesario |
| `mis-configs status` | Muestra qué cambiaste y qué falta subir |
| `mis-configs import` | Guarda en el repo cambios hechos directo en `~/.tmux` o `~/.vim` |
| `mis-configs backup` | Respalda las configs actuales de la máquina |
| `mis-configs edit` | Abre el repo en Neovim |

## Documentación

| Guía | Para qué |
| --- | --- |
| [Instalar](docs/instalar.md) | Paso a paso, opciones, máquinas que ya tienen configs, volver atrás |
| [Uso diario](docs/uso-diario.md) | tmux, Neovim, shell, Python, tests, depurador y Claude Code |
| [De vim a Neovim](docs/vim-a-neovim.md) | Si vienes de vim: equivalencias y plan de cambio |
| [Atajos](docs/cheatsheet.md) | Todos los atajos en una hoja |
| [Mantener el repo](docs/mantener.md) | Agregar plugins, subir versiones, la prueba automática |
| [Problemas comunes](docs/problemas.md) | Síntomas y soluciones |
| [Lado Windows](windows/README.md) | Fuente con íconos y Windows Terminal |

## Qué hay en el repo

```text
install.sh          Instalador
versions.env        Versiones fijas de cada herramienta
nvim/               Neovim
tmux/               tmux
vim/                vim clásico
shell/init.bash     Atajos de bash, fzf, zoxide, entornos de Python
starship/  git/     Prompt y mejoras visuales de git
bin/                Comandos mis-configs y t
scripts/            Respaldo, importar cambios, revisar versiones, hook de secretos
docs/               Documentación
.github/workflows/  Prueba en cada push y PR mensual de versiones
```

## Seguridad

El repo es público: nunca guarda ni toca `~/.ssh`, `~/.aws`, `~/.azure`, `~/.claude`, tokens ni contraseñas. Lo personal va en `~/.bashrc.local`, que no se sube. gitleaks revisa cada commit en tu máquina y todo el historial en GitHub.

## Licencia

[MIT](LICENSE)
