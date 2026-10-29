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

Abre Configuración → "Abrir archivo JSON" y agrega lo siguiente:

- En `profiles.defaults`:

```json
"font": { "face": "JetBrainsMono Nerd Font", "size": 11 },
"colorScheme": "Tokyo Night",
"padding": "8",
"intenseTextStyle": "bright"
```

- En la lista `schemes`:

```json
{
  "name": "Tokyo Night",
  "background": "#1A1B26", "foreground": "#C0CAF5",
  "cursorColor": "#C0CAF5", "selectionBackground": "#33467C",
  "black": "#15161E", "red": "#F7768E", "green": "#9ECE6A", "yellow": "#E0AF68",
  "blue": "#7AA2F7", "purple": "#BB9AF7", "cyan": "#7DCFFF", "white": "#A9B1D6",
  "brightBlack": "#414868", "brightRed": "#F7768E", "brightGreen": "#9ECE6A",
  "brightYellow": "#E0AF68", "brightBlue": "#7AA2F7", "brightPurple": "#BB9AF7",
  "brightCyan": "#7DCFFF", "brightWhite": "#C0CAF5"
}
```

- Pon Ubuntu como perfil por defecto (`defaultProfile`) y, en su perfil, `"startingDirectory": "~"`, para abrir siempre en tu home de Linux.

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
