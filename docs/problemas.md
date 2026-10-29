# Problemas comunes

Primero: `mis-configs doctor`. Muestra versiones, enlaces y si hay algo pendiente.

| Síntoma | Causa | Solución |
| --- | --- | --- |
| Neovim: `module 'tokyonight' not found` (u otro plugin) | Una instalación se cortó y dejó carpetas de plugins solo con `.git` | `./install.sh` (las detecta y las vuelve a bajar), o `rm -rf ~/.local/share/nvim/site/pack/core` y `./install.sh` |
| tmux: `invalid option: allow-passthrough` | tmux 3.2 (Ubuntu 22.04) no tiene esa opción | No usarla, o subir a Ubuntu 24.04 (tmux 3.4) |
| git: `unknown style 'zdiff3'` | git 2.34 (Ubuntu 22.04) no lo soporta | El repo ya usa `diff3` |
| tmux no toma mi config | Un `~/.tmux.conf` que no es el enlace al repo | `ls -l ~/.tmux.conf` debe apuntar a `~/dev/mis-configs/tmux/tmux.conf`; si no, `./install.sh` |
| tmux no toma un cambio | La sesión sigue con la config vieja | `tmux source ~/.tmux.conf`, o `tmux kill-server` y volver a entrar |
| Copiar en tmux no llega a Windows | Falta `~/.tmux/yank.sh` o no es ejecutable | `ls -l ~/.tmux/yank.sh`; `./install.sh` lo enlaza |
| Íconos como cuadros | Windows Terminal no usa una Nerd Font | [windows/README.md](../windows/README.md) |
| Tagbar (F4 en vim) no muestra nada | Falta ctags | `sudo apt install universal-ctags` (el instalador ya lo incluye) |
| YouCompleteMe no funciona en vim | No se compiló | `cd ~/.vim/plugged/YouCompleteMe && python3 install.py` (con `--java-completer` necesita Java 17+) |
| Neovim no completa ni marca errores | El servidor de lenguaje no está instalado | `:Mason` para ver el estado, `:checkhealth vim.lsp` |
| Neovim sin colores de sintaxis | Faltan parsers | `:TSUpdate`; necesita `tree-sitter` y un compilador de C |
| Todo va lento | El proyecto está en `/mnt/c` | Moverlo a `~/dev` |
| `git push`: `Permission denied (publickey)` | `~/.ssh/config` usa una llave que GitHub no tiene | `ssh -vT git@github.com` muestra la llave ofrecida; registrar su `.pub` en GitHub → Settings → SSH keys |
| `git push`: `Repository not found` | El repo no existe aún en GitHub | Crearlo vacío en github.com/new |
| La prueba de GitHub sale en rojo | Algo no instala en una máquina limpia | `gh run view --log-failed` |
| `git commit` se bloquea con `leaks found` | gitleaks encontró algo que parece un secreto | Sacarlo del archivo; si es falso positivo, `git commit --no-verify` |
| `gitleaks not installed: commit not scanned` | Falta gitleaks en esta máquina | `./install.sh` |
| El PR mensual de versiones falla con `not permitted to create pull requests` | Falta el permiso en GitHub | Settings → Actions → General → "Allow GitHub Actions to create and approve pull requests" |
| `\tf` dice `No module named pytest` | El `env/` del proyecto no tiene pytest | `pip install pytest` (o agregarlo a `requirements-dev.in` y `lock`) |
| F5 no para en el punto de parada | Falta debugpy | `:MasonInstall debugpy`, o `pip install debugpy` en `env/` |
| `\ac` no abre Claude | `claude` no está en el PATH | `claude --version` en la terminal; instalarlo según la guía de Claude Code |
| `mkenv` / `lock` lentos | No está uv | `./install.sh` lo instala; `uv --version` para revisar |
