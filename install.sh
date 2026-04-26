#!/bin/bash

set -euo pipefail

# ─────────────────────────────────────────────
# Colores para output
# ─────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ─────────────────────────────────────────────
# Verificar que el repositorio de dotfiles existe
# ─────────────────────────────────────────────
DOTFILES_DIR="$HOME/dotfiles"
[ -d "$DOTFILES_DIR" ] || error "El directorio $DOTFILES_DIR no existe. Clona tu repositorio primero."

# ─────────────────────────────────────────────
# Detectar distribución / gestor de paquetes
# ─────────────────────────────────────────────
detect_distro() {
  if [[ "$(uname)" == "Darwin" ]]; then
    DISTRO="macos"
    PKG_MANAGER="brew"
  elif [ -f /etc/os-release ]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    DISTRO="${ID:-unknown}"
    case "$DISTRO" in
      ubuntu|debian|linuxmint|pop)   PKG_MANAGER="apt"     ;;
      arch|manjaro|endeavouros)      PKG_MANAGER="pacman"  ;;
      fedora|rhel|centos|rocky|alma) PKG_MANAGER="dnf"     ;;
      opensuse*|sles)                PKG_MANAGER="zypper"  ;;
      *)                             PKG_MANAGER="unknown" ;;
    esac
  else
    DISTRO="unknown"
    PKG_MANAGER="unknown"
  fi
  info "Sistema detectado: $DISTRO (gestor: $PKG_MANAGER)"
}

# ─────────────────────────────────────────────
# Instalar un paquete usando el gestor detectado
# ─────────────────────────────────────────────
install_pkg() {
  local pkg="$1"
  case "$PKG_MANAGER" in
    apt)    sudo apt-get install -y "$pkg" ;;
    pacman) sudo pacman -S --noconfirm "$pkg" ;;
    dnf)    sudo dnf install -y "$pkg" ;;
    zypper) sudo zypper install -y "$pkg" ;;
    brew)   brew install "$pkg" ;;
    *)      warn "Gestor de paquetes desconocido. Instala '$pkg' manualmente." ;;
  esac
}

# ─────────────────────────────────────────────
# Verificar si una herramienta está instalada
# y ofrecerla instalar si falta
# ─────────────────────────────────────────────
ensure_tool() {
  local cmd="$1"
  local pkg="${2:-$1}"

  if command -v "$cmd" &>/dev/null; then
    success "$cmd ya está instalado ($(command -v "$cmd"))"
  else
    warn "$cmd no encontrado."
    read -rp "  ¿Instalar '$pkg' ahora? [s/N]: " answer
    if [[ "$answer" =~ ^[sSyY]$ ]]; then
      install_pkg "$pkg"
      success "$pkg instalado."
    else
      warn "Se omitió la instalación de $pkg. Algunos symlinks pueden no funcionar."
    fi
  fi
}

# ─────────────────────────────────────────────
# Crear symlink de forma segura
# ─────────────────────────────────────────────
safe_symlink() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    warn "Origen no encontrado, se omite: $src"
    return
  fi

  if [ -L "$dest" ] || [ -e "$dest" ]; then
    rm -rf "$dest"
    warn "Destino anterior eliminado: $dest"
  fi

  ln -s "$src" "$dest"
  success "Symlink: $dest → $src"
}

# ─────────────────────────────────────────────
# Instalar plugin zsh desde repo dedicado (git clone)
# ─────────────────────────────────────────────
ZSH_PLUGINS_DIR="/usr/share/zsh/plugins"

install_zsh_plugin() {
  local plugin_name="$1"
  local repo="$2"
  local subdir="${3:-}"
  local dest="$ZSH_PLUGINS_DIR/$plugin_name"

  if [ -d "$dest" ]; then
    success "Plugin ya instalado: $plugin_name"
    return
  fi

  info "Instalando plugin: $plugin_name..."
  sudo mkdir -p "$dest"

  if [ -n "$subdir" ]; then
    local tmp_dir
    tmp_dir="$(mktemp -d)"
    git clone --quiet --depth 1 "https://github.com/$repo" "$tmp_dir"
    sudo cp -r "$tmp_dir/$subdir/." "$dest/"
    rm -rf "$tmp_dir"
  else
    sudo git clone --quiet --depth 1 "https://github.com/$repo" "$dest"
  fi

  success "Plugin instalado: $plugin_name → $dest"
}

# ─────────────────────────────────────────────
# Instalar un plugin zsh descargando solo el archivo .zsh
# (más ligero que clonar repo entero)
# ─────────────────────────────────────────────
install_zsh_plugin_file() {
  local plugin_name="$1"
  local raw_url="$2"
  local filename="$3"
  local dest="$ZSH_PLUGINS_DIR/$plugin_name"

  if [ -d "$dest" ] && [ -f "$dest/$filename" ]; then
    success "Plugin ya instalado: $plugin_name"
    return
  fi

  info "Instalando plugin: $plugin_name (descarga directa)..."
  sudo mkdir -p "$dest"
  sudo curl -fsSL "$raw_url" -o "$dest/$filename"
  success "Plugin instalado: $plugin_name → $dest/$filename"
}

# ─────────────────────────────────────────────
# Instalar fuente Cascadia Code desde GitHub Releases
# Detecta la última versión via API de GitHub
# Instala en /usr/share/fonts/truetype/CascadiaCode (sistema)
# ─────────────────────────────────────────────
install_cascadia_code() {
  local font_dir="/usr/share/fonts/truetype/CascadiaCode"

  # 1. Verificar si el directorio ya existe y tiene fuentes
  if [ -d "$font_dir" ] && ls "$font_dir"/*.ttf &>/dev/null; then
    success "Cascadia Code ya está instalada en $font_dir"
    return
  fi

  # 2. Verificar si ya está instalada consultando fc-list (si existe)
  if command -v fc-list &>/dev/null; then
    if fc-list | grep -qi "cascadia"; then
      success "Cascadia Code ya está instalada (detectado por fc-list)."
      return
    fi
  fi

  info "Obteniendo última versión de Cascadia Code desde GitHub..."

  # Obtener la versión más reciente via GitHub API
  local version
  version="$(curl -fsSL "https://api.github.com/repos/microsoft/cascadia-code/releases/latest" \
    | grep '"tag_name"' \
    | sed 's/.*"tag_name": *"v\?\([^"]*\)".*/\1/')"

  if [ -z "$version" ]; then
    warn "No se pudo obtener la versión de Cascadia Code. Usando versión de respaldo: 2407.24"
    version="2407.24"
  fi

  info "Versión encontrada: $version"

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local zip_file="$tmp_dir/CascadiaCode.zip"
  local download_url="https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaCode-${version}.zip"

  info "Descargando desde: $download_url"
  curl -fsSL "$download_url" -o "$zip_file"

  info "Extrayendo fuentes..."
  unzip -q "$zip_file" -d "$tmp_dir"

  # Crear directorio de fuentes del sistema
  sudo mkdir -p "$font_dir"

  # Copiar archivos .ttf (carpeta ttf/ dentro del zip)
  if [ -d "$tmp_dir/ttf" ]; then
    sudo cp "$tmp_dir/ttf/"*.ttf "$font_dir/"
  else
    # Fallback: buscar todos los .ttf en el directorio extraído
    find "$tmp_dir" -name "*.ttf" -exec sudo cp {} "$font_dir/" \;
  fi

  # Limpiar temporales
  rm -rf "$tmp_dir"

  # Actualizar caché de fuentes
  info "Actualizando caché de fuentes (fc-cache)..."
  sudo fc-cache -f

  success "Cascadia Code v${version} instalada en $font_dir"
}

# ─────────────────────────────────────────────
# INICIO
# ─────────────────────────────────────────────
echo ""
info "======================================"
info "   Instalando dotfiles de $USER"
info "======================================"
echo ""

# ─────────────────────────────────────────────
# Detectar distro
# ─────────────────────────────────────────────
detect_distro

# ─────────────────────────────────────────────
# Verificar herramientas requeridas
# ─────────────────────────────────────────────
echo ""
info "Verificando herramientas requeridas..."
ensure_tool "zsh"
ensure_tool "nvim" "neovim"
ensure_tool "tmux"
ensure_tool "git"
ensure_tool "curl"
ensure_tool "unzip"
ensure_tool "fc-list" "fontconfig"

# ─────────────────────────────────────────────
# Cambiar shell a zsh si no es el actual
# ─────────────────────────────────────────────
if [[ "$SHELL" != *"zsh"* ]]; then
  ZSH_PATH="$(command -v zsh 2>/dev/null || true)"
  if [ -n "$ZSH_PATH" ]; then
    read -rp "¿Cambiar shell por defecto a zsh ($ZSH_PATH)? [s/N]: " answer
    if [[ "$answer" =~ ^[sSyY]$ ]]; then
      sudo chsh -s "$ZSH_PATH" "$USER"
      success "Shell cambiado a zsh. Efectivo en el próximo login."
    fi
  fi
else
  success "Shell ya es zsh ($SHELL)"
fi

# ─────────────────────────────────────────────
# Instalar plugins de zsh
# ─────────────────────────────────────────────
echo ""
info "Instalando plugins de zsh en $ZSH_PLUGINS_DIR..."
sudo mkdir -p "$ZSH_PLUGINS_DIR"

install_zsh_plugin      "zsh-syntax-highlighting"     "zsh-users/zsh-syntax-highlighting"
install_zsh_plugin      "zsh-autosuggestions"          "zsh-users/zsh-autosuggestions"
install_zsh_plugin      "zsh-history-substring-search" "zsh-users/zsh-history-substring-search"
install_zsh_plugin_file "zsh-sudo" \
  "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh" \
  "sudo.plugin.zsh"

# ─────────────────────────────────────────────
# Instalar fuente Cascadia Code
# ─────────────────────────────────────────────
echo ""
info "Instalando fuente Cascadia Code..."
install_cascadia_code

# ─────────────────────────────────────────────
# Crear directorios necesarios
# ─────────────────────────────────────────────
echo ""
info "Creando directorios necesarios..."
mkdir -p "$HOME/.config"
success "~/.config listo"

# ─────────────────────────────────────────────
# Crear symlinks
# ─────────────────────────────────────────────
echo ""
info "Creando symlinks de dotfiles..."

safe_symlink "$DOTFILES_DIR/nvim"       "$HOME/.config/nvim"
safe_symlink "$DOTFILES_DIR/kitty"      "$HOME/.config/kitty"
safe_symlink "$DOTFILES_DIR/alacritty"  "$HOME/.config/alacritty"
safe_symlink "$DOTFILES_DIR/zshrc"      "$HOME/.zshrc"
safe_symlink "$DOTFILES_DIR/p10k.zsh"   "$HOME/.p10k.zsh"
safe_symlink "$DOTFILES_DIR/tmux.conf"  "$HOME/.tmux.conf"

# ─────────────────────────────────────────────
# Configuración SSH
# ─────────────────────────────────────────────
echo ""
info "Configurando SSH..."
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

SSH_CONFIG="$HOME/.ssh/config"
if [ ! -f "$SSH_CONFIG" ]; then
  touch "$SSH_CONFIG"
  success "Archivo ~/.ssh/config creado."
else
  warn "~/.ssh/config ya existe, no se sobreescribe."
fi

chmod 600 "$SSH_CONFIG"
success "Permisos 600 aplicados a ~/.ssh/config"

# ─────────────────────────────────────────────
# FIN
# ─────────────────────────────────────────────
echo ""
success "======================================"
success "  ¡Dotfiles instalados correctamente!"
success "======================================"
