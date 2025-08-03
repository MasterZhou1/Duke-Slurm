#!/bin/bash
# Interactive session setup script
# Run this after connecting to an interactive session

echo "🐺 Duke SLURM Interactive Session"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $SLURM_NODELIST"

# Check GPU
if command -v nvidia-smi >/dev/null 2>&1; then
    echo "GPU: $(nvidia-smi --query-gpu=name --format=csv,noheader,nounits)"
else
    echo "GPU: Not available"
fi

# Activate environment
if [[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
    conda activate torchpy310
    
    echo ""
    echo "Environment info:"
    echo "Python: $(python --version)"
    echo "PyTorch: $(python -c 'import torch; print(torch.__version__)' 2>/dev/null || echo 'Not installed')"
    echo "CUDA: $(python -c 'import torch; print(torch.cuda.is_available())' 2>/dev/null || echo 'Unknown')"
    
    echo ""
    echo "📊 Available commands:"
    echo "  nvidia-smi                    # GPU status"
    echo "  python -c 'import torch; print(torch.cuda.device_count())'  # GPU count"
    echo "  jupyter notebook              # Start notebook"
    echo "  htop                          # System monitor"
    echo "  conda list                    # List packages"
    echo ""
else
    echo "❌ Conda not found. Please run setup first."
fi 