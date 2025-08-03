#!/bin/bash

# Quick Start Script
# This script provides a simple way to get started with the deep learning environment

echo "🚀 Deep Learning Environment Quick Start"
echo "========================================"

# Check if we're in the right directory
if [[ ! -f "setup.sh" ]]; then
    echo "❌ Error: Please run this script from the Testing directory"
    echo "   cd ~/code/Testing"
    echo "   ./quick_start.sh"
    exit 1
fi

echo "📋 Available options:"
echo "1. Full setup (install conda + create environment)"
echo "2. Environment only (if conda is already installed)"
echo "3. Test current setup"
echo "4. Interactive GPU session"
echo "5. Exit"
echo ""

read -p "Choose an option (1-5): " choice

case $choice in
    1)
        echo "🔧 Running full setup..."
        ./setup.sh
        ;;
    2)
        echo "🔧 Setting up environment only..."
        ./setup.sh torchpy310 true
        ;;
    3)
        echo "🧪 Testing current setup..."
        if [[ -f "../scripts/utils/test_gpu.py" ]]; then
            python3 ../scripts/utils/test_gpu.py
        else
            echo "❌ Test script not found. Please run full setup first."
        fi
        ;;
    4)
        echo "🖥️  Starting interactive GPU session..."
        if command -v sbatch >/dev/null 2>&1; then
            sbatch ../share/slurm/jobs/interactive.sh
            echo "✅ Interactive session submitted!"
            echo "   Check your job status with: squeue -u \$USER"
        else
            echo "❌ SLURM not available. Please run on a SLURM cluster."
        fi
        ;;
    5)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid option. Please choose 1-5."
        exit 1
        ;;
esac

echo ""
echo "✅ Quick start completed!"
echo ""
echo "📚 Next steps:"
echo "   - Activate environment: ./activate.sh"
echo "   - Load aliases: source aliases.sh"
echo "   - Test GPU: python3 scripts/utils/test_gpu.py"
echo "   - Start training: python3 scripts/training/train.py"
echo ""
echo "📖 For more information, see README_NEW.md" 