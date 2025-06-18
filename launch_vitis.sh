#!/bin/bash

# Vitis Launch Script for VNC Environment
# Fixes GPU initialization issues and provides proper X11 environment

echo "Launching Vitis in VNC environment..."

# Set up display and X11 environment
export DISPLAY=:4
export QT_X11_NO_MITSHM=1
export _JAVA_AWT_WM_NONREPARENTING=1

# GPU workarounds for Electron/VNC - use software rendering
export LIBGL_ALWAYS_SOFTWARE=1

# Additional Electron workarounds
export ELECTRON_NO_ASAR=1
export ELECTRON_DISABLE_SECURITY_WARNINGS=1

# Ensure X11 access
xhost +local: 2>/dev/null || echo "Warning: Could not configure X11 access"

# Source Xilinx environment
if [ -f "/home/xjh/xilinx/2025.1/Vitis/settings64.sh" ]; then
    source /home/xjh/xilinx/2025.1/Vitis/settings64.sh
    echo "Xilinx Vitis environment loaded"
else
    echo "Error: Cannot find Vitis settings64.sh"
    exit 1
fi

# Check if Vitis IDE exists
if [ ! -f "$XILINX_VITIS/ide/electron-app/lnx64/vitis-ide" ]; then
    echo "Error: Vitis IDE not found at $XILINX_VITIS/ide/electron-app/lnx64/vitis-ide"
    exit 1
fi

echo "Starting Vitis IDE with GPU workarounds..."

# Launch Vitis with all necessary flags for VNC/remote desktop
$XILINX_VITIS/ide/electron-app/lnx64/vitis-ide \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-extensions \
    --disable-default-apps \
    --disable-plugins \
    --disable-sync \
    --disable-translate \
    --disable-background-networking \
    --disable-background-timer-throttling \
    --disable-client-side-phishing-detection \
    --disable-component-update \
    --disable-domain-reliability \
    --log-level=error \
    "$@" &

VITIS_PID=$!
echo "Vitis IDE started with PID: $VITIS_PID"
echo "If Vitis doesn't appear, check the VNC client connection to display :4 (port 5904)"

# Wait a moment and check if the process is still running
sleep 3
if kill -0 $VITIS_PID 2>/dev/null; then
    echo "Vitis IDE is running successfully"
else
    echo "Error: Vitis IDE process exited unexpectedly"
    exit 1
fi
