#!/bin/bash

# MP4 to GIF Conversion Script
# Converts MP4 files in docs/a_wired/assets/demos to GIF format
# Preserves original MP4 files

echo "🎬 MP4 TO GIF CONVERSION SCRIPT"
echo "==============================="
echo ""

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ FFmpeg is not installed!"
    echo ""
    echo "Please install FFmpeg first:"
    echo "  brew install ffmpeg"
    echo "  or download from: https://ffmpeg.org/download.html"
    exit 1
fi

# Set directory path
DEMO_DIR="/Users/miguelbalagot/Documents/GitHub/campus-workshop/docs/a_wired/assets/demos"

# Check if directory exists
if [ ! -d "$DEMO_DIR" ]; then
    echo "❌ Directory not found: $DEMO_DIR"
    exit 1
fi

# Change to demo directory
cd "$DEMO_DIR"

echo "📁 Working directory: $DEMO_DIR"
echo ""

# List MP4 files
echo "📋 Found MP4 files:"
ls -la *.mp4 2>/dev/null || { echo "No MP4 files found!"; exit 1; }
echo ""

# Enhanced conversion settings for better quality
FPS=15
WIDTH=1200
PALETTE_OPTS="stats_mode=diff"
FILTER_COMPLEX="fps=${FPS},scale=${WIDTH}:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=256:${PALETTE_OPTS}[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"

echo "⚙️  Enhanced conversion settings:"
echo "   Frame rate: ${FPS} fps (increased for smoother motion)"
echo "   Width: ${WIDTH}px (higher resolution)"
echo "   Colors: 256 colors with optimized palette"
echo "   Dithering: Bayer dithering for better gradients"
echo "   Quality: Lanczos scaling + palette optimization"
echo ""

# Convert each MP4 file
echo "🔄 Starting conversions..."
echo ""

# Convert 01_inventory_studio.mp4
if [ -f "01_inventory_studio.mp4" ]; then
    echo "1️⃣ Converting 01_inventory_studio.mp4 (High Quality)..."
    ffmpeg -i 01_inventory_studio.mp4 -filter_complex "${FILTER_COMPLEX}" 01_inventory_studio.gif -y
    if [ $? -eq 0 ]; then
        echo "   ✅ Success: 01_inventory_studio.gif created (Enhanced Quality)"
    else
        echo "   ❌ Failed to convert 01_inventory_studio.mp4"
    fi
    echo ""
fi

# Convert 02_base_config.mp4
if [ -f "02_base_config.mp4" ]; then
    echo "2️⃣ Converting 02_base_config.mp4 (High Quality)..."
    ffmpeg -i 02_base_config.mp4 -filter_complex "${FILTER_COMPLEX}" 02_base_config.gif -y
    if [ $? -eq 0 ]; then
        echo "   ✅ Success: 02_base_config.gif created (Enhanced Quality)"
    else
        echo "   ❌ Failed to convert 02_base_config.mp4"
    fi
    echo ""
fi

# Convert 03_campus_fabric.mp4
if [ -f "03_campus_fabric.mp4" ]; then
    echo "3️⃣ Converting 03_campus_fabric.mp4 (High Quality)..."
    ffmpeg -i 03_campus_fabric.mp4 -filter_complex "${FILTER_COMPLEX}" 03_campus_fabric.gif -y
    if [ $? -eq 0 ]; then
        echo "   ✅ Success: 03_campus_fabric.gif created (Enhanced Quality)"
    else
        echo "   ❌ Failed to convert 03_campus_fabric.mp4"
    fi
    echo ""
fi

echo "✅ CONVERSION COMPLETE!"
echo "======================"
echo ""

# Show final directory contents
echo "📊 Final directory contents:"
ls -la
echo ""

# Show file sizes
echo "📏 File size comparison:"
echo "MP4 files:"
ls -lh *.mp4 2>/dev/null | awk '{print "   " $9 ": " $5}'
echo "GIF files:"
ls -lh *.gif 2>/dev/null | awk '{print "   " $9 ": " $5}'
echo ""

echo "🎉 All conversions completed!"
echo "Original MP4 files preserved."
echo "New GIF files ready for use in markdown!"
