#!/bin/bash

# Quick Enhanced GIF Conversion Script
# Converts MP4 files to high-quality GIFs with better resolution and color depth

echo "🎬 ENHANCED GIF CONVERSION"
echo "========================="
echo ""

# Set directory path
DEMO_DIR="/Users/miguelbalagot/Documents/GitHub/campus-workshop/docs/a_wired/assets/demos"

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ FFmpeg is not installed!"
    echo ""
    echo "Please install FFmpeg first:"
    echo "  brew install ffmpeg"
    exit 1
fi

# Change to demo directory
cd "$DEMO_DIR"

echo "📁 Working directory: $DEMO_DIR"
echo ""

# Enhanced conversion settings
FPS=15
WIDTH=1200
PALETTE_OPTS="stats_mode=diff"
FILTER_COMPLEX="fps=${FPS},scale=${WIDTH}:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=256:${PALETTE_OPTS}[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"

echo "⚙️  Enhanced settings:"
echo "   📐 Resolution: ${WIDTH}px width (auto height)"
echo "   🎞️  Frame rate: ${FPS} fps"
echo "   🎨 Colors: 256 optimized palette"
echo "   ✨ Dithering: Bayer algorithm"
echo "   🔍 Scaling: Lanczos (highest quality)"
echo ""

# Convert all three files with enhanced quality
echo "🚀 Starting enhanced conversions..."
echo ""

# File 1
if [ -f "01_inventory_studio.mp4" ]; then
    echo "1️⃣ Enhancing 01_inventory_studio.gif..."
    ffmpeg -i 01_inventory_studio.mp4 -filter_complex "${FILTER_COMPLEX}" 01_inventory_studio_hq.gif -y -loglevel warning
    if [ $? -eq 0 ]; then
        mv 01_inventory_studio_hq.gif 01_inventory_studio.gif
        echo "   ✅ Enhanced: 01_inventory_studio.gif"
    else
        echo "   ❌ Failed to enhance 01_inventory_studio.mp4"
    fi
    echo ""
fi

# File 2
if [ -f "02_base_config.mp4" ]; then
    echo "2️⃣ Enhancing 02_base_config.gif..."
    ffmpeg -i 02_base_config.mp4 -filter_complex "${FILTER_COMPLEX}" 02_base_config_hq.gif -y -loglevel warning
    if [ $? -eq 0 ]; then
        mv 02_base_config_hq.gif 02_base_config.gif
        echo "   ✅ Enhanced: 02_base_config.gif"
    else
        echo "   ❌ Failed to enhance 02_base_config.mp4"
    fi
    echo ""
fi

# File 3
if [ -f "03_campus_fabric.mp4" ]; then
    echo "3️⃣ Enhancing 03_campus_fabric.gif..."
    ffmpeg -i 03_campus_fabric.mp4 -filter_complex "${FILTER_COMPLEX}" 03_campus_fabric_hq.gif -y -loglevel warning
    if [ $? -eq 0 ]; then
        mv 03_campus_fabric_hq.gif 03_campus_fabric.gif
        echo "   ✅ Enhanced: 03_campus_fabric.gif"
    else
        echo "   ❌ Failed to enhance 03_campus_fabric.mp4"
    fi
    echo ""
fi

echo "✅ ENHANCEMENT COMPLETE!"
echo "======================="
echo ""

# Show file sizes
echo "📊 Enhanced GIF file sizes:"
ls -lh *.gif 2>/dev/null | awk '{print "   " $9 ": " $5}'
echo ""

echo "🎉 All GIFs enhanced with:"
echo "   • Higher resolution (1200px width)"
echo "   • Smoother motion (15 fps)"
echo "   • Better color depth (256 colors)"
echo "   • Reduced pixelation"
echo "   • Optimized file size"
echo ""
echo "🚀 Ready for testing in your documentation!"
