#!/usr/bin/env python3
"""
Conda Installation Script
Automatically installs conda if not present on the system.
"""

import os
import sys
import subprocess
import platform
import argparse
from pathlib import Path


class CondaInstaller:
    def __init__(self):
        self.system = platform.system().lower()
        self.machine = platform.machine().lower()
        
    def check_conda_installed(self):
        """Check if conda is already installed."""
        try:
            result = subprocess.run(["conda", "--version"], 
                                  capture_output=True, text=True, timeout=10)
            return result.returncode == 0
        except (subprocess.TimeoutExpired, FileNotFoundError):
            return False
    
    def find_conda_path(self):
        """Find existing conda installation."""
        possible_paths = [
            "~/miniconda3/etc/profile.d/conda.sh",
            "~/anaconda3/etc/profile.d/conda.sh",
            "/opt/conda/etc/profile.d/conda.sh",
            "/usr/local/conda/etc/profile.d/conda.sh",
            "/opt/miniconda3/etc/profile.d/conda.sh",
            "/opt/anaconda3/etc/profile.d/conda.sh"
        ]
        
        for path in possible_paths:
            expanded_path = os.path.expanduser(path)
            if os.path.exists(expanded_path):
                return expanded_path
        return None
    
    def get_download_url(self, installer_type="miniconda"):
        """Get the appropriate download URL for conda."""
        base_url = "https://repo.anaconda.com"
        
        if installer_type == "miniconda":
            if self.system == "linux":
                if "x86_64" in self.machine or "amd64" in self.machine:
                    return f"{base_url}/miniconda/Miniconda3-latest-Linux-x86_64.sh"
                elif "aarch64" in self.machine or "arm64" in self.machine:
                    return f"{base_url}/miniconda/Miniconda3-latest-Linux-aarch64.sh"
            elif self.system == "darwin":  # macOS
                if "x86_64" in self.machine:
                    return f"{base_url}/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
                elif "arm64" in self.machine or "aarch64" in self.machine:
                    return f"{base_url}/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
        elif installer_type == "anaconda":
            if self.system == "linux":
                if "x86_64" in self.machine or "amd64" in self.machine:
                    return f"{base_url}/archive/Anaconda3-2023.09-0-Linux-x86_64.sh"
                elif "aarch64" in self.machine or "arm64" in self.machine:
                    return f"{base_url}/archive/Anaconda3-2023.09-0-Linux-aarch64.sh"
            elif self.system == "darwin":
                if "x86_64" in self.machine:
                    return f"{base_url}/archive/Anaconda3-2023.09-0-MacOSX-x86_64.sh"
                elif "arm64" in self.machine or "aarch64" in self.machine:
                    return f"{base_url}/archive/Anaconda3-2023.09-0-MacOSX-arm64.sh"
        
        raise RuntimeError(f"Unsupported system: {self.system} {self.machine}")
    
    def download_installer(self, url, installer_type="miniconda"):
        """Download the conda installer."""
        import urllib.request
        
        installer_name = f"{installer_type}_installer.sh"
        installer_path = Path.home() / installer_name
        
        print(f"Downloading {installer_type} installer...")
        print(f"URL: {url}")
        
        try:
            urllib.request.urlretrieve(url, installer_path)
            print(f"Downloaded to: {installer_path}")
            return installer_path
        except Exception as e:
            print(f"Error downloading installer: {e}")
            return None
    
    def install_conda(self, installer_path, install_dir=None):
        """Install conda from the downloaded installer."""
        if not installer_path.exists():
            raise FileNotFoundError(f"Installer not found: {installer_path}")
        
        if install_dir is None:
            install_dir = Path.home() / "miniconda3"
        
        print(f"Installing conda to: {install_dir}")
        
        # Make installer executable
        os.chmod(installer_path, 0o755)
        
        # Run installer
        install_cmd = f"bash {installer_path} -b -p {install_dir}"
        print(f"Running: {install_cmd}")
        
        try:
            result = subprocess.run(install_cmd, shell=True, check=True)
            print("Conda installation completed successfully!")
            
            # Clean up installer
            installer_path.unlink()
            print(f"Cleaned up installer: {installer_path}")
            
            return install_dir
        except subprocess.CalledProcessError as e:
            print(f"Error during installation: {e}")
            return None
    
    def setup_shell_integration(self, conda_path):
        """Set up shell integration for conda."""
        conda_sh = conda_path / "etc" / "profile.d" / "conda.sh"
        
        if not conda_sh.exists():
            print("Warning: conda.sh not found, shell integration may not work")
            return False
        
        # Add to .bashrc if it exists
        bashrc = Path.home() / ".bashrc"
        if bashrc.exists():
            conda_init_line = f'source "{conda_sh}"'
            
            with open(bashrc, 'r') as f:
                content = f.read()
            
            if conda_init_line not in content:
                with open(bashrc, 'a') as f:
                    f.write(f"\n# Conda initialization\n{conda_init_line}\n")
                print("Added conda initialization to .bashrc")
        
        # Add to .zshrc if it exists
        zshrc = Path.home() / ".zshrc"
        if zshrc.exists():
            conda_init_line = f'source "{conda_sh}"'
            
            with open(zshrc, 'r') as f:
                content = f.read()
            
            if conda_init_line not in content:
                with open(zshrc, 'a') as f:
                    f.write(f"\n# Conda initialization\n{conda_init_line}\n")
                print("Added conda initialization to .zshrc")
        
        return True
    
    def install(self, installer_type="miniconda", install_dir=None):
        """Main installation method."""
        print(f"Checking conda installation...")
        
        if self.check_conda_installed():
            print("Conda is already installed and accessible!")
            return True
        
        existing_path = self.find_conda_path()
        if existing_path:
            print(f"Found existing conda installation: {existing_path}")
            print("You may need to add it to your PATH or source it manually.")
            return True
        
        print(f"Installing {installer_type}...")
        
        try:
            # Get download URL
            url = self.get_download_url(installer_type)
            
            # Download installer
            installer_path = self.download_installer(url, installer_type)
            if not installer_path:
                return False
            
            # Install conda
            conda_path = self.install_conda(installer_path, install_dir)
            if not conda_path:
                return False
            
            # Setup shell integration
            self.setup_shell_integration(conda_path)
            
            print("\n" + "="*50)
            print("Conda installation completed!")
            print("="*50)
            print(f"Installation directory: {conda_path}")
            print(f"Conda script: {conda_path}/etc/profile.d/conda.sh")
            print("\nTo use conda, either:")
            print("1. Restart your terminal")
            print("2. Run: source ~/.bashrc (or ~/.zshrc)")
            print("3. Or manually source: source {conda_path}/etc/profile.d/conda.sh")
            print("\nThen you can run: conda --version")
            
            return True
            
        except Exception as e:
            print(f"Error during installation: {e}")
            return False


def main():
    parser = argparse.ArgumentParser(description="Install conda automatically")
    parser.add_argument("--type", "-t", choices=["miniconda", "anaconda"], 
                       default="miniconda", help="Type of conda to install")
    parser.add_argument("--dir", "-d", help="Installation directory")
    
    args = parser.parse_args()
    
    installer = CondaInstaller()
    success = installer.install(args.type, args.dir)
    
    if success:
        print("\nInstallation successful! You can now use the setup_conda.py script.")
    else:
        print("\nInstallation failed. Please check the error messages above.")
        sys.exit(1)


if __name__ == "__main__":
    main() 