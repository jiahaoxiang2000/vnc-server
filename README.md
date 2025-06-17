# VNC Server Setup on Ubuntu

## Overview
This setup includes a VNC server running with XFCE desktop environment on Ubuntu.

## Current Status
✅ VNC Server is running on display :2 (port 5902)
✅ XFCE4 desktop environment installed
✅ Management script available

## Connection Information
- **Server IP**: 192.168.71.202
- **VNC Display**: :2
- **VNC Port**: 5902
- **Desktop Environment**: XFCE4

## How to Connect

### From VNC Viewer
1. Install a VNC viewer on your client machine:
   - **Windows**: TightVNC Viewer, RealVNC Viewer, or UltraVNC
   - **macOS**: Built-in Screen Sharing app or RealVNC Viewer
   - **Linux**: `vncviewer` package

2. Connect using one of these addresses:
   - `192.168.71.202:5902`
   - `192.168.71.202:2`

3. Enter the VNC password when prompted (the one you set during setup)

### From Command Line (Linux/macOS)
```bash
vncviewer 192.168.71.202:2
```

## VNC Server Management

Use the provided management script to control the VNC server:

```bash
# Start VNC server
./vnc-server.sh start

# Stop VNC server  
./vnc-server.sh stop

# Restart VNC server
./vnc-server.sh restart

# Check server status
./vnc-server.sh status
```

## Configuration Files
- VNC config directory: `~/.vnc/`
- Startup script: `~/.vnc/xstartup`
- Password file: `~/.vnc/passwd`
- Log files: `~/.vnc/*.log`

## Troubleshooting

### If connection fails:
1. Check if VNC server is running: `./vnc-server.sh status`
2. Check firewall settings: `sudo ufw status`
3. Verify network connectivity to port 5902

### To change screen resolution:
Edit the vnc-server.sh script and modify the `-geometry` parameter, then restart:
```bash
./vnc-server.sh restart
```

### To change VNC password:
```bash
vncpasswd
./vnc-server.sh restart
```

## Security Notes
- VNC traffic is not encrypted by default
- Consider using SSH tunneling for secure connections:
  ```bash
  ssh -L 5902:localhost:5902 user@192.168.71.202
  # Then connect VNC client to localhost:5902
  ```
- Or use a VPN for secure remote access

## Default Applications in XFCE
- **File Manager**: Thunar
- **Terminal**: XFCE Terminal  
- **Text Editor**: Mousepad
- **Image Viewer**: Ristretto
- **Archive Manager**: Xarchiver
