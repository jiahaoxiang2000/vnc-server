# VNC Server for Xilinx Vivado on Ubuntu 24.04

## Connection Information
- **Server IP**: 192.168.71.202
- **VNC Display**: :4
- **### To change screen resolution:
Edit the vnc-server.sh script and modify the `-geometry` parameter, then restart:
```bash
./vnc-server.sh restart
```

### To change VNC password:
```bash
vncpasswd
./vnc-server.sh restart
```

### If connection fails:
1. Check if VNC server is running: `./vnc-server.sh status`
2. Check firewall settings: `sudo ufw status`
3. Verify network connectivity to port 5904
4. Ensure the VNC server allows external connections (script now includes `-localhost=0`) 5904
- **Desktop Environment**: XFCE4 (optimized for CAD applications)
- **Current Resolution**: 2560x1440 (2K - recommended for Vivado)
- **Color Depth**: 24-bit

## Overview
This setup includes a VNC server running with XFCE4 desktop environment on Ubuntu 24.04, specifically optimized for running Xilinx Vivado and other CAD applications.

## Current Status
✅ VNC Server configured for XFCE4 desktop environment
✅ Running on display :4 (port 5904)
✅ Optimized for Xilinx Vivado and CAD applications  
✅ 2K resolution (2560x1440) configured - ideal for Vivado GUI
✅ Special environment variables set for CAD tools
✅ Management script with setup automation
✅ TigerVNC server for better performance

## Connection Information
- **Server IP**: 192.168.71.202
- **VNC Display**: :2
- **VNC Port**: 5902
- **Desktop Environment**: Ubuntu Default (GNOME components)
- **Resolution**: 2560x1440 (2K)
- **Color Depth**: 24-bit
- **Resolution**: 2560x1440 (2K)
- **Color Depth**: 24-bit

## How to Connect

### From VNC Viewer
1. Install a VNC viewer on your client machine:
   - **Windows**: TightVNC Viewer, RealVNC Viewer, or UltraVNC
   - **macOS**: Built-in Screen Sharing app or RealVNC Viewer
   - **Linux**: `vncviewer` package

2. Connect using one of these addresses:
   - `192.168.71.202:5904`
   - `192.168.71.202:4`

3. Enter the VNC password when prompted (the one you set during setup)

### From Command Line (Linux/macOS)
```bash
vncviewer 192.168.71.202:4
```

## VNC Server Management

Use the provided management script to control the VNC server:

```bash
# First-time setup: Install XFCE4 desktop environment
./vnc-server.sh setup

# Start VNC server with XFCE4 desktop
./vnc-server.sh start

# Stop VNC server  
./vnc-server.sh stop

# Restart VNC server
./vnc-server.sh restart

# Check server status
./vnc-server.sh status
```

## Setup Instructions for Xilinx Vivado

### 1. Initial Setup
```bash
# Install XFCE4 desktop environment and VNC server
./vnc-server.sh setup

# Start the VNC server
./vnc-server.sh start
```

### 2. Connect to VNC Desktop
Connect using your VNC client to `192.168.71.202:5902` and you'll see the XFCE4 desktop.

### 3. Install Xilinx Vivado
Once connected to the XFCE4 desktop:

#### Option A: Automated Setup (Recommended)
```bash
# Run the automated Vivado setup script
./vivado-setup.sh all
```
This will:
- Install all required packages for Vivado
- Set up optimized environment variables
- Configure XFCE4 for better CAD performance
- Create a desktop launcher for Vivado

#### Option B: Manual Setup
1. Download Vivado installer from Xilinx website
2. Open terminal in XFCE4: Applications → Terminal Emulator
3. Navigate to the installer and run it
4. The Vivado GUI will display properly in the XFCE4 environment

### 4. Post-Installation Steps
After installing Vivado:
1. Edit `~/.vivado_env` to update the Vivado installation path
2. Logout and login to the VNC session to apply changes
3. Use the Vivado desktop launcher or run `vivado` from terminal

### 4. Environment Optimizations
The VNC setup includes these optimizations for Vivado:
- `QT_X11_NO_MITSHM=1` - Fixes Qt rendering issues
- `_JAVA_AWT_WM_NONREPARENTING=1` - Improves Java GUI applications
- XFCE4 provides proper window management for complex CAD GUIs

## Configuration Files
- VNC config directory: `~/.vnc/`
- Startup script: `~/.vnc/xstartup`
- Password file: `~/.vnc/passwd`
- Log files: `~/.vnc/*.log`

## Troubleshooting

### General VNC Issues
#### If connection fails:
1. Check if VNC server is running: `./vnc-server.sh status`
2. Check firewall settings: `sudo ufw status`
3. Verify network connectivity to port 5902

#### To change screen resolution:
Edit the vnc-server.sh script and modify the `-geometry` parameter, then restart:
```bash
./vnc-server.sh restart
```

#### To change VNC password:
```bash
vncpasswd
./vnc-server.sh restart
```

### Vivado-Specific Issues

#### Vivado GUI appears corrupted or doesn't display properly:
1. Ensure environment variables are set:
   ```bash
   source ~/.vivado_env
   echo $QT_X11_NO_MITSHM  # Should output: 1
   ```
2. Restart the VNC session: `./vnc-server.sh restart`
3. Try running Vivado with explicit display: `DISPLAY=:2 vivado`

#### Vivado is slow or unresponsive:
1. Increase VNC resolution to 2K: `./vnc-server.sh restart 2560x1440`
2. Close unnecessary applications in XFCE4
3. Check system resources: `htop` or `top`

#### License issues:
1. Ensure license server is accessible from the VNC session
2. Check firewall settings for license server ports
3. Verify `XILINXD_LICENSE_FILE` environment variable

#### Installation fails:
1. Run the vivado setup script: `./vivado-setup.sh packages`
2. Ensure you have enough disk space (>50GB for full installation)
3. Check that you're running as a user with sudo privileges

## Security Notes
- VNC traffic is not encrypted by default
- The server now accepts external connections for easier access
- Consider using SSH tunneling for secure connections:
  ```bash
  ssh -L 5904:localhost:5904 user@192.168.71.202
  # Then connect VNC client to localhost:5904
  ```
- Or use a VPN for secure remote access
- Ensure firewall is properly configured to limit access to trusted networks

## Default Applications in XFCE4
- **File Manager**: Thunar
- **Terminal**: XFCE4 Terminal
- **Text Editor**: Mousepad / gedit
- **Web Browser**: Firefox
- **Settings**: XFCE4 Settings Manager
- **Panel**: XFCE4 Panel with application menu
- **Window Manager**: Xfwm4 (optimized for CAD applications)

## Why XFCE4 for Vivado?
- **Lightweight**: Lower resource usage compared to GNOME
- **Stable Window Management**: Better handling of complex CAD application windows
- **Customizable**: Easy to configure for optimal Vivado workflow
- **Compatible**: Excellent support for X11 applications like Vivado
- **Performance**: Faster rendering over VNC compared to heavier desktop environments
