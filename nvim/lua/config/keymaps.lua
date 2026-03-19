-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: h tps://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
vim.keymap.set("n", "ss", ":w<CR>", { desc = "Save file with ss", silent = true })

vim.keymap.set("n", "rn", function()
  local current_name = vim.fn.expand("<cword>")
  vim.ui.input({ prompt = "Rename in file: ", default = current_name }, function(new_name)
    if not new_name or new_name == "" or new_name == current_name then
      return
    end

    local old_esc = vim.fn.escape(current_name, [[\\/.*$^~[]])
    local new_esc = vim.fn.escape(new_name, [[\\/&]])
    vim.cmd(string.format("%%s/\\<%s\\>/%s/gc", old_esc, new_esc))
  end)
end, { noremap = true, silent = true, desc = "Rename in current file" })

vim.keymap.set("n", "<leader>rn", function()
  local current_name = vim.fn.expand("<cword>")
  vim.ui.input({ prompt = "Rename symbol (LSP): ", default = current_name }, function(new_name)
    if not new_name or new_name == "" or new_name == current_name then
      return
    end

    if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
      vim.notify("No active LSP client in this buffer", vim.log.levels.WARN)
      return
    end

    vim.lsp.buf.rename(new_name)
    vim.defer_fn(function()
      vim.cmd("wa")
    end, 300)
  end)
end, { noremap = true, silent = true, desc = "Rename symbol (workspace)" })
