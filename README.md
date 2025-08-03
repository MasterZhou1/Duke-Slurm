# Duke SLURM Deep Learning Environment

A minimalist, production-ready environment for deep learning on Duke CS cluster. Built specifically for Duke students and researchers.

## Quick Start

### For New Students (GitHub Guide)

If you're new to GitHub, here's how to get started:

1. **Install Git** (if not already installed):
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install git
   
   # On macOS (with Homebrew)
   brew install git
   ```

2. **Clone the repository** (download to your computer):
   ```bash
   git clone https://github.com/MasterZhou1/Duke-Slurm.git
   cd Duke-Slurm
   ```

3. **Setup the environment**:
   ```bash
   ./duke-slurm setup
   ./duke-slurm activate
   ./duke-slurm test
   ```

### For Experienced Users

```bash
# Clone and setup
git clone git@github.com:MasterZhou1/Duke-Slurm.git
cd Duke-Slurm
./duke-slurm setup
./duke-slurm activate
```

## Duke CS Cluster Resources

Based on [Duke CS Cluster Documentation](https://cs.duke.edu/csl/facilities/cluster):

### GPU Resources
- **16 A6000s** (48GB VRAM, 336 Tensor Cores) - `compsci-cluster-fitz`
- **24 A5000s** (24GB VRAM, 256 Tensor Cores) - `linux[41-44]`
- **10 V100s** (32GB VRAM, 640 Tensor Cores) - `gpu-compute[5-7]`
- **26 P100s** (12GB VRAM) - `linux[41-50]`, `gpu-compute[4-5]`
- **24 K80s** (12GB VRAM) - `gpu-compute[1-3]`
- **30 2080RTXTi** (11GB VRAM) - `linux[41-60]`

### Important Notes
- **Login limits**: 1 CPU, 4GB RAM on login machines
- **Use cluster**: For CPU-intensive jobs
- **No backups**: Copy important data to backed-up filesystems
- **Shared resource**: Minimize network traffic



## Usage

### Environment Management
```bash
# Activate environment
./duke-slurm activate

# Test setup
./duke-slurm test

# Install requirements
./duke-slurm install-requirements
```

### SLURM Jobs

#### Interactive Session
```bash
# Start interactive GPU session
./duke-slurm interactive

# Or manually
./share/slurm/jobs/interactive_srun.sh

# After connecting, run setup
./share/slurm/jobs/interactive_setup.sh

# Or use srun directly
srun --partition=compsci-gpu --gres=gpu:1 --pty bash
```

#### Batch Training
```bash
# Submit training job
sbatch share/slurm/jobs/training_job.sh
```

### Useful Commands
```bash
# Check queue
squeue -u $USER

# Check GPU queue
squeue -p compsci-gpu

# Monitor GPUs
nvidia-smi

# Check cluster status
sinfo -p compsci-gpu
```

## Project Structure

```
Duke-Slurm/
├── duke-slurm            # Main entry point
├── README.md            # This file
├── bin/                 # Executable scripts
│   ├── activate.sh      # Environment activation
│   ├── setup.sh         # Main setup script
│   └── quick_start.sh   # Interactive setup
├── share/slurm/jobs/    # SLURM job templates
│   ├── interactive_srun.sh # Interactive session
│   ├── interactive_setup.sh # Interactive setup
│   └── training_job.sh  # Training job
├── scripts/             # Python utilities
│   ├── install_conda.py # Conda installation
│   └── setup_conda.py   # Environment setup
└── etc/                 # Configuration files
    ├── config/          # Environment configs
    └── requirements.txt # Python packages
```

## Environment

### Default Environment: `torchpy310`
- **Python**: 3.10
- **PyTorch**: 2.7.1+cu118
- **CUDA**: 11.8
- **Key Packages**: transformers, datasets, accelerate, wandb, tensorboard

### Environment
- `torchpy310`: PyTorch with Python 3.10 (default, pre-configured)

## SLURM Configuration

### Partitions
- `compsci-gpu`: GPU nodes (A6000, A5000, V100, P100, K80, 2080RTXTi)
- `compsci`: CPU-only nodes

### Resource Requests
```bash
# GPU job
#SBATCH --partition=compsci-gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --cpus-per-task=4

# CPU job
#SBATCH --partition=compsci
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
```

## Best Practices

### Data Management
- Use `/tmp` for temporary files
- Copy results to backed-up storage
- Minimize I/O on shared filesystems

### Resource Usage
- Request appropriate resources
- Monitor job status with `squeue`
- Use `--time` for job time limits
- Clean up temporary files

### Environment
- Use conda environments for reproducibility
- Pin package versions in requirements.txt
- Test locally before submitting jobs

## Troubleshooting

### Common Issues
1. **Conda not found**: Run `./duke-slurm setup`
2. **GPU not available**: Check `nvidia-smi` and queue status
3. **Job stuck**: Check `squeue` and `sinfo`
4. **Out of memory**: Increase `--mem` in job script

### Getting Help
- [Duke CS Cluster Documentation](https://cs.duke.edu/csl/facilities/cluster)
- [SLURM Documentation](https://slurm.schedmd.com/)
- [Duke CS SLURM FAQ](https://cs.duke.edu/csl/faqs/slurm)

### Acknowledgments
Thanks to [Cursor](https://cursor.sh/) for providing an excellent AI-powered development environment that made this project possible!

## License

MIT License - see LICENSE file for details. 