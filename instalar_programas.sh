#!/usr/bin/env bash
# ============================================================
# Instalador de programas - Debian 13 (trixie) / Acadex OS
# XAMPP 8.2.12 | Android Studio 2026.1.1 | Bambu Studio 2.6.0
#
# Cisco Packet Tracer NO está acá: requiere cuenta gratuita en
# netacad.com, no hay link directo descargable por script.
# Ver instrucciones aparte.
#
# Uso:
#   chmod +x instalar_programas.sh
#   ./instalar_programas.sh xampp
#   ./instalar_programas.sh android
#   ./instalar_programas.sh bambu
#   ./instalar_programas.sh all
# ============================================================

set -e

DOWNLOAD_DIR="$HOME/Descargas"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

echo "=== Actualizando índices e instalando dependencias base ==="
sudo apt update
sudo apt install -y wget curl

# ------------------------------------------------------------
# XAMPP 8.2.12 (PHP 8.2) - instalador .run, no existe .deb
# ------------------------------------------------------------
instalar_xampp() {
    echo "=== Descargando XAMPP 8.2.12 ==="
    wget -O xampp-linux-installer.run \
        "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run/download"
    chmod +x xampp-linux-installer.run
    echo "=== Instalando XAMPP (se abre el wizard, seguí los pasos) ==="
    sudo ./xampp-linux-installer.run
}

# ------------------------------------------------------------
# Android Studio (Quail 1 | 2026.1.1 Patch 2) - .tar.gz oficial,
# no existe .deb para Debian/Ubuntu (el único .deb que publica
# Google es para el contenedor de ChromeOS, no sirve acá)
# ------------------------------------------------------------
instalar_android_studio() {
    echo "=== Descargando Android Studio ==="
    wget -O android-studio-linux.tar.gz \
        "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.1.10/android-studio-quail1-patch2-linux.tar.gz"
    echo "=== Extrayendo en /opt/android-studio ==="
    sudo tar -xzf android-studio-linux.tar.gz -C /opt/
    sudo ln -sf /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio
    echo "Listo. Ejecutá 'android-studio' para abrirlo."
}

# ------------------------------------------------------------
# Bambu Studio 2.6.0 - AppImage oficial (no hay .deb oficial,
# solo existen .deb hechos por terceros no oficiales)
# ------------------------------------------------------------
instalar_bambu_studio() {
    echo "=== Instalando dependencias de Bambu Studio ==="
    sudo apt install -y libfuse2 libwebkit2gtk-4.1-0
    echo "=== Descargando Bambu Studio 2.6.0 ==="
    wget -O BambuStudio.AppImage \
        "https://github.com/bambulab/BambuStudio/releases/download/v02.06.00.51/BambuStudio_ubuntu-24.04-v02.06.00.51-20260417160415.AppImage"
    chmod +x BambuStudio.AppImage
    mkdir -p "$HOME/.local/bin"
    mv BambuStudio.AppImage "$HOME/.local/bin/bambustudio"
    echo "Listo. Ejecutá 'bambustudio' (agregá ~/.local/bin al PATH si no está)."
}

case "$1" in
    xampp)   instalar_xampp ;;
    android) instalar_android_studio ;;
    bambu)   instalar_bambu_studio ;;
    all)     instalar_xampp; instalar_android_studio; instalar_bambu_studio ;;
    *)
        echo "Uso: $0 {xampp|android|bambu|all}"
        exit 1
        ;;
esac
