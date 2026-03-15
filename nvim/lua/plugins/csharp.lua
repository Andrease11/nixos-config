return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = {
          cmd = (function()
            local omnisharp = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll"
            return { "dotnet", omnisharp, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
          end)(),
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("*.sln", "*.csproj", "global.json", "devenv.nix", ".git")(fname)
          end,
          enable_import_completion = true,
          organize_imports_on_format = false,
          enable_roslyn_analyzers = true,
        },
      },
    },
  },
}
