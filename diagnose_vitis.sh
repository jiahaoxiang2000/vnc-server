#!/bin/bash

# Vitis Diagnostic Script
# Checks VNC environment and requirements for Vitis

echo "=== Vitis VNC Environment Diagnostic ==="
echo ""

# Check VNC server
echo "1. VNC Server Status:"
ps aux | grep -v grep | grep Xtigervnc || echo "   ❌ No VNC server running"
if ps aux | grep -v grep | grep Xtigervnc > /dev/null; then
    echo "   ✅ VNC server is running"
    echo "   Display: $(ps aux | grep -v grep | grep Xtigervnc | grep -o ':4')"
fi
echo ""

# Check DISPLAY
echo "2. Display Environment:"
if [ -z "$DISPLAY" ]; then
    echo "   ❌ DISPLAY variable not set"
    echo "   💡 Run: export DISPLAY=:4"
else
    echo "   ✅ DISPLAY is set to: $DISPLAY"
fi
echo ""

# Check X11 connection
echo "3. X11 Connection Test:"
export DISPLAY=:4
if command -v xclock >/dev/null && timeout 5s xclock &>/dev/null &
then
    sleep 1
    pkill xclock 2>/dev/null
    echo "   ✅ X11 GUI applications can run"
else
    echo "   ❌ X11 GUI test failed"
    echo "   💡 Check VNC server and DISPLAY setting"
fi
echo ""

# Check Xilinx installation
echo "4. Xilinx Vitis Installation:"
if [ -f "/home/xjh/xilinx/2025.1/Vitis/settings64.sh" ]; then
    echo "   ✅ Vitis settings64.sh found"
    source /home/xjh/xilinx/2025.1/Vitis/settings64.sh
    
    if [ -f "$XILINX_VITIS/ide/electron-app/lnx64/vitis-ide" ]; then
        echo "   ✅ Vitis IDE executable found"
        echo "   Path: $XILINX_VITIS/ide/electron-app/lnx64/vitis-ide"
    else
        echo "   ❌ Vitis IDE executable not found"
    fi
else
    echo "   ❌ Vitis settings64.sh not found"
fi
echo ""

# Check Vivado (for comparison)
echo "5. Vivado Comparison:"
if [ -f "/home/xjh/xilinx/2025.1/Vivado/bin/vivado" ]; then
    echo "   ✅ Vivado executable found"
    export DISPLAY=:4
    source /home/xjh/xilinx/2025.1/Vivado/settings64.sh
    echo "   Vivado version:"
    timeout 10s vivado -version 2>/dev/null | head -3 | sed 's/^/     /'
else
    echo "   ❌ Vivado executable not found"
fi
echo ""

# Check system requirements
echo "6. System Requirements:"
echo "   OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "   Architecture: $(uname -m)"
echo "   Memory: $(free -h | grep Mem | awk '{print $2}') total"
echo ""

# Check GUI libraries
echo "7. Required Libraries:"
for lib in libgtk-3-0t64 libxss1 libasound2t64; do
    if dpkg -l | grep -q "^ii  $lib "; then
        echo "   ✅ $lib installed"
    else
        echo "   ❌ $lib missing"
    fi
done
echo ""

# Check running processes
echo "8. Current Vitis Processes:"
ps aux | grep -v grep | grep -i vitis || echo "   No Vitis processes running"
echo ""

echo "=== Diagnostic Complete ==="
echo ""
echo "💡 Troubleshooting Tips:"
echo "   1. Ensure VNC server is running: ./vnc-server.sh start"
echo "   2. Connect to VNC: hostname:5904"
echo "   3. Use the custom launcher: ./launch_vitis.sh"
echo "   4. If GPU errors occur, the launcher includes workarounds"
echo ""
