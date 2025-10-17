{inputs, ...}: let
  name = "feature/tui/ai/claude-code";
in {
  flake.modules = {
    nixos.${name} = {pkgs, ...}: {
      environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.system}; [
        claude-code
      ];
    };
    homeManager.${name} = {...}: {
      home.file.".claude/settings.json".text = ''
        {
          "env": {
            "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
            "DISABLE_ERROR_REPORTING": "1",
            "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1",
            "DISABLE_TELEMETRY": "1",
            "ANTHROPIC_AUTH_TOKEN": "sk-1234",
            "ANTHROPIC_BASE_URL": "http://api.anthropic.rnd.huawei.com",
            "ANTHROPIC_MODEL": "glm-4.5-air",
            "ANTHROPIC_SMALL_FAST_MODEL": "qwen3-coder-30b-a3b-instruct"
          }
        }
      '';

      # home.file.".claude/settings.json".text = ''
      #  {
      # "env": {
      # "ANTHROPIC_BASE_URL": "https://claudecode.dpdns.org/api",
      # "ANTHROPIC_AUTH_TOKEN": "cr_fa9d461c3831422bcaa9d7b8c776f4ad0a46aa6a751a9c8345fc4e72917a677a"
      # }
      # }
      #'';
    };
  };
}
