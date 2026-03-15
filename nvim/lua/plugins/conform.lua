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
          command = "/run/current-system/sw/bin/csharpier",
          args = { "--write", "$FILENAME" },
          stdin = false,
        },
      },
    },
  },
}
