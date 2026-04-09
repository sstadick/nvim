vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")
vim.opt.autoindent  = true
vim.opt.expandtab   = true
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.showmatch   = true
vim.opt.number = true
------------------------
-- Languages
------------------------
vim.filetype.add({ extension = { mojo = "mojo" } })
------------------------
-- Keymaps
------------------------
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>co", ":copen<CR>", { silent = true })
vim.keymap.set("n", "<leader>cx", ":cclose<CR>", { silent = true })
------------------------
-- Plugins
------------------------
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/loctvl842/monokai-pro.nvim"
})
require("telescope").setup({})
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files({
    find_command = { "rg", "--files", "--no-config", "--sortr=modified" }
  })
end, { desc = "Find file" })
vim.keymap.set('n', '<leader>fw', function()
    require("telescope.builtin").live_grep({vimgrep_arguments = {
        "rg", "--color=never", "--no-heading", "--with-filename", "--trim",
        "--line-number", "--column", "--smart-case", "--sortr=modified",
    }})
end, { desc = 'Live Grep (Recent First)' })

require("monokai-pro").setup({
  filter = "machine",  -- pro, classic, octagon, machine, ristretto, spectrum
})
vim.cmd("colorscheme monokai-pro")
------------------------
---- LSP Lite
------------------------
local function load_mojo_diagnostics()
  local output = vim.fn.systemlist("pixi run mojo build --diagnostic-format json -I . main.mojo 2>&1")
  local items = {}
  local seen = {}

  for _, line in ipairs(output) do
    local ok, diag = pcall(vim.fn.json_decode, line)
    if ok and diag and diag.kind ~= "note" and diag.diagnostic then
      local item = {
        filename = diag.diagnostic.file,
        lnum     = diag.diagnostic.location.line,
        col      = diag.diagnostic.location.column,
        text     = diag.message,
        type     = diag.kind == "warning" and "W" or "E",
        valid    = 1,
      }
      local key = item.filename .. ":" .. item.lnum .. ":" .. item.col .. ":" .. item.text
      if not seen[key] then
        seen[key] = true
        table.insert(items, item)
      end
    end
  end

  vim.fn.setqflist(items, "r")
end

vim.api.nvim_set_hl(0, "QuickFixLine", { link = "CursorLine", bold = true })
vim.keymap.set("n", "<leader>cc", function()
  local win = vim.api.nvim_get_current_win()
  load_mojo_diagnostics()
  vim.cmd("copen")
  vim.api.nvim_set_current_win(win)
end, { silent = true })
