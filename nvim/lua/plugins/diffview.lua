local function git_ref(args)
  local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  local output = vim.trim(result.stdout or "")
  return output ~= "" and output or nil
end

local function diff_base()
  return git_ref({ "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}" })
    or git_ref({ "symbolic-ref", "refs/remotes/origin/HEAD" })
    or git_ref({ "rev-parse", "--verify", "origin/main" }) and "origin/main"
    or git_ref({ "rev-parse", "--verify", "origin/master" }) and "origin/master"
    or "HEAD~1"
end

return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gd",
        function()
          vim.cmd("DiffviewOpen " .. diff_base())
        end,
        desc = "Diff vs remote base",
      },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },
}
