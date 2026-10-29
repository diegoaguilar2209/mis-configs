# Lado Windows (una vez por máquina)

## 1. WSL2 con Ubuntu

En PowerShell como administrador:

```powershell
wsl --install -d Ubuntu-24.04
wsl --update
```

## 2. Fuente con íconos (Nerd Font)

```powershell
winget install --id DEVCOM.JetBrainsMonoNerdFont -e
```

Si winget no la encuentra, descárgala de [nerdfonts.com](https://www.nerdfonts.com/font-downloads) (JetBrainsMono), descomprime y haz clic derecho → "Instalar para todos los usuarios".

## 3. Windows Terminal

Abre Configuración → "Abrir archivo JSON" y, en `profiles.defaults`, agrega la fuente:

```json
"font": { "face": "JetBrainsMono Nerd Font", "size": 11 },
"padding": "8"
```

Deja el esquema de colores por defecto (Campbell): vim y Neovim usan la paleta del terminal con `torte`, así que con Campbell se ven como siempre (fondo negro, amarillo, turquesa, magenta).

Pon Ubuntu como perfil por defecto (`defaultProfile`) y, en su perfil, `"startingDirectory": "~"` para abrir siempre en el home de Linux.

## 4. Memoria de WSL (opcional)

Crea `C:\Users\<tu-usuario>\.wslconfig`:

```ini
[wsl2]
memory=8GB

[experimental]
autoMemoryReclaim=gradual
```

Reinicia con `wsl --shutdown`.

## Reglas de oro

- Proyectos siempre en `~/dev` (dentro de Linux), nunca en `/mnt/c`: es mucho más rápido y evita problemas de permisos y fin de línea.
- Para abrir la carpeta actual en el Explorador de Windows: `explorer.exe .`
