#!/bin/sh
if [ -z "$DGPU_ACTIVE" ]; then
    if lsmod | grep nvidia; then
        export DGPU_ACTIVE=true
    else
        export DGPU_ACTIVE=false
        export __GLX_VENDOR_LIBRARY_NAME=mesa
        export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
        export MESA_LOADER_DRIVER_OVERRIDE=iris
        export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
    fi
fi

