# Duke SLURM Deep Learning Environment

A minimalist, production-ready environment for deep learning on Duke CS cluster. Built specifically for Duke students and researchers.

## Quick Start

### For New Students (First Time Setup)

Connect using the command:
`ssh netid@login.cs.duke.edu`

When prompted with
`netid@login.cs.duke.edu's password:`,
enter your NetID password.

Next, you'll see
`Duo two-factor login for netid:`
Enter your Duo authentication password here (make sure to refresh your Duo token beforehand).


If you're setting up on a new server for the first time, you'll need to configure SSH keys for GitHub:

1. **Generate SSH Key** (if you don't have one):
   ```bash
   ssh-keygen -t ed25519 -C "your_email@duke.edu"
   # Press Enter to accept default location
   # Enter a passphrase (recommended) or press Enter for no passphrase
   ```

2. **Add SSH Key to SSH Agent**:
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

3. **Copy Public Key to GitHub**:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   # Copy the output and add it to GitHub:
   # 1. Go to https://github.com/settings/keys
   # 2. Click "New SSH key"
   # 3. Paste the key and save
   ```

4. **Test SSH Connection**:
   ```bash
   ssh -T git@github.com
   # You should see: "Hi username! You've successfully authenticated..."
   ```

### Clone and Setup

```bash
# Clone the repository
git clone git@github.com:MasterZhou1/Duke-Slurm.git
cd Duke-Slurm

# Setup environment
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
