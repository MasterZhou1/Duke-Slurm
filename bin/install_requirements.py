#!/usr/bin/env python3
"""
Requirements Installation Script
Installs packages from requirements.txt file.
"""

import os
import sys
import subprocess
import argparse
from pathlib import Path


def install_requirements(requirements_file, python_path=None):
    """Install requirements from file."""
    if not os.path.exists(requirements_file):
        print(f"Error: {requirements_file} not found!")
        return False
    
    if python_path is None:
        # Try to find conda environment
        conda_paths = [
            os.path.expanduser("~/miniconda3/envs/torchpy310/bin/python"),
            os.path.expanduser("~/anaconda3/envs/torchpy310/bin/python"),
            "/opt/conda/envs/torchpy310/bin/python"
        ]
        
        for path in conda_paths:
            expanded_path = os.path.expanduser(path)
            if os.path.exists(expanded_path):
                python_path = expanded_path
                break
        
        if python_path is None:
            python_path = "python3"
    
    print(f"Using Python: {python_path}")
    print(f"Installing from: {requirements_file}")
    
    # Install requirements
    cmd = [python_path, "-m", "pip", "install", "-r", requirements_file]
    
    try:
        result = subprocess.run(cmd, check=True)
        print("✅ Requirements installed successfully!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error installing requirements: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description="Install requirements from requirements.txt")
    parser.add_argument("--requirements", "-r", default="requirements.txt",
                       help="Requirements file path")
    parser.add_argument("--python", "-p", help="Python executable path")
    
    args = parser.parse_args()
    
    success = install_requirements(args.requirements, args.python)
    
    if success:
        print("\n🎉 Installation completed!")
        print("You can now use the environment with:")
        print("  python scripts/utils/test_gpu.py")
    else:
        print("\n❌ Installation failed!")
        sys.exit(1)


if __name__ == "__main__":
    main() 