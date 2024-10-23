# optimus-vulkan-fix
a startup script I made to add environment variables for vulkan drivers when using Arch linux on a laptop that uses Nvidia optimus and fix issues when running in iGPU only mode

## Specific conditions that required this fix are:
- Laptop with an intel iGPU and nvidia dGPU
- Using KDE Plasma for desktop environment
- Using Wayland as a compositor
- Using Nvidia proprietary drivers
- Enabling iGPU-only mode using [Envy Control](https://github.com/bayasdev/envycontrol) 

### Problem:
- Using [Envy Control](https://github.com/bayasdev/envycontrol) to turn off the dGPU (running in iGPU only mode) can cause issues when nvidia proprietary drivers are installed.
- Symptoms include:
  - Chromium based browers taking 30+ seconds to load (tested and verified this issue with Brave, Chrome, ungoogled-chromium. Firefox does not seem affected by this issue)
  - Electron based applications (VScode, 1password, discord) take a long time to start or open to blank screens and crash shortly after
- I suspect this is due to vulkan based rendering attempting to default to using nvidia drivers which try to wake the dGPU that is no longer available on the PCIE bus since envycontrol removed it.
  - Applications will repeatedly attempt to wake the GPU several times before failing and falling back to an alternative method of loading

### The fix:
- A shell script runs at boot to set environment variables to direct libglvnd and EGL to use Mesa and prevent trying to use the dGPU
  - it also sets vulkan driver files to point to the intel chip
- The script simply uses `lsmod | grep nvidia` to set a `DGPU_ACTIVE` flag 
- then sets environment variables for vulkan and GLX to use the iGPU when the dGPU is not available
- If the dGPU IS AVAILABLE, no environment variables are set by this script and everything should work normally
- This solution is based on a combination of troubleshooting info on the Arch Wiki
    - [Test software GL](https://wiki.archlinux.org/title/NVIDIA/Troubleshooting#Test_software_GL)
    - [NVIDIA vulkan is not working and can not initialize](https://wiki.archlinux.org/title/Vulkan#NVIDIA_-_vulkan_is_not_working_and_can_not_initialize) 

## Installation instructions:
- download git repo
- copy `gpu_check.sh` to the directory `/etc/profile.d`
- after installing, you can set iGPU only mode with envycontrol and retest by opening a chromium browser and see if it loads immediately

## Uninstallation instructions:
- `rm -rf /etc/profile.d`
