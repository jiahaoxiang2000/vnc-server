#!/bin/bash

# VNC Server Management Script for Xilinx Vivado & Vitis
# Optimized for CAD applications with XFCE4 desktop environment

# Default resolution - 2K with higher DPI for better scaling
RESOLUTION="1920x1080"
DPI="150"

# Default display number
VNC_DISPLAY=4

# Parse display number if provided as first argument after command
if [[ "$2" =~ ^[0-9]+$ ]]; then
    VNC_DISPLAY="$2"
fi

# Parse resolution if provided as second/third argument
if [ ! -z "$3" ]; then
    RESOLUTION="$3"
fi

case "$1" in
    start)
        echo "Starting VNC server with XFCE4 desktop for Xilinx Vivado & Vitis"
        echo "Display: :$VNC_DISPLAY | Resolution: $RESOLUTION (DPI: $DPI)"
        
        # Ensure XFCE4 xstartup configuration exists
        if [ ! -f ~/.vnc/xstartup ]; then
            echo "Creating XFCE4 xstartup configuration..."
            mkdir -p ~/.vnc
            cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Set display for X applications
export DISPLAY=:$VNC_DISPLAY

# Start D-Bus session
if [ -x /usr/bin/dbus-launch ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Set up environment for CAD tools
export QT_X11_NO_MITSHM=1
export _JAVA_AWT_WM_NONREPARENTING=1

# XFCE4 Desktop Environment - ideal for CAD applications
startxfce4 &

# Keep the session alive
while true; do
    sleep 60
done
EOF
            chmod +x ~/.vnc/xstartup
            echo "XFCE4 xstartup configuration created"
        fi
        
        vncserver :$VNC_DISPLAY -geometry $RESOLUTION -depth 24 -dpi $DPI -localhost=0
        echo "VNC server started on display :$VNC_DISPLAY (port 59${VNC_DISPLAY}) with XFCE4 desktop"
        echo "You can connect using: hostname:59${VNC_DISPLAY} or hostname:$VNC_DISPLAY"
        echo "Optimized for Xilinx Vivado, Vitis HLS, and other CAD applications"
        ;;
    start-multi)
        DISPLAYS="${2:-4,5,6,7,8}"
        RESOLUTION="${3:-$RESOLUTION}"
        echo "Starting multiple VNC servers with XFCE4 desktop for Xilinx Vivado & Vitis"
        echo "Displays: $DISPLAYS | Resolution: $RESOLUTION (DPI: $DPI)"
        
        mkdir -p ~/.vnc
        
        IFS=',' read -ra DISPLAY_ARRAY <<< "$DISPLAYS"
        for display in "${DISPLAY_ARRAY[@]}"; do
            echo "Creating xstartup configuration for display :$display..."
            
            # Create unique xstartup for each display
            cat > ~/.vnc/xstartup-$display << EOF
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Set display for X applications
export DISPLAY=:$display

# Start D-Bus session for this display
if [ -x /usr/bin/dbus-launch ]; then
    eval "\$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Set up environment for CAD tools
export QT_X11_NO_MITSHM=1
export _JAVA_AWT_WM_NONREPARENTING=1

# Set up scaling for better icon visibility
export GDK_SCALE=1.5
export GDK_DPI_SCALE=1.0
export QT_SCALE_FACTOR=1.5

# Create unique session directories
mkdir -p ~/.cache/sessions/display-$display
mkdir -p ~/.config/xfce4/display-$display

# Configure XFCE4 settings for larger icons and better scaling
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml << 'XFWM4EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Default"/>
    <property name="title_font" type="string" value="Sans Bold 12"/>
    <property name="button_layout" type="string" value="O|SHMC"/>
  </property>
</channel>
XFWM4EOF

cat > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml << 'XSETTINGSEOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Adwaita"/>
    <property name="IconThemeName" type="string" value="Adwaita"/>
    <property name="DoubleClickTime" type="int" value="400"/>
    <property name="DoubleClickDistance" type="int" value="5"/>
    <property name="DndDragThreshold" type="int" value="8"/>
    <property name="CursorBlink" type="bool" value="true"/>
    <property name="CursorBlinkTime" type="int" value="1200"/>
    <property name="SoundThemeName" type="string" value="default"/>
    <property name="EnableEventSounds" type="bool" value="false"/>
    <property name="EnableInputFeedbackSounds" type="bool" value="false"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="int" value="150"/>
    <property name="Antialias" type="int" value="1"/>
    <property name="Hinting" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CanChangeAccels" type="bool" value="false"/>
    <property name="ColorPalette" type="string" value="black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90"/>
    <property name="FontName" type="string" value="Sans 11"/>
    <property name="IconSizes" type="string" value="gtk-menu=24,24:gtk-small-toolbar=24,24:gtk-large-toolbar=32,32:gtk-button=24,24"/>
    <property name="KeyThemeName" type="string" value=""/>
    <property name="ToolbarStyle" type="string" value="icons"/>
    <property name="ToolbarIconSize" type="int" value="3"/>
    <property name="IMPreeditStyle" type="string" value="callback"/>
    <property name="IMStatusStyle" type="string" value="callback"/>
    <property name="MenuImages" type="bool" value="true"/>
    <property name="ButtonImages" type="bool" value="true"/>
    <property name="MenuBarAccel" type="string" value="F10"/>
    <property name="CursorThemeName" type="string" value=""/>
    <property name="CursorThemeSize" type="int" value="24"/>
    <property name="IMModule" type="string" value=""/>
  </property>
</channel>
XSETTINGSEOF

# XFCE4 Desktop Environment with unique session
export XFCE4_SESSION=display-$display
startxfce4 &

# Keep the session alive
while true; do
    sleep 60
done
EOF
            chmod +x ~/.vnc/xstartup-$display
            
            echo "Starting VNC server on display :$display..."
            vncserver :$display -geometry $RESOLUTION -depth 24 -dpi $DPI -localhost=0 -xstartup ~/.vnc/xstartup-$display
            if [ $? -eq 0 ]; then
                echo "✓ VNC server started on display :$display (port 59${display})"
            else
                echo "✗ Failed to start VNC server on display :$display"
            fi
            sleep 2
        done
        echo ""
        echo "Multiple VNC servers started with XFCE4 desktop"
        echo "Connection information:"
        for display in "${DISPLAY_ARRAY[@]}"; do
            echo "  Display :$display → hostname:59${display} or hostname:$display"
        done
        echo "Optimized for Xilinx Vivado, Vitis HLS, and other CAD applications"
        ;;
    stop)
        echo "Stopping VNC server on display :$VNC_DISPLAY..."
        vncserver -kill :$VNC_DISPLAY
        echo "VNC server on :$VNC_DISPLAY stopped"
        ;;
    stop-multi)
        DISPLAYS="${2:-4,5,6,7,8}"
        echo "Stopping multiple VNC servers..."
        echo "Displays: $DISPLAYS"
        
        IFS=',' read -ra DISPLAY_ARRAY <<< "$DISPLAYS"
        for display in "${DISPLAY_ARRAY[@]}"; do
            echo "Stopping VNC server on display :$display..."
            vncserver -kill :$display 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "✓ VNC server on display :$display stopped"
            else
                echo "! No VNC server running on display :$display or already stopped"
            fi
        done
        echo "Multiple VNC servers stop operation completed"
        ;;
    restart)
        echo "Restarting VNC server with XFCE4 desktop for Xilinx Vivado"
        echo "Display: :$VNC_DISPLAY | Resolution: $RESOLUTION (DPI: $DPI)"
        vncserver -kill :$VNC_DISPLAY 2>/dev/null
        sleep 2
        vncserver :$VNC_DISPLAY -geometry $RESOLUTION -depth 24 -dpi $DPI -localhost=0
        echo "VNC server restarted on display :$VNC_DISPLAY (port 59${VNC_DISPLAY}) with XFCE4 desktop"
        echo "Optimized for Xilinx Vivado and other CAD applications"
        ;;
    setup)
        echo "Installing XFCE4 desktop environment for Vivado..."
        sudo apt update
        sudo apt install -y xfce4 xfce4-goodies
        sudo apt install -y tigervnc-standalone-server tigervnc-common
        echo "XFCE4 installation completed"
        echo "Run '$0 start [display] [resolution]' to start the VNC server"
        ;;
    status)
        echo "Checking VNC server status..."
        ps aux | grep -v grep | grep Xtigervnc || echo "No VNC server running"
        echo ""
        echo "Listening ports:"
        netstat -tuln | grep 59 || echo "No VNC ports listening"
        echo ""
        echo "VNC sessions:"
        vncserver -list
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|start-multi|stop-multi|status|setup} [display] [resolution]"
        echo ""
        echo "VNC Server Management Script for Xilinx Vivado & Vitis"
        echo "  setup      - Install XFCE4 desktop environment and VNC server"
        echo "  start      - Start VNC server on specified display (default :4) with XFCE4"
        echo "  stop       - Stop VNC server on specified display (default :4)"
        echo "  restart    - Restart VNC server on specified display (default :4)"
        echo "  start-multi- Start multiple VNC servers (default displays: 4,5,6,7,8)"
        echo "  stop-multi - Stop multiple VNC servers (default displays: 4,5,6,7,8)"
        echo "  status     - Check VNC server status"
        echo ""
        echo "Connection Information:"
        echo "  VNC Display: :[display] (default :4)"
        echo "  VNC Port: 59[display] (default 5904)"
        echo "  Connect to: hostname:59[display] or hostname:[display]"
        echo ""
        echo "Optional resolution parameter (default: 1920x1080):"
        echo "  1024x768   - Standard 4:3"
        echo "  1280x720   - HD 720p"
        echo "  1366x768   - Common laptop"
        echo "  1920x1080  - Full HD 1080p"
        echo "  2560x1440  - 2K QHD "
        echo "  3840x2160  - 4K UHD (requires powerful client)"
        echo ""
        echo "Single Display Examples:"
        echo "  $0 start 4 1920x1080"
        echo "  $0 start 5 2560x1440"
        echo "  $0 stop 5"
        echo ""
        echo "Multiple Display Examples:"
        echo "  $0 start-multi                    # Start displays 4,5,6,7,8 with default resolution"
        echo "  $0 start-multi 1,2,3,4,5          # Start displays 1,2,3,4,5 with default resolution"
        echo "  $0 start-multi 4,5,6,7,8 1920x1080 # Start displays 4,5,6,7,8 with 1920x1080"
        echo "  $0 stop-multi                     # Stop displays 4,5,6,7,8"
        echo "  $0 stop-multi 1,2,3,4,5           # Stop displays 1,2,3,4,5"
        echo ""
        echo "For Xilinx Vivado & Vitis setup:"
        echo "1. Run: $0 setup     (install XFCE4 desktop)"
        echo "2. Run: $0 start-multi [displays] [resolution]     (start multiple VNC servers)"
        echo "3. Connect via VNC to any port 59[display] and install Vivado & Vitis in the desktop environment"
        exit 1
        ;;
esac
