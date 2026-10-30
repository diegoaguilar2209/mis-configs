# Instalar

Funciona en WSL2 (Ubuntu 22.04 o 24.04), Ubuntu y Debian. Todo va dentro del home de Linux, nunca en `/mnt/c`: ahí es mucho más lento.

## 1. Lado Windows (una vez por laptop)

Instala la fuente con íconos y configura Windows Terminal: [windows/README.md](../windows/README.md).

## 2. Laptop nueva

```bash
mkdir -p ~/dev && cd ~/dev
git clone git@github.com:diegoaguilar2209/mis-configs.git
cd mis-configs
./scripts/backup-old.sh
./install.sh
source ~/.bashrc
mis-configs doctor
```

El instalador pide `sudo` una vez (paquetes del sistema) y, si git no los tiene, tu nombre y email. El paso de Neovim tarda unos minutos: déjalo terminar.

## 3. Máquina que ya tiene sus propias configs

Igual que arriba. `backup-old.sh` copia `.vimrc`, `.vim/`, `.tmux.conf`, `.tmux/`, `.bashrc`, `.profile` y `.gitconfig` a `~/mis-configs-old/` (o a una carpeta con fecha si ya existe). Además, el instalador mueve cada archivo que reemplaza a `~/.mis-configs-backup/<fecha>/` y pregunta antes de hacerlo.

Si esa máquina tiene cambios que quiero conservar en el repo, después de instalar: `mis-configs import`, reviso con `git diff` y hago commit.

## Qué hace el instalador

| Paso | Qué hace | Dónde |
| --- | --- | --- |
| 1. Sistema | git, tmux, ripgrep, fd, bat, jq, shellcheck, python3-venv/-dev, cmake, universal-ctags | apt |
| 2. Editor | Neovim y tree-sitter en las versiones de `versions.env` | `~/.local/opt`, `~/.local/bin` |
| 3. Herramientas | fzf, zoxide, eza, starship, lazygit, delta, uv, pre-commit (con `uv tool`), gitleaks, Node.js | `~/.local/bin` |
| 4. Enlaces | tmux, vim, Neovim, prompt, comandos; una línea en `~/.bashrc`; un `include` en `~/.gitconfig` | home |
| 5. Plugins tmux y vim | Clona cada `@plugin` de `tmux.conf` en `~/.tmux/plugins` y corre vim-plug (que también compila YouCompleteMe) | home |
| 6. Neovim | Plugins (versiones de `nvim-pack-lock.json`), 20 lenguajes de resaltado, servidores de lenguaje, formateadores y el depurador de Python | `~/.local/share/nvim` |
| 7. Repo | Activa el hook que revisa secretos antes de cada commit (`scripts/git-hooks/pre-commit`) | este repo |

Se puede correr las veces que quiera: lo que ya está no se vuelve a instalar, y si una instalación anterior se cortó a medias, la repara. Nunca toca las sesiones de tmux abiertas.

## Opciones

| Comando | Qué hace |
| --- | --- |
| `./install.sh --yes` | No pregunta antes de reemplazar (igual deja respaldo) |
| `./install.sh --no-node` | Sin Node.js; se pierden solo los servidores de bash, yaml, json y Docker |
| `./install.sh --no-apt` | Sin `sudo`: solo herramientas de usuario y configs |

## Volver atrás

```bash
rm ~/.vimrc ~/.tmux.conf ~/.config/nvim ~/.tmux/yank.sh ~/.vim/vpm
cp -a ~/mis-configs-old/. ~/
```

Y en `~/.bashrc`, borra las dos líneas que siguen a `# mis-configs`.
