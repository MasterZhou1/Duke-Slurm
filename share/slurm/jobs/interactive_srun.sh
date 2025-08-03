#!/bin/bash
# Interactive GPU Session using srun
# Usage: ./interactive_srun.sh

echo "🐺 Duke SLURM Interactive Session"
echo "Requesting GPU node..."

srun --partition=compsci-gpu \
     --nodes=1 \
     --ntasks-per-node=1 \
     --cpus-per-task=4 \
     --gres=gpu:1 \
     --mem=32G \
     --time=2:00:00 \
     --pty bash 