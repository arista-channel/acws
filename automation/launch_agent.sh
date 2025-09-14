#!/bin/bash

# A01 Lab Automation Agent Launcher
# Quick setup and launch script for the Arista Campus Workshop

echo "🤖 Arista Campus Workshop A01 Lab Automation Agent"
echo "=================================================="

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3.8+ and try again."
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not installed."
    echo "Please install pip3 and try again."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install requirements
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Launch the agent
echo "🚀 Launching A01 Lab Automation Agent..."
echo ""
python a01_lab_agent.py

# Deactivate virtual environment
deactivate

echo ""
echo "✅ Agent session completed!"
echo "Thank you for using the A01 Lab Automation Agent! 🎉"
