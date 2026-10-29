# mis-configs

Mi terminal en un repo: **mi tmux y mi vim tal como los uso**, más Neovim con mis mismos atajos y las herramientas de terminal que uso a diario. Un comando deja cualquier laptop con WSL o Ubuntu igual que la mía.

```bash
mkdir -p ~/dev && git clone git@github.com:diegoaguilar2209/mis-configs.git ~/dev/mis-configs
~/dev/mis-configs/scripts/backup-old.sh   # guarda las configs que ya tenga esa máquina
~/dev/mis-configs/install.sh              # instala todo y enlaza mis configs al home
```

¿Sin llave SSH en GitHub (un amigo, por ejemplo)? Usa `https://github.com/diegoaguilar2209/mis-configs.git`.

## Cómo funciona

El instalador no copia archivos: crea **enlaces** desde el home hacia este repo.

```text
~/.tmux.conf      →  ~/dev/mis-configs/tmux/tmux.conf
~/.tmux/yank.sh   →  ~/dev/mis-configs/tmux/yank.sh
~/.vimrc          →  ~/dev/mis-configs/vim/vimrc
~/.vim/vpm        →  ~/dev/mis-configs/vim/vpm
~/.config/nvim    →  ~/dev/mis-configs/nvim
```

Editar `~/.vimrc` es editar el repo: el cambio aparece en `git status`, lo guardo con `git push` y lo traigo a otra máquina con `mis-configs update`.

## Documentación

| Guía | Para qué |
| --- | --- |
| [Instalar](docs/instalar.md) | Laptop nueva, máquina que ya tiene configs, opciones del instalador, cómo volver atrás |
| [Uso diario](docs/uso-diario.md) | tmux, vim, Neovim, shell y Python: qué hace cada cosa |
| [De vim a Neovim](docs/vim-a-neovim.md) | Por qué Neovim, equivalencia de atajos (F3, F4, CtrlP, YCM…) y plan de cambio |
| [Mantener el repo](docs/mantener.md) | Actualizar, agregar plugins, subir versiones, la prueba automática |
| [Problemas comunes](docs/problemas.md) | Síntomas y soluciones, incluidos los que ya me pasaron |
| [Atajos](docs/cheatsheet.md) | Todos los atajos en una hoja |
| [Lado Windows](windows/README.md) | Fuente con íconos, Windows Terminal y memoria de WSL |

## Qué hay en el repo

```text
install.sh              Instalador (se puede correr muchas veces)
versions.env            Versiones fijas de Neovim, fzf, lazygit, starship…
scripts/
  backup-old.sh         Respalda las configs de una máquina en ~/mis-configs-old
  import-current.sh     Trae al repo lo que cambié directo en ~/.tmux o ~/.vim
  check-versions.sh     Busca versiones nuevas de las herramientas de versions.env
  ci-checks.sh          Pruebas después de instalar (las usa GitHub)
  git-hooks/pre-commit  Bloquea commits con secretos (gitleaks)
bin/
  mis-configs           Comando: doctor, update, import, backup, status, edit
  tmux-sessionizer      Comando `t`: elegir un proyecto de ~/dev y abrir su sesión de tmux
tmux/                   Mi tmux: tmux.conf, yank.sh, toggle de atajos, config remota
vim/                    Mi vim: vimrc y vpm/sources.vim (lista de plugins)
nvim/                   Neovim con mis atajos de vim, tests, depurador y Claude Code (opcional)
shell/init.bash         Atajos de bash, fzf, zoxide, prompt, activación automática de env/
starship/               Prompt: daguilar@diegoaguilar:~/dev/x (rama) $
git/gitconfig           Mejoras visuales de git (delta); no cambia pull ni merge
docs/                   Esta documentación
.github/workflows/      Prueba en cada push y PR mensual con versiones nuevas
```

## Comando `mis-configs`

| Comando | Qué hace |
| --- | --- |
| `mis-configs doctor` | Versiones instaladas, enlaces y si hay actualizaciones |
| `mis-configs update` | `git pull` y vuelve a correr el instalador |
| `mis-configs import` | Copia al repo cambios hechos directo en `~/.tmux` o `~/.vim` |
| `mis-configs status` | Qué cambié y qué falta subir |
| `mis-configs backup` | Respalda las configs actuales de la máquina |
| `mis-configs edit` | Abre el repo en Neovim |

Nunca se tocan ni se suben `.ssh`, `.aws`, `.azure`, `.claude` ni tokens: el repo es público. gitleaks lo revisa antes de cada commit y en GitHub.
