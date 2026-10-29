# mis-configs

Mi terminal en un repo: **Neovim 0.12, tmux, herramientas modernas de terminal y mis configuraciones**, con versiones fijadas. En una laptop nueva, o para que un amigo tenga lo mismo que yo, basta con:

```bash
mkdir -p ~/dev && git clone https://github.com/diegoaguilar2209/mis-configs.git ~/dev/mis-configs
~/dev/mis-configs/scripts/backup-old.sh   # guarda las configs actuales en ~/mis-configs-old
~/dev/mis-configs/install.sh              # instala todo y enlaza las configs al home
```

## Por qué estas herramientas (octubre 2026)

| Pieza | Elección | Por qué | Alternativas evaluadas |
| --- | --- | --- | --- |
| Editor | **Neovim 0.12** | Mismas teclas que Vim, pero con LSP, tree-sitter, gestor de plugins y autocompletado incluidos. 0.12 trae `vim.pack` con archivo de bloqueo: cada máquina usa las mismas versiones de plugins | Vim (se queda como respaldo en `vim/vimrc`), Helix (sin plugins y con otras teclas), VS Code (no vive en la terminal) |
| Multiplexor | **tmux 3.2+** | Estable, scriptable, funciona por SSH y es el que integran Claude Code (`--tmux`) y otras herramientas de agentes | Zellij (más amigable, pero menos maduro y con más memoria); Herdr (nuevo, sabe qué agente espera aprobación: vale la pena seguirlo) |
| Terminal en Windows | **Windows Terminal** | Viene con Windows 11, detecta WSL y soporta portapapeles OSC 52 | WezTerm (si quieres la misma config en Mac/Linux). Ghostty todavía no tiene versión oficial para Windows |
| Prompt | **Starship** | Rápido, una sola config | — |
| Utilidades | fzf, ripgrep, fd, bat, eza, zoxide, lazygit, delta | Buscar, navegar y revisar git mucho más rápido | — |

## Instalación paso a paso

1. **En Windows** (una vez por máquina): sigue [windows/README.md](windows/README.md) para instalar la fuente y configurar Windows Terminal.
2. **En WSL**, siempre dentro del home de Linux y nunca en `/mnt/c`:

```bash
mkdir -p ~/dev && cd ~/dev
git clone https://github.com/diegoaguilar2209/mis-configs.git
cd mis-configs
./scripts/backup-old.sh   # copia .vimrc, .vim, .tmux.conf, .tmux, .bashrc, .gitconfig... a ~/mis-configs-old
./install.sh              # pregunta antes de reemplazar cada archivo
```

Opciones del instalador:

| Comando | Qué hace |
| --- | --- |
| `./install.sh --yes` | Sin preguntas (igual deja respaldo) |
| `./install.sh --no-node` | Sin Node.js (solo lo usan los servidores de bash, yaml y json) |
| `./install.sh --no-apt` | Sin `sudo`: solo herramientas y configs de usuario |

3. Abre una terminal nueva y corre `mis-configs doctor`: todo debe salir con versión y nada como `MISSING`.

El instalador se puede correr las veces que quieras: solo actualiza lo que cambió. No copia archivos al home: crea **enlaces** a este repo, así que editar algo aquí lo cambia al instante, y un `git pull` actualiza la máquina. Lo que reemplaza queda en `~/.mis-configs-backup/<fecha>/`.

Nunca se tocan ni se guardan en el repo `.ssh`, `.aws`, `.azure`, `.claude` ni ningún token.

### Volver atrás

```bash
rm ~/.vimrc ~/.config/nvim ~/.config/tmux/tmux.conf   # quita los enlaces
cp -a ~/mis-configs-old/.vimrc ~/mis-configs-old/.tmux.conf ~/   # restaura lo anterior
```
y borra en `~/.bashrc` las dos líneas que siguen a `# mis-configs`.

## Qué instala y dónde

| Qué | Dónde | Notas |
| --- | --- | --- |
| Paquetes del sistema (git, tmux, ripgrep, fd, bat, jq, python3-venv, shellcheck) | apt | Pide `sudo` una vez; `--no-apt` lo omite |
| Neovim, tree-sitter, fzf, zoxide, eza, starship, lazygit, delta, Node.js | `~/.local/bin`, `~/.local/opt` | Versiones en [`versions.env`](versions.env); sin `sudo` |
| Config de Neovim | `~/.config/nvim` → `nvim/` | Enlace simbólico: cambios en el repo se ven al instante |
| Config de tmux + plugins | `~/.config/tmux/tmux.conf` → `tmux/tmux.conf` | Plugins: resurrect y continuum (restauran sesiones) |
| Prompt | `~/.config/starship.toml` | |
| Shell | una línea en `~/.bashrc` que carga `shell/init.bash` | Lo personal va en `~/.bashrc.local` |
| Git | `include.path` a `git/gitconfig` | Tu nombre y email siguen siendo tuyos |
| Vim clásico | `~/.vimrc` → `vim/vimrc` | Sin plugins, para servidores |

## Uso diario

```bash
t                      # elige un proyecto con fzf y abre (o retoma) su sesión de tmux
cd ~/dev/x && v  # abre Neovim
```

Dentro de tmux (prefijo **Ctrl-a**):

| Teclas | Acción |
| --- | --- |
| `Ctrl-a f` | Saltar a otro proyecto |
| `Ctrl-a \|` / `Ctrl-a -` | Dividir vertical / horizontal |
| `Ctrl-h/j/k/l` | Moverse entre paneles de tmux y ventanas de Neovim |
| `Ctrl-a C` | Claude Code en un panel al lado, en la carpeta actual |
| `Ctrl-a g` | lazygit en una ventana flotante |
| `Ctrl-a [` | Modo copia (vim): `v` selecciona, `y` copia al portapapeles de Windows |

En Neovim (líder **Espacio**; presiónalo y espera para ver todos los atajos):

| Teclas | Acción |
| --- | --- |
| `Espacio Espacio` / `Espacio f g` | Buscar archivo / buscar texto en el proyecto |
| `-` | Explorador de archivos (se edita como un buffer) |
| `gd` / `K` / `grr` / `grn` | Ir a definición / documentación / referencias / renombrar |
| `Espacio c f` | Formatear (también se formatea al guardar) |
| `Espacio g g` | lazygit |
| `]h` / `Espacio h p` | Siguiente cambio de git / ver el cambio |

Hoja completa: [docs/cheatsheet.md](docs/cheatsheet.md).

### Python

Mi convención: entorno en `env/` y dependencias con pip-tools.

- `mkenv` crea `env/`, instala pip-tools y sincroniza `requirements*.txt`.
- `lock` compila `requirements*.in` y sincroniza.
- Al entrar a una carpeta con `env/`, se activa sola. Neovim usa el black, isort y basedpyright de ese entorno si existen, y si no, los de Mason.

### Con Claude Code

- `Ctrl-a C` abre Claude en un panel junto a tu editor.
- `Shift+Enter` funciona dentro de tmux (extended keys activado).
- Neovim recarga solo los archivos que Claude modifica.

## Ajustes solo para una máquina

- Neovim: crea `nvim/lua/user/init.lua` (está en `.gitignore`); se carga al final.
- Shell: `~/.bashrc.local`.
- Git: tu `~/.gitconfig` manda sobre `git/gitconfig`.

## Mantener el repo

- **Actualizar tu máquina:** `mis-configs update`, que hace `git pull` y vuelve a correr el instalador.
- **Subir la versión de una herramienta:** cámbiala en `versions.env`, corre `./install.sh`, prueba y haz commit.
- **Actualizar plugins de Neovim:** `:PackUpdate`, revisa los cambios, `:write` para aceptar y commit de `nvim/nvim-pack-lock.json`.
- **Agregar un plugin:** súmalo en `nvim/lua/team/plugins.lua` con una línea que explique para qué sirve. Menos plugins es mejor.
- Cada push corre la CI, que prueba el instalador en un Ubuntu limpio.

## Problemas comunes

| Síntoma | Solución |
| --- | --- |
| Íconos se ven como cuadros | Falta la Nerd Font en Windows Terminal ([windows/README.md](windows/README.md)) |
| Colores raros dentro de tmux | Cierra todas las sesiones (`tmux kill-server`) y vuelve a entrar |
| Copiar en tmux no llega a Windows | Usa Windows Terminal (soporta OSC 52) y actualízalo; `set-clipboard` ya está activo |
| Todo va lento | El proyecto está en `/mnt/c`; muévelo a `~/dev` |
| No aparece un servidor de lenguaje | `:Mason` para ver el estado; `:checkhealth vim.lsp` |
| Faltan resaltados de sintaxis | `:TSUpdate`; necesita `tree-sitter` y un compilador de C (`build-essential`) |

Fuentes de la evaluación: [Neovim 0.12 (Wikipedia)](https://en.wikipedia.org/wiki/Neovim), [tmux vs Zellij](https://dasroot.net/posts/2026/02/terminal-multiplexers-tmux-vs-zellij-comparison/), [Herdr vs tmux vs Zellij](https://flaviocopes.com/herdr-vs-tmux-zellij), [terminales para Windows 2026](https://www.heyuan110.com/posts/ai/2026-06-22-best-windows-terminal-2026/), [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
