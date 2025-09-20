# FiveM Lazy Starter

I got tired of manually starting XAMPP and FiveM every single time, so I made this.

## What it does
- Checks if your paths are actually configured (no more placeholder errors)
- Starts XAMPP if it's not running
- Waits for MySQL to be ready
- Launches FiveM server with txAdmin
- Actually stops if something's wrong instead of continuing like an idiot

## Setup
Open the .bat file and change these paths to yours:

### Configuration
- **FXSERVER_PATH** - Find your FiveM server folder, copy the full path to FXServer.exe
- **XAMPP_PATH** - Usually already correct if you installed XAMPP in default location
- **TXDATA_DATA** - Pick any folder where you want txAdmin to store its files
- **TXADMIN_PORT** - You can leave this as is, or change to any port you prefer

```bat
FXSERVER_PATH = C:\FiveM\server\FXServer.exe
XAMPP_PATH = C:\xampp\xampp-control.exe
TXDATA_DATA = C:\FiveM\txadmin-data
TXADMIN_PORT = 40120
```

Run the .bat file. Done.

> [!NOTE]
> Windows only. Made for me but you can use it too if you want.
