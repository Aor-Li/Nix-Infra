{ inputs, ... }:
{
  flake.aor.devShells.triton =
    pkgs:
    let
      pkgs-unfree = import inputs.nixpkgs {
        inherit (pkgs) system;
        config.allowUnfree = true;
      };
    in
    pkgs-unfree.mkShell {
      packages = with pkgs-unfree; [
        # Python environment
        python312
        python312Packages.pip
        python312Packages.virtualenv

        # Triton dependencies
        python312Packages.numpy
        python312Packages.torch
        python312Packages.triton
        python312Packages.ipython
        python312Packages.jupyter

        # Development tools
        git
        gnumake
        gcc

        # CUDA support
        cudatoolkit
        cudaPackages.cudnn
      ];

      shellHook = ''
        echo "🔱 Triton development environment activated"
        echo "Python: $(python --version)"

        # Create and activate virtual environment if needed
        if [ ! -d .venv ]; then
          echo "Creating Python virtual environment..."
          python -m venv .venv
        fi
        source .venv/bin/activate

        # Install additional Python packages if requirements.txt exists
        if [ -f requirements.txt ]; then
          pip install -q -r requirements.txt
        fi
      '';
    };
}
