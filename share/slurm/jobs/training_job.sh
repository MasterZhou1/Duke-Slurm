#!/bin/bash
#SBATCH --job-name=training
#SBATCH --partition=compsci-gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --time=4:00:00
#SBATCH --output=logs/training_%j.out
#SBATCH --error=logs/training_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=$USER@duke.edu

# Training Job for Duke CS Cluster
# Based on https://cs.duke.edu/csl/facilities/cluster

echo "🐺 Duke SLURM Training Job"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $SLURM_NODELIST"
echo "GPU: $(nvidia-smi --query-gpu=name --format=csv,noheader,nounits)"

# Activate environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate torchpy310

# Create directories
mkdir -p logs results
cd "$SLURM_SUBMIT_DIR"

# Environment info
echo "Python: $(python --version)"
echo "PyTorch: $(python -c 'import torch; print(torch.__version__)')"
echo "CUDA: $(python -c 'import torch; print(torch.cuda.is_available())')"

# Example training command (customize for your needs)
python -c "
import torch
import time

print('🚀 Starting training...')
if torch.cuda.is_available():
    print(f'GPU: {torch.cuda.get_device_name(0)}')
    print(f'Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.1f} GB')
else:
    print('No GPU available, using CPU')

# Simulate training
for epoch in range(3):
    print(f'Epoch {epoch+1}/3')
    time.sleep(2)

print('✅ Training completed!')
"

echo "Training job completed!" 