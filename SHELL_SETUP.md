# Shell Configuration Guide

This guide explains how to set up shell environments for the Duke SLURM Deep Learning Environment.

## Overview

The Duke SLURM environment supports multiple shells and automatically configures conda for easy use.

## Supported Shells

- **Bash**: Default shell on most Linux systems (auto-switches to zsh)
- **Zsh**: Enhanced shell with better features (recommended for daily use)

## Quick Setup

### For New Users

1. **Clone the repository**:
   ```bash
   git clone git@github.com:MasterZhou1/Duke-Slurm.git
   cd Duke-Slurm
   ```

2. **Run the setup**:
   ```bash
   ./duke-slurm setup
   ```

3. **Activate the environment**:
   ```bash
   ./duke-slurm activate
   ```

### For Existing Users

If you already have the environment set up:

```bash
# Activate conda environment
conda activate torchpy310

# Test your setup
./duke-slurm test
```

## Shell Configuration

### Automatic Setup

The setup script automatically configures your shell for conda:

- **Bash**: Adds conda initialization to `~/.bashrc` (auto-switches to zsh)
- **Zsh**: Adds conda initialization to `~/.zshrc` (recommended shell)

### Manual Setup

If you need to configure your shell manually:

#### Bash
Add to your `~/.bashrc`:
```bash
# Conda initialization
if [[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
fi
```

#### Zsh
Add to your `~/.zshrc`:
```bash
# Conda initialization
if [[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
fi
```



## Using Conda

### Basic Commands

```bash
# Activate environment
conda activate torchpy310

# Deactivate environment
conda deactivate

# List environments
conda env list

# Install packages
conda install package_name
pip install package_name
```

### Environment Management

```bash
# Create new environment
conda create -n myenv python=3.10

# Remove environment
conda env remove -n myenv

# Export environment
conda env export > environment.yml

# Create from file
conda env create -f environment.yml
```

## Testing Your Setup

### Test Conda Installation
```bash
conda --version
```

### Test Environment
```bash
# Activate environment
conda activate torchpy310

# Test Python
python --version

# Test PyTorch
python -c "import torch; print(f'PyTorch {torch.__version__}')"
```

### Test GPU Access
```bash
# Run GPU test
./duke-slurm test

# Or manually
python scripts/utils/test_gpu.py
```

## Troubleshooting

### Conda Not Found

If conda is not available:

1. **Check installation**:
   ```bash
   ls ~/miniconda3/bin/conda
   ```

2. **Reinstall conda**:
   ```bash
   python3 scripts/install_conda.py
   ```

3. **Reload shell**:
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

### Environment Not Found

If the environment doesn't exist:

```bash
# Create environment
python3 scripts/setup_conda.py setup --env torchpy310
```

### Shell-Specific Issues

#### Bash Issues
```bash
# Reload bash configuration
source ~/.bashrc

# Check conda path
echo $PATH | grep conda
```

#### Zsh Issues
```bash
# Reload zsh configuration
source ~/.zshrc

# Check conda path
echo $PATH | grep conda
```



## Best Practices

### Environment Management
- Use separate environments for different projects
- Keep base environment minimal
- Export environments for reproducibility

### Shell Usage
- Choose the shell you're most comfortable with
- Learn basic shell commands for efficiency
- Use aliases for common tasks

### Package Management
- Use conda for system packages
- Use pip for Python-specific packages
- Keep requirements.txt updated

## Common Aliases

The setup includes useful aliases:

```bash
# Conda shortcuts
alias ca='conda activate'
alias cde='conda deactivate'
alias cl='conda env list'

# GPU monitoring
alias gpu='nvidia-smi'
alias gpuwatch='watch -n 1 nvidia-smi'

# SLURM shortcuts
alias queue='squeue -u $USER'
alias gpuqueue='squeue -p compsci-gpu'
```

## Getting Help

### Documentation
- [Conda Documentation](https://docs.conda.io/)
- [Bash Guide](https://www.gnu.org/software/bash/manual/)
- [Zsh Guide](http://zsh.sourceforge.net/Doc/)
- [Fish Guide](https://fishshell.com/docs/current/)

### Support
- Check the troubleshooting section above
- Review error messages carefully
- Contact system administrator for SLURM issues

## Summary

The Duke SLURM environment provides:
- **Easy Setup**: One-command installation
- **Cross-shell Support**: Works with bash and zsh (auto-switch)
- **Auto-configuration**: Automatic conda setup
- **Comprehensive Testing**: Built-in verification tools
- **Good Documentation**: Clear guides and troubleshooting

Start with `./duke-slurm setup` and you'll be ready to go! 