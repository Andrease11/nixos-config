local flake = "/etc/nixos"
local hostname = vim.fn.hostname()
local flake_expr = ('(builtins.getFlake "%s")'):format(flake)

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.nil_ls = { enabled = false }
      opts.servers.nixd = {
        mason = false,
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
            },
            nixpkgs = {
              expr = ('import (%s.inputs.nixpkgs) { }'):format(flake_expr),
            },
            options = {
              nixos = {
                expr = ('%s.nixosConfigurations.%q.options'):format(flake_expr, hostname),
              },
              ["home-manager"] = {
                expr = ('%s.nixosConfigurations.%q.options.home-manager.users.type.getSubOptions []'):format(
                  flake_expr,
                  hostname
                ),
              },
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.nix = { "nixfmt" }
    end,
  },
}
