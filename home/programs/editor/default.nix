{
  config,
  lib,
  inputs,
  ...
}: let
  utils = inputs.nixCats.utils;
in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      enable = true;
      # nixpkgs_version = inputs.nixpkgs;
      # this will add the overlays from ./overlays and also,
      # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      # addOverlays = /* (import ./overlays inputs) ++ */ [
      #
      # ];
      # see the packageDefinitions below.
      # This says which of those to install.
      packageNames = ["neovim"];

      luaPath = ./.;

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = {
        pkgs,
        settings,
        categories,
        extra,
        name,
        mkPlugin,
        ...
      } @ packageDef: {
        # to define and use a new category, simply add a new list to a set here,
        # and later, you will include categoryname = true; in the set you
        # provide when you build the package using this builder function.
        # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

        # lspsAndRuntimeDeps:
        # this section is for dependencies that should be available
        # at RUN TIME for plugins. Will be available to PATH within neovim terminal
        # this includes LSPs
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            lazygit
            fd
            ripgrep
            gcc
            ghostscript
          ];
          lua = with pkgs; [
            lua-language-server
            stylua
          ];
          nix = with pkgs; [
            nixd
            alejandra
          ];
          go = with pkgs; [
            gopls
            delve
            golint
            golangci-lint
            gotools
            go-tools
            go
          ];
          rust = with pkgs; [
            rust-analyzer
            rustfmt
            clippy
            cargo
            rustc
            cargo-watch
            cargo-expand
            cargo-edit
          ];

          # Python development
          python = with pkgs; [
            pyright
            black
            isort
            mypy
            ruff
            jupyter-all
          ];

          # JavaScript/TypeScript
          web = with pkgs; [
            typescript-language-server
            nodePackages.eslint
            nodePackages.prettier
            tailwindcss-language-server
            vscode-langservers-extracted
          ];

          # Haskell
          haskell = with pkgs; [
            haskell-language-server
            ormolu
            hlint
            ghc
            cabal-install
            haskellPackages.fast-tags
            haskellPackages.haskell-debug-adapter
            haskellPackages.ghci-dap
            haskellPackages.hoogle
          ];

          # C/C++
          cpp = with pkgs; [
            clang-tools
            cmake-language-server
            cmake
            gdb
          ];

          # Zig
          zig = with pkgs; [
            zls
            zig
          ];

          # OCaml
          ocaml = with pkgs; [
            ocaml-lsp
            ocamlformat
            dune_3
            ocaml
            opam
          ];

          # Database tools
          database = with pkgs; [
            sqlite
            postgresql
          ];

          # Documentation and writing
          writing = with pkgs; [
            texlive.combined.scheme-full
            ltex-ls
            texlab
            pandoc
          ];
          tidal = with pkgs;
            [
              haskellPackages.tidal
              supercollider-with-plugins
              ghc
              cabal-install
            ]
            ++ (lib.optionals (pkgs ? superdirt) [pkgs.superdirt])
            ++ (lib.optionals (pkgs ? sc3-plugins) [pkgs.sc3-plugins]);
          # Container/DevOps
          devops = with pkgs; [
            docker-compose-language-service
            dockerfile-language-server
            yaml-language-server
            terraform-ls
            helm-ls
          ];
        };

        # This is for plugins that will load at startup without using packadd:
        startupPlugins = {
          general = with pkgs.vimPlugins; [
            # lazy loading isnt required with a config this small
            # but as a demo, we do it anyway.
            lze
            lzextras
            snacks-nvim
            catppuccin-nvim
            dashboard-nvim
            vim-sleuth
            nui-nvim
            plenary-nvim
            nvim-web-devicons
            yazi-nvim
          ];
        };

        # not loaded automatically at startup.
        # use with packadd and an autocommand in config to achieve lazy loading
        optionalPlugins = {
          go = with pkgs.vimPlugins; [
            nvim-dap-go
          ];
          lua = with pkgs.vimPlugins; [
            lazydev-nvim
          ];

          rust = with pkgs.vimPlugins; [
            rustaceanvim
            crates-nvim
          ];

          python = with pkgs.vimPlugins; [
            nvim-dap-python
            molten-nvim
          ];

          web = with pkgs.vimPlugins; [
            nvim-ts-autotag
            emmet-vim
          ];

          haskell = with pkgs.vimPlugins; [
            haskell-tools-nvim
          ];

          languages = with pkgs.vimPlugins; [
            vim-polyglot
          ];

          # Database
          database = with pkgs.vimPlugins; [
            sqlite-lua
            vim-dadbod
            vim-dadbod-ui
            vim-dadbod-completion
          ];

          git = with pkgs.vimPlugins; [
            fugitive
            diffview-nvim
          ];

          # Testing
          testing = with pkgs.vimPlugins; [
            neotest
            neotest-python
            neotest-go
            neotest-rust
          ];

          tidal = with pkgs.vimPlugins;
            [
            ]
            ++ (lib.optionals (pkgs ? vim-tidal) [pkgs.vim-tidal]);

          writing = with pkgs.vimPlugins; [
            render-markdown-nvim
            vimtex
            texpresso-vim
            papis-nvim
          ];

          general = with pkgs.vimPlugins; [
            mini-nvim
            nvim-lspconfig
            nvim-ufo
            leap-nvim
            vim-startuptime
            blink-cmp
            nvim-treesitter.withAllGrammars
            bufferline-nvim
            lualine-nvim
            lualine-lsp-progress
            gitsigns-nvim
            which-key-nvim
            nvim-lint
            conform-nvim
            nvim-dap
            nvim-dap-ui
            nvim-dap-virtual-text
            trouble-nvim
            todo-comments-nvim
            nvim-surround
            comment-nvim
            indent-blankline-nvim
          ];
        };

        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [];
        };

        # environmentVariables:
        # this section is for environmentVariables that should be available
        # at RUN TIME for plugins. Will be available to path within neovim terminal
        environmentVariables = {
        };

        # categories of the function you would have passed to withPackages
        python3.libraries = {
          latex = _: [pkgs.python313Packages.pylatexenc pkgs.python313Packages.pylatex];
        };

        # If you know what these are, you can provide custom ones by category here.
        # If you dont, check this link out:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
        extraWrapperArgs = {
          # test = [
          #   '' --set CATTESTVAR2 "It worked again!"''
          # ];
        };
      };

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        neovim = {
          pkgs,
          name,
          ...
        }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            # unwrappedCfgPath = "/path/to/here";
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = ["vim" "nVim"];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            hosts.python3.enable = true;
            hosts.node.enable = true;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          # and a set of categories that you want
          categories = {
            general = true;
            lua = true;
            nix = true;
            rust = true;
            python = true;
            web = true;
            haskell = true;
            cpp = true;
            zig = false;
            tidal = true;
            ocaml = false;
            go = false;
            database = true;
            writing = true;
            devops = true;
            git = true;
            testing = false;
          };
          # anything else to pass and grab in lua with `nixCats.extra`
          extra = {
            nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';

            colorscheme = {
              translucent = true;
            };
          };
        };
      };
    };
  };
}
