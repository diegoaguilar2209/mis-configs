# mis-configs

Mi terminal en un repo: **mi tmux y mi vim tal como los uso**, más Neovim 0.12 con mis mismos atajos y herramientas modernas de terminal, con versiones fijadas. En una laptop nueva, o para que un amigo tenga lo mismo que yo, basta con:

```bash
mkdir -p ~/dev && git clone https://github.com/diegoaguilar2209/mis-configs.git ~/dev/mis-configs
~/dev/mis-configs/scripts/backup-old.sh   # guarda las configs que ya tenga esa máquina en ~/mis-configs-old
~/dev/mis-configs/install.sh              # instala todo y enlaza mis configs al home
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
rm ~/.vimrc ~/.tmux.conf ~/.config/nvim   # quita los enlaces
cp -a ~/mis-configs-old/.vimrc ~/mis-configs-old/.tmux.conf ~/   # restaura lo anterior
```
y borra en `~/.bashrc` las dos líneas que siguen a `# mis-configs`.

## Qué instala y dónde

| Qué | Dónde | Notas |
| --- | --- | --- |
| Paquetes del sistema (git, tmux, ripgrep, fd, bat, jq, python3-venv, shellcheck) | apt | Pide `sudo` una vez; `--no-apt` lo omite |
| Neovim, tree-sitter, fzf, zoxide, eza, starship, lazygit, delta, Node.js | `~/.local/bin`, `~/.local/opt` | Versiones en [`versions.env`](versions.env); sin `sudo` |
| Config de Neovim | `~/.config/nvim` → `nvim/` | Enlace simbólico: cambios en el repo se ven al instante |
| Mi tmux | `~/.tmux.conf` → `tmux/tmux.conf`, y `~/.tmux/<archivo>` → `tmux/<archivo>` (yank.sh, toggle, remote) | Los plugins de la lista `@plugin` se clonan en `~/.tmux/plugins` |
| Prompt | `~/.config/starship.toml` | |
| Shell | una línea en `~/.bashrc` que carga `shell/init.bash` | Lo personal va en `~/.bashrc.local` |
| Git | `include.path` a `git/gitconfig` | Tu nombre y email siguen siendo tuyos |
| Mi vim | `~/.vimrc` → `vim/vimrc`, y `~/.vim/vpm` → `vim/vpm` | vim-plug instala los plugins de `vpm/sources.vim` |

## Uso diario

### tmux (mi config de siempre, prefijo Ctrl-a)

Mis atajos y los de mis plugins siguen igual: `prefix p` pega, `prefix D` desconecta otros clientes, `prefix C-t` oculta la barra, copia en modo vi con `v`/`y`/`Y`/`D`/`A` por `~/.tmux/yank.sh`, paneles con tmux-pain-control (`prefix |`, `prefix -`, `prefix h/j/k/l`, `prefix H/J/K/L`), sesiones con tmux-sessionx (`prefix O`), tmux-fzf (`prefix F`), tema nord y sesiones que se restauran solas (resurrect + continuum).

Extra de este repo, desde la shell: `t` elige un proyecto de `~/dev` con fzf y abre o retoma su sesión.

### vim

Mi `.vimrc` tal cual, con sus plugins por vim-plug (`vim/vpm/sources.vim`). YouCompleteMe necesita compilarse una vez en cada máquina: `cd ~/.vim/plugged/YouCompleteMe && python3 install.py`.

### Neovim (opcional, con mis mismos atajos)

`nvim` o `v` abren Neovim. `vim` sigue siendo vim. Los atajos son los de mi vimrc, pero por debajo usa herramientas actuales:

| Atajo (igual que en vim) | En vim era | En Neovim hace |
| --- | --- | --- |
| `\l` / `\h` / `\d` / `\bl` | buffers | Igual |
| `Ctrl-s` | guardar | Igual |
| `,e` `,g` `,G` `,f` `,m` `,c` y `,w…` | CtrlP | fzf-lua: archivos, símbolos, líneas, recientes, comandos |
| `F3` / `,t` | NERDTree | oil (explorador que se edita como texto; `:w` aplica) |
| `F4` | Tagbar | Símbolos del archivo |
| `gd` `gD` `gt` `gi` | YouCompleteMe | LSP: definición, declaración, tipo, implementación |
| `,d` `,o` `,a` `,D` | Jedi | LSP: definición, referencias, asignación, definición en pestaña |
| `\e`, `\sn` `\sp` `\se` `\sl` | Syntastic / loclist | Errores del LSP en la location list |

Novedades que no tenía vim: `,r` busca texto en todo el proyecto, `\gg` abre lazygit, `]c`/`[c` saltan entre cambios de git, `\gp` muestra el cambio, `\cf` formatea (y Python se formatea con isort + black al guardar; `:FormatToggle` lo apaga). Presiona `\` o `,` y espera: aparece la lista de atajos.

### Python

Mi convención: entorno en `env/` y dependencias con pip-tools.

- `mkenv` crea `env/`, instala pip-tools y sincroniza `requirements*.txt`.
- `lock` compila `requirements*.in` y sincroniza.
- Al entrar a una carpeta con `env/`, se activa sola. Neovim usa el black, isort y basedpyright de ese entorno si existen, y si no, los de Mason.

### Con Claude Code

- Neovim recarga solo los archivos que Claude modifica.
- Para abrir Claude al lado del editor: `prefix |` para dividir y `claude` en el panel nuevo.

## Ajustes solo para una máquina

- Neovim: crea `nvim/lua/user/init.lua` (está en `.gitignore`); se carga al final.
- Shell: `~/.bashrc.local`.
- Git: tu `~/.gitconfig` manda sobre `git/gitconfig`.

## Mantener el repo

- **Actualizar tu máquina:** `mis-configs update`, que hace `git pull` y vuelve a correr el instalador.
- **Subir la versión de una herramienta:** cámbiala en `versions.env`, corre `./install.sh`, prueba y haz commit.
- **Actualizar plugins de Neovim:** `:PackUpdate`, revisa los cambios, `:write` para aceptar y commit de `nvim/nvim-pack-lock.json`.
- **Cambié algo en tmux o vim directamente en `~/.tmux/` o `~/.vim/`:** `./scripts/import-current.sh`, revisa con `git diff` y haz commit.
- **Agregar un plugin de tmux:** una línea `set -g @plugin '...'` en `tmux/tmux.conf` y vuelve a correr `./install.sh` (o `prefix I`).
- **Agregar un plugin de Neovim:** súmalo en `nvim/lua/team/plugins.lua` con una línea que explique para qué sirve.
- Cada push corre la CI, que prueba el instalador en un Ubuntu limpio.

## Problemas comunes

| Síntoma | Solución |
| --- | --- |
| Íconos se ven como cuadros | Falta la Nerd Font en Windows Terminal ([windows/README.md](windows/README.md)) |
| tmux no toma un cambio | `tmux source ~/.tmux.conf`, o cierra todo con `tmux kill-server` |
| Copiar en tmux no llega a Windows | Usa Windows Terminal (soporta OSC 52) y actualízalo; `set-clipboard` ya está activo |
| Todo va lento | El proyecto está en `/mnt/c`; muévelo a `~/dev` |
| No aparece un servidor de lenguaje | `:Mason` para ver el estado; `:checkhealth vim.lsp` |
| Faltan resaltados de sintaxis | `:TSUpdate`; necesita `tree-sitter` y un compilador de C (`build-essential`) |

Fuentes de la evaluación: [Neovim 0.12 (Wikipedia)](https://en.wikipedia.org/wiki/Neovim), [tmux vs Zellij](https://dasroot.net/posts/2026/02/terminal-multiplexers-tmux-vs-zellij-comparison/), [Herdr vs tmux vs Zellij](https://flaviocopes.com/herdr-vs-tmux-zellij), [terminales para Windows 2026](https://www.heyuan110.com/posts/ai/2026-06-22-best-windows-terminal-2026/), [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
