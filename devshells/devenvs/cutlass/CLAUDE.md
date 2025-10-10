# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment

This is a NIX-based development environment for NVIDIA CUTLASS, configured using `devenv`. The environment provides a reproducible setup for CUDA development, scientific computing, and GPU performance optimization.

### Environment Setup

```bash
# Activate development environment
devenv shell

# Environment auto-loads via direnv when entering directory
```

### Key Commands

**Build System**:
```bash
# Build CUDA/C++ components
cd cutlass && mkdir -p build && cd build
cmake ..
make -j$(nproc)

# Build Python package
pip install -e .
```

**Testing**:
```bash
# Run Python tests
pytest cutlass/python/test/

# Run C++/CUDA tests
cd cutlass/build && ctest

# Run specific test categories
cmake -DTEST_CATEGORY=python .. && make test
```

**Code Quality**:
```bash
# Format CUDA/C++ code
find cutlass -name "*.cu" -o -name "*.cpp" -o -name "*.cuh" | xargs clang-format -i

# Python linting (if configured)
flake8 cutlass/python/
```

## Architecture

### Multi-Language Structure
- **CUDA** (1030 .cu files): GPU kernel implementations
- **C++** (38 .cpp files): Host-side algorithms and utilities
- **Python** (256 .py files): High-level interface, testing, and user APIs

### Project Layout
```
cutlass/
├── CMakeLists.txt          # Main CMake build configuration
├── python/                # Python package and tests
│   ├── pyproject.toml     # Python build configuration
│   ├── cutlass/          # Python package source
│   └── test/             # Python test suite
├── test/                  # C++/CUDA test suite
│   ├── unit/             # Unit tests
│   ├── examples/         # Example-based tests
│   └── self_contained_includes/ # Header-only tests
├── tools/                # Development utilities
└── docs/                 # Documentation
```

### Build System Architecture
- **Primary**: CMake 3.19+ for CUDA/C++ components
- **Secondary**: setuptools for Python package (`nvidia-cutlass`)
- **Testing**: GoogleTest for C++/CUDA, pytest for Python
- **Dependencies**: Managed by Nix via devenv.yaml/devenv.nix

### CUDA Development
- CUDA 11.8+ required (automatically configured)
- Core tensor operations in `cutlass/include/cutlass/`
- Python integration via `pybind11` wrappers
- Performance optimization focus on GPU memory and computation

### Python Integration
- Package structure: `nvidia-cutlass` v4.2.1.0
- Key modules: `cutlas`, `pycute`, `cutlass_python`
- Scientific computing stack: numpy, scipy, networkx
- Visualization: pydot for dependency graphs

## Development Workflow

### Environment Requirements
- NVIDIA GPU with CUDA support
- Nix package manager
- Python 3.8+ scientific computing stack
- CUDA toolkit 11.8+ (auto-configured)

### Common Development Tasks
1. **Adding new CUDA kernels**: Implement in `cutlass/include/cutlass/`, update CMakeLists.txt
2. **Python API extensions**: Add to `cutlass/python/cutlass/`, update tests
3. **Performance tuning**: Focus on CUDA memory coalescing and thread block optimization
4. **Testing**: Add both C++ unit tests and Python integration tests

### Important Files
- `devenv.yaml`: Primary environment configuration
- `devenv.nix`: Nix derivation specification
- `.envrc`: Direnv integration for automatic loading
- `cutlass/python/pyproject.toml`: Python package configuration
- `cutlass/include/cutlass/version.h`: Version management

### Testing Strategy
- Comprehensive coverage across all modules
- Separate test suites for different abstraction levels
- Python tests verify CUDA integration
- Performance benchmarks in test suite
- CI/CD via GitHub Actions (when configured)