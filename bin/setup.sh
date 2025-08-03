#!/bin/bash

# Main Setup Script for Deep Learning Environment
# This script sets up everything needed for deep learning workloads

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if conda is available
check_conda() {
    if command_exists conda; then
        return 0
    else
        # Check common conda paths
        local conda_paths=(
            "~/miniconda3/etc/profile.d/conda.sh"
            "~/anaconda3/etc/profile.d/conda.sh"
            "/opt/conda/etc/profile.d/conda.sh"
            "/usr/local/conda/etc/profile.d/conda.sh"
        )
        
        for path in "${conda_paths[@]}"; do
            if [[ -f "$path" ]]; then
                source "$path"
                if command_exists conda; then
                    return 0
                fi
            fi
        done
        return 1
    fi
}

# Function to install conda if not available
install_conda() {
    print_status "Checking for conda installation..."
    
    if check_conda; then
        print_success "Conda is already available!"
        return 0
    fi
    
    print_warning "Conda not found. Installing miniconda..."
    
    # Check if Python is available for the installer script
    if ! command_exists python3; then
        print_error "Python 3 is required to install conda. Please install Python 3 first."
        exit 1
    fi
    
    # Run the conda installer script
    if [[ -f "../scripts/install_conda.py" ]]; then
        python3 ../scripts/install_conda.py --type miniconda
    else
        print_error "Conda installer script not found. Please install conda manually."
        print_status "Visit: https://docs.conda.io/en/latest/miniconda.html"
        exit 1
    fi
    
    # Source conda after installation
    if [[ -f "~/miniconda3/etc/profile.d/conda.sh" ]]; then
        source ~/miniconda3/etc/profile.d/conda.sh
    fi
    
    if check_conda; then
        print_success "Conda installed successfully!"
    else
        print_error "Conda installation failed. Please install manually."
        exit 1
    fi
}

# Function to setup conda environment
setup_environment() {
    local env_name=${1:-"torchpy310"}
    
    print_status "Setting up conda environment: $env_name"
    
    if [[ -f "../scripts/setup_conda.py" ]]; then
        python3 ../scripts/setup_conda.py setup --env "$env_name"
    else
        print_error "Conda setup script not found!"
        exit 1
    fi
}

# Function to create activation scripts
create_activation_scripts() {
    print_status "Creating activation scripts..."
    
    # Create main activation script
    cat > activate.sh << 'EOF'
#!/bin/bash

# Main activation script
# This script will activate the default environment

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if specific environment activation script exists
if [[ -f "$SCRIPT_DIR/activate_torchpy310.sh" ]]; then
    source "$SCRIPT_DIR/activate_torchpy310.sh"
elif [[ -f "$SCRIPT_DIR/activate_torchpy311.sh" ]]; then
    source "$SCRIPT_DIR/activate_torchpy311.sh"
else
    echo "No environment activation script found!"
    echo "Please run: python3 scripts/setup_conda.py setup"
    exit 1
fi
EOF

    chmod +x activate.sh
    print_success "Created main activation script: activate.sh"
}

# Function to setup project structure
setup_project_structure() {
    print_status "Setting up project structure..."
    
    # Create necessary directories
    mkdir -p {data,results,logs,models,configs}
    mkdir -p scripts/{training,utils,data_processing}
    mkdir -p slurm/{jobs,templates}
    mkdir -p setup/{templates,scripts}
    
    print_success "Project structure created!"
}

# Function to create useful aliases
create_aliases() {
    print_status "Creating useful aliases..."
    
    # Create aliases file
    cat > aliases.sh << 'EOF'
# Useful aliases for deep learning environment

# Conda shortcuts
alias ca='conda activate'
alias cde='conda deactivate'
alias cel='conda env list'
alias cec='conda env create'
alias ced='conda env remove'

# GPU monitoring
alias gpu='nvidia-smi'
alias gpuw='watch -n 1 nvidia-smi'
alias gpum='nvidia-smi -l 1'

# SLURM shortcuts (if available)
if command -v squeue >/dev/null 2>&1; then
    alias queue='squeue -u $USER'
    alias gpuqueue='squeue -p compsci-gpu'
    alias cancel='scancel'
fi

# Project shortcuts
alias cdproj='cd ~/code/Testing'
alias activate='source ~/code/Testing/activate.sh'

# Python shortcuts
alias py='python3'
alias pip='pip3'
alias jup='jupyter notebook'
alias jlab='jupyter lab'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

echo "Aliases loaded! Use 'source aliases.sh' to load them in new sessions."
EOF

    chmod +x aliases.sh
    print_success "Created aliases file: aliases.sh"
    
    # Source aliases for current session
    source aliases.sh
}

# Function to create a comprehensive README
create_readme() {
    print_status "Creating comprehensive README..."
    
    cat > README_NEW.md << 'EOF'
# Deep Learning Environment Setup

A comprehensive setup for deep learning workloads with automatic conda environment management.

## 🚀 Quick Start

### 1. Initial Setup
```bash
# Clone or download this repository
cd ~/code/Testing

# Run the main setup script
./setup.sh
```

### 2. Activate Environment
```bash
# Activate the default environment
./activate.sh

# Or activate a specific environment
source activate_torchpy310.sh
```

### 3. Verify Installation
```bash
# Check Python and PyTorch
python --version
python -c "import torch; print(f'PyTorch {torch.__version__}')"

# Test GPU access (if available)
python scripts/utils/test_gpu.py
```

## 📁 Project Structure

```
Testing/
├── README.md                    # This file
├── setup.sh                     # Main setup script
├── activate.sh                  # Main activation script
├── aliases.sh                   # Useful aliases
├── config/                      # Configuration files
│   └── environments.json        # Conda environment configs
├── scripts/                     # Python scripts
│   ├── setup_conda.py          # Conda environment setup
│   ├── install_conda.py        # Conda installation
│   ├── training/               # Training scripts
│   ├── utils/                  # Utility scripts
│   └── data_processing/        # Data processing scripts
├── slurm/                       # SLURM job scripts
│   ├── jobs/                   # Job submission scripts
│   └── templates/              # Job templates
├── setup/                       # Setup scripts
│   ├── templates/              # Setup templates
│   └── scripts/                # Additional setup scripts
├── data/                        # Dataset directory
├── results/                     # Output directory
├── logs/                        # Log files
├── models/                      # Saved models
└── configs/                     # Model configurations
```

## 🔧 Environment Management

### Available Environments
- `torchpy310`: PyTorch with Python 3.10 (default)
- `torchpy311`: PyTorch with Python 3.11
- `tensorflow`: TensorFlow environment
- `minimal`: Minimal ML environment

### Setup New Environment
```bash
# List available environments
python3 scripts/setup_conda.py list

# Setup specific environment
python3 scripts/setup_conda.py setup --env torchpy311

# Create activation script for environment
python3 scripts/setup_conda.py create-script --env torchpy311
```

### Install Conda (if needed)
```bash
# Install miniconda
python3 scripts/install_conda.py --type miniconda

# Install anaconda
python3 scripts/install_conda.py --type anaconda
```

## 🖥️ SLURM Integration

### Interactive Session
```bash
# Request interactive GPU session
srun --partition=compsci-gpu --gres=gpu:1 --pty bash

# Activate environment in session
source activate.sh
```

### Batch Job
```bash
# Submit batch job
sbatch slurm/jobs/training_job.sh
```

## 🛠️ Common Commands

### Environment Management
```bash
# Activate environment
conda activate torchpy310

# List environments
conda env list

# Install package
conda install package_name
pip install package_name
```

### GPU Monitoring
```bash
# Check GPU status
nvidia-smi

# Monitor GPU usage
watch -n 1 nvidia-smi

# Check queue (SLURM)
squeue -u $USER
```

### Project Management
```bash
# Load aliases
source aliases.sh

# Quick navigation
cdproj  # Go to project directory
activate  # Activate environment
```

## 📊 GPU Resources

### Duke CS Cluster
- **RTX A6000**: 48GB VRAM
- **RTX A5000**: 24GB VRAM
- **Tesla V100**: 32GB VRAM
- **Tesla P100**: 12GB VRAM

### Request Resources
```bash
# Request specific GPU
srun --partition=compsci-gpu --gres=gpu:rtx_a6000:1 --pty bash

# Request with specific memory
srun --partition=compsci-gpu --gres=gpu:1 --mem=64G --pty bash
```

## 🔍 Troubleshooting

### Common Issues
1. **Conda not found**: Run `python3 scripts/install_conda.py`
2. **Environment not found**: Run `python3 scripts/setup_conda.py setup`
3. **GPU not available**: Check with `squeue -p compsci-gpu`
4. **Out of memory**: Reduce batch size or request more memory

### Useful Commands
```bash
# Check conda installation
conda --version

# Check environment
conda info --envs

# Check GPU
nvidia-smi

# Check SLURM
sinfo -p compsci-gpu
```

## 📚 Additional Resources

- [Conda Documentation](https://docs.conda.io/)
- [PyTorch Documentation](https://pytorch.org/docs/)
- [SLURM Documentation](https://slurm.schedmd.com/)
- [Duke CS Cluster](https://cs.duke.edu/csl/facilities/cluster)

## 🤝 Support

For issues with this setup:
1. Check the troubleshooting section
2. Review the error messages
3. Check the logs in the `logs/` directory
4. Contact system administrator for SLURM issues
EOF

    print_success "Created comprehensive README: README_NEW.md"
}

# Main setup function
main() {
    print_status "Starting deep learning environment setup..."
    
    # Parse command line arguments
    ENV_NAME=${1:-"torchpy310"}
    SKIP_CONDA=${2:-"false"}
    
    print_status "Target environment: $ENV_NAME"
    
    # Install conda if needed
    if [[ "$SKIP_CONDA" != "true" ]]; then
        install_conda
    fi
    
    # Setup project structure
    setup_project_structure
    
    # Setup conda environment
    setup_environment "$ENV_NAME"
    
    # Create activation scripts
    create_activation_scripts
    
    # Create aliases
    create_aliases
    
    # Create comprehensive README
    create_readme
    
    print_success "Setup completed successfully!"
    print_status "Next steps:"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. Activate environment: ./activate.sh"
    echo "3. Load aliases: source aliases.sh"
    echo "4. Test installation: python scripts/utils/test_gpu.py"
}

# Run main function with all arguments
main "$@" 