# ==============================================================================
# Home Manager Configuration (home.nix)
# ==============================================================================
# Description:
#   User-level configuration module for managing dotfiles, application settings,
#   CLI utilities, and home directory symlinks on macOS via nix-darwin and Home Manager.
#
# Reference Documentation & Search:
#   - Configuration Options: https://nix-community.github.io/home-manager/options.xhtml
#   - Package Search:        https://search.nixos.org/packages
# ==============================================================================
{
  config,
  pkgs,
  user,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in {
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    # cli tools
    ripgrep # fast search
    fd # fast find
    fzf # fuzzy finder
    lazygit
    neovim
    nerd-fonts.hack # the font

    # nvim language tooling
    tree-sitter # parser compiler CLI (required by nvim-treesitter main branch)
    lua-language-server # lua LSP
    nixd # nix LSP
    marksman # markdown LSP
    stylua # lua code formatter
    alejandra # nix code formatter
    jq # JSON processor/formatter
    yamlfmt # YAML formatter
    vscode-langservers-extracted #json, html, css, ESLint language language servers
    terraform-ls #terraform formatter
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  # home.nix
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Fast, cached Nix shell evaluation
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true; # ghost text from history
    syntaxHighlighting.enable = true; # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      ".." = "cd ..";
      t = "eza -T -I '.git|node_modules' --icons=never -al";
      dt = "t -D";
      g = "git";
      lg = "lazygit";
      # Type 'fo' to fuzzy find a file with a live eza tree preview on the right side
      fo = "file=$(fd --type f --hidden --strip-cwd-prefix| fzf --preview '[ -d {} ] && eza --tree --color=always --level=4 {} || cat {}') && [ -n \"$file\" ] && nvim \"$file\"";
      # add = "git add .";
      # push = "git push";
      # pull = "git pull";
      # m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true; # Automatically maps ls, ll, lt, etc., in Zsh
    git = true;
    icons = "never";
    extraOptions = [
      "--group-directories-first"
      "--header"
      # "--no-permissions"
      # "--no-user"
      # "--no-time"
      # "--hyperlink"
    ];
  };

  # To handle the fast file filtering in combination with fzf
  programs.fd = {
    enable = true;
    ignores = [
      ".DS_Store"
      "node_modules/"
      ".git/"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # Inject fd as the default engine so .DS_Store and gitignored files are skipped
    # additional options like "--exclude .git --exclude node_modules --exclude .DS_Store" are applied already by fd configuration
    defaultCommand = "fd --type f --strip-cwd-prefix --hidden";

    defaultOptions = [
      "--layout=reverse" # Puts the search bar at the top (matches terminal flow)
      "--border=rounded" # Adds clean, modern borders to panels
      "--margin=3"
      "--height=82%"
      "--info=inline" # Keeps match counters clean and compact

      # Custom color themes mapping to eza's muted blue/green/gray terminal colors
      "--color=18,bg+:-1,fg+:#ffffff,hl:#98c379,hl+:#98c379,pointer:#61afef,prompt:#61afef,marker:#98c379"
    ];
  };

  # https://starship.rs/config/
  # terminal prompt configuration
  programs.starship = {
    enable = true;

    # Using TOML syntax here as NIX format didn't work for the time display
    # Raw string block will force the settings directly into the configuration parser
    settings = fromTOML ''
      add_newline = false

      # 1. Clear out right_format entirely so it doesn't force a trailing lower line
      right_format = ""

      # 2. Inject $fill and $time directly onto row 1 before dropping down
      format = """$directory$git_branch$git_status$cmd_duration$fill$time$line_break$character"""

      [fill]
      symbol = " "

      [character]
      success_symbol = "[❯](purple)"
      error_symbol = "[❯](red)"

      [cmd_duration]
      format = "[$duration]($style) "

      # 3. Explicitly activate and force-toggle the time module parameters
      [time]
      disabled = false
      format = "[$time]($style)"
      style = "dimmed gray"
      time_format = "%I:%M %p"
    '';
  };

  programs.vscode = {
    enable = true;

    # Optional: Prevent VS Code from mutating installed extensions manually.
    # Set to true if you want to allow manual GUI installs alongside Nix.
    mutableExtensionsDir = false;

    # ---------------------------------------------------------------
    # Extensions (Installed directly from nixpkgs)
    # https://search.nixos.org/packages?channel=28.05&query=vscode-extensions
    # ---------------------------------------------------------------
    profiles.default.extensions = with pkgs.vscode-extensions; [
      hashicorp.terraform
      anthropic.claude-code
      eamodio.gitlens
      jnoortheen.nix-ide
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      version = "1";
      git_protocol = "https";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      aliases = {
        co = "pr checkout";
      };
      color_labels = "disabled";
      accessible_colors = "disabled";
      accessible_prompter = "disabled";
      spinner = "enabled";
    };
  };

  programs.awscli = {
    enable = true;
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  # Without symlinks, I'd need to rebuild the environment for configs to be generated
  home.file.".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/stylua.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/.stylua.toml";
  home.file.".config/lazygit/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/lazygit/config.yml";
  home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".claude/claude.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/agents.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/agents.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file."Library/Application Support/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/code/settings.json";
}
