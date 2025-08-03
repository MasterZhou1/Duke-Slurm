#!/usr/bin/env python3
"""
Conda Environment Setup Script
Automatically sets up conda environments for deep learning workloads.
"""

import os
import sys
import subprocess
import argparse
import json
from pathlib import Path


class CondaSetup:
    def __init__(self, config_file="config/environments.json"):
        self.config_file = config_file
        self.config = self.load_config()
        
    def load_config(self):
        """Load environment configuration from JSON file."""
        config_path = Path(__file__).parent.parent / self.config_file
        if config_path.exists():
            with open(config_path, 'r') as f:
                return json.load(f)
        else:
            # Default configuration
            return {
                "environments": {
                    "torchpy310": {
                        "python": "3.10",
                        "packages": {
                            "conda": [
                                "pytorch",
                                "torchvision", 
                                "torchaudio",
                                "pytorch-cuda=11.8",
                                "numpy",
                                "pandas",
                                "matplotlib",
                                "jupyter"
                            ],
                            "pip": [
                                "transformers",
                                "datasets", 
                                "accelerate",
                                "wandb",
                                "tensorboard",
                                "scikit-learn",
                                "seaborn"
                            ]
                        },
                        "channels": ["pytorch", "nvidia", "conda-forge"]
                    },
                    "torchpy311": {
                        "python": "3.11",
                        "packages": {
                            "conda": [
                                "pytorch",
                                "torchvision",
                                "torchaudio", 
                                "pytorch-cuda=11.8",
                                "numpy",
                                "pandas",
                                "matplotlib",
                                "jupyter"
                            ],
                            "pip": [
                                "transformers",
                                "datasets",
                                "accelerate", 
                                "wandb",
                                "tensorboard",
                                "scikit-learn",
                                "seaborn"
                            ]
                        },
                        "channels": ["pytorch", "nvidia", "conda-forge"]
                    }
                }
            }
    
    def run_command(self, command, check=True):
        """Run a shell command and return the result."""
        print(f"Running: {command}")
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        
        if result.stdout:
            print(result.stdout)
        if result.stderr:
            print(result.stderr, file=sys.stderr)
            
        if check and result.returncode != 0:
            raise subprocess.CalledProcessError(result.returncode, command)
            
        return result
    
    def check_conda_installed(self):
        """Check if conda is installed and accessible."""
        try:
            self.run_command("conda --version")
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False
    
    def find_conda_path(self):
        """Find conda installation path."""
        possible_paths = [
            "~/miniconda3/etc/profile.d/conda.sh",
            "~/anaconda3/etc/profile.d/conda.sh",
            "/opt/conda/etc/profile.d/conda.sh",
            "/usr/local/conda/etc/profile.d/conda.sh"
        ]
        
        for path in possible_paths:
            expanded_path = os.path.expanduser(path)
            if os.path.exists(expanded_path):
                return expanded_path
        return None
    
    def setup_environment(self, env_name):
        """Set up a specific conda environment."""
        if env_name not in self.config["environments"]:
            raise ValueError(f"Environment '{env_name}' not found in configuration")
            
        env_config = self.config["environments"][env_name]
        
        print(f"Setting up environment: {env_name}")
        print(f"Python version: {env_config['python']}")
        
        # Create environment
        create_cmd = f"conda create -n {env_name} python={env_config['python']} -y"
        self.run_command(create_cmd)
        
        # Activate environment and install packages
        conda_path = self.find_conda_path()
        if not conda_path:
            raise RuntimeError("Conda not found. Please install conda first.")
        
        # Install conda packages
        if env_config["packages"]["conda"]:
            conda_packages = " ".join(env_config["packages"]["conda"])
            channels = " ".join([f"-c {channel}" for channel in env_config["channels"]])
            conda_install_cmd = f"conda install -n {env_name} {conda_packages} {channels} -y"
            self.run_command(conda_install_cmd)
        
        # Install pip packages
        if env_config["packages"]["pip"]:
            pip_packages = " ".join(env_config["packages"]["pip"])
            pip_install_cmd = f"conda run -n {env_name} pip install {pip_packages}"
            self.run_command(pip_install_cmd)
        
        print(f"Environment '{env_name}' setup complete!")
    
    def list_environments(self):
        """List available environments in configuration."""
        print("Available environments:")
        for env_name, config in self.config["environments"].items():
            print(f"  - {env_name} (Python {config['python']})")
    
    def create_activation_script(self, env_name):
        """Create an activation script for the environment."""
        conda_path = self.find_conda_path()
        if not conda_path:
            raise RuntimeError("Conda not found")
        
        script_content = f"""#!/bin/bash

# Auto-generated activation script for {env_name}
# Generated by setup_conda.py

# Source conda
source {conda_path}

# Activate environment
conda activate {env_name}

echo "Environment '{env_name}' activated!"
echo "Python version: $(python --version)"
echo "PyTorch version: $(python -c 'import torch; print(torch.__version__)' 2>/dev/null || echo 'PyTorch not installed')"
"""
        
        script_path = Path(__file__).parent.parent / f"activate_{env_name}.sh"
        with open(script_path, 'w') as f:
            f.write(script_content)
        
        # Make executable
        os.chmod(script_path, 0o755)
        print(f"Activation script created: {script_path}")


def main():
    parser = argparse.ArgumentParser(description="Setup conda environments for deep learning")
    parser.add_argument("action", choices=["setup", "list", "create-script"], 
                       help="Action to perform")
    parser.add_argument("--env", "-e", default="torchpy310",
                       help="Environment name (default: torchpy310)")
    parser.add_argument("--config", "-c", default="config/environments.json",
                       help="Configuration file path")
    
    args = parser.parse_args()
    
    setup = CondaSetup(args.config)
    
    if not setup.check_conda_installed():
        print("Error: conda is not installed or not in PATH")
        print("Please install conda first: https://docs.conda.io/en/latest/miniconda.html")
        sys.exit(1)
    
    if args.action == "list":
        setup.list_environments()
    elif args.action == "setup":
        try:
            setup.setup_environment(args.env)
            setup.create_activation_script(args.env)
        except Exception as e:
            print(f"Error setting up environment: {e}")
            sys.exit(1)
    elif args.action == "create-script":
        setup.create_activation_script(args.env)


if __name__ == "__main__":
    main() 