return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
        csx = { "csharpier" },
      },
      formatters = {
        csharpier = {
          command = "/run/current-system/sw/bin/csharpier-net9",
          args = { "format", "$FILENAME" },
          stdin = false,
        },
      },
    },
  },
}
