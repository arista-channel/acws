#!/usr/bin/env python3
"""
Arista Campus Workshop - Environment Verification Script
This script verifies that the uv virtual environment is properly configured.
"""

import sys
import subprocess
import importlib.util
from pathlib import Path

def check_python_version():
    """Check Python version compatibility."""
    version = sys.version_info
    print(f"🐍 Python Version: {version.major}.{version.minor}.{version.micro}")
    
    if version >= (3, 9):
        print("✅ Python version is compatible (>=3.9)")
        return True
    else:
        print("❌ Python version is too old. Requires Python 3.9+")
        return False

def check_virtual_environment():
    """Check if we're in a virtual environment."""
    venv_path = Path(sys.prefix)
    project_venv = Path.cwd() / ".venv"
    
    print(f"🏠 Python Path: {sys.prefix}")
    
    if str(venv_path) == str(project_venv.resolve()):
        print("✅ Running in project's uv virtual environment")
        return True
    elif hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        print("⚠️  Running in a virtual environment, but not the project's .venv")
        return True
    else:
        print("❌ Not running in a virtual environment")
        return False

def check_required_packages():
    """Check if required packages are installed."""
    required_packages = [
        ('mkdocs', 'MkDocs'),
        ('material', 'MkDocs Material'),
        ('mike', 'Mike (versioning)'),
        ('yaml', 'PyYAML'),
        ('jinja2', 'Jinja2'),
        ('markdown', 'Markdown'),
    ]
    
    print("\n📦 Checking Required Packages:")
    all_good = True
    
    for package, name in required_packages:
        try:
            spec = importlib.util.find_spec(package)
            if spec is not None:
                print(f"✅ {name}")
            else:
                print(f"❌ {name} - Not found")
                all_good = False
        except ImportError:
            print(f"❌ {name} - Import error")
            all_good = False
    
    return all_good

def check_uv_installation():
    """Check if uv is installed and working."""
    try:
        result = subprocess.run(['uv', '--version'], 
                              capture_output=True, text=True, check=True)
        version = result.stdout.strip()
        print(f"⚡ uv Version: {version}")
        print("✅ uv is installed and working")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ uv is not installed or not working")
        return False

def check_project_files():
    """Check if essential project files exist."""
    essential_files = [
        'mkdocs.yml',
        'pyproject.toml',
        'uv.lock',
        'docs/index.md',
        'README.md',
    ]
    
    print("\n📁 Checking Project Files:")
    all_good = True
    
    for file_path in essential_files:
        path = Path(file_path)
        if path.exists():
            print(f"✅ {file_path}")
        else:
            print(f"❌ {file_path} - Missing")
            all_good = False
    
    return all_good

def check_mkdocs_config():
    """Check if MkDocs configuration is valid."""
    try:
        result = subprocess.run(['mkdocs', 'build', '--clean', '--quiet'], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ MkDocs configuration is valid")
            print("✅ Documentation builds successfully")
            return True
        else:
            print("❌ MkDocs build failed:")
            print(result.stderr)
            return False
    except FileNotFoundError:
        print("❌ MkDocs command not found")
        return False

def main():
    """Run all environment checks."""
    print("🚀 Arista Campus Workshop - Environment Verification")
    print("=" * 60)
    
    checks = [
        ("Python Version", check_python_version),
        ("Virtual Environment", check_virtual_environment),
        ("uv Installation", check_uv_installation),
        ("Required Packages", check_required_packages),
        ("Project Files", check_project_files),
        ("MkDocs Configuration", check_mkdocs_config),
    ]
    
    results = []
    
    for check_name, check_func in checks:
        print(f"\n🔍 {check_name}:")
        print("-" * 30)
        result = check_func()
        results.append((check_name, result))
    
    print("\n" + "=" * 60)
    print("📊 SUMMARY:")
    print("=" * 60)
    
    all_passed = True
    for check_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status} {check_name}")
        if not result:
            all_passed = False
    
    print("\n" + "=" * 60)
    if all_passed:
        print("🎉 ALL CHECKS PASSED! Your environment is ready!")
        print("\n💡 Next steps:")
        print("   • Run: mkdocs serve")
        print("   • Open: http://127.0.0.1:8000")
        print("   • Start developing!")
    else:
        print("⚠️  SOME CHECKS FAILED. Please fix the issues above.")
        print("\n💡 Common fixes:")
        print("   • Run: uv sync")
        print("   • Activate venv: source .venv/bin/activate")
        print("   • Check: uv --version")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())
