{
  description = "GP system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {

          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.nixfmt-rfc-style
            pkgs.act
            pkgs.cosign
            pkgs.diff-so-fancy
            pkgs.fastfetch
            pkgs.git
            pkgs.git-lfs
            pkgs.iperf
            pkgs.mkalias
            pkgs.nil
            pkgs.openssl
            pkgs.opentofu
            pkgs.rclone
            pkgs.ssh-copy-id
            pkgs.starship
          ];

          fonts.packages = [
            pkgs.cascadia-code
            pkgs.jetbrains-mono
            pkgs.nerd-fonts.fira-code
            pkgs.nerd-fonts.jetbrains-mono
          ];

          homebrew = {
            enable = true;
            brews = [
              "fnm"
              "mas"
              "podman"
            ];
            casks = [
              "appcleaner"
              "araxis-merge"
              "docker"
              "ghostty"
              "google-chrome"
              "iina"
              "keka"
              "microsoft-auto-update"
              "microsoft-edge"
              "microsoft-teams"
              "p4v"
              "podman-desktop"
              "postman"
              "tableplus"
              "tower"
              "transmission"
              "visual-studio-code"
              "vlc"
              "zoom"
            ];
            taps = [ ];
            masApps = {
              # Yoink = 457622435;
              "1Password for Safari" = 1569813296;
              "Affinity Designer" = 824171161;
              "Affinity Photo" = 824183456;
              Amphetamine = 937984704;
              "Bitdefender Virus Scanner" = 500154009;
              Craft = 1487937127;
              # Keynote = 409183694;
              # Magnet = 441258766;
              # Microsoft Excel = 462058435;
              # Microsoft Word = 462054704;
              Money = 1185488696;
              Numbers = 409203825;
              Pages = 409201541;
              # Pixelmator Pro = 1289583905;
              # Pixelmator = 407963104;
              Playgrounds = 1496833156;
              Reeder = 1529448980;
              Slack = 803453959;
              # Spark = 1176895641;
              # The Unarchiver = 425424353;
              # Twitter = 1482454543;
              Xcode = 497799835;
            };
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          system.activationScripts.applications.text =
            let
              env = pkgs.buildEnv {
                name = "system-applications";
                paths = config.environment.systemPackages;
                pathsToLink = "/Applications";
              };
            in
            pkgs.lib.mkForce ''
              # Set up applications.
              echo "setting up /Applications..." >&2
              rm -rf /Applications/Nix\ Apps
              mkdir -p /Applications/Nix\ Apps
              find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
              while read -r src; do
                app_name=$(basename "$src")
                echo "copying $src" >&2
                ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
              done
            '';

          system.defaults = {
            dock.autohide = true;
            # dock.persistent-apps = [];

            finder.FXPreferredViewStyle = "clmv";
            loginwindow.GuestEnabled = false;
            NSGlobalDomain.AppleICUForce24HourTime = false;
            # NSGlobalDomain.AppleInterfaceStyle = "Dark"
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "x86_64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              # enableRosetta = true;

              # User owning the Homebrew prefix
              user = "gperdomor";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
        ];
      };

      # Expose the package set, including the overlays, for convenience.
      darwinPackages = self.darwinConfigurations."mbp".pkgs;
    };
}
