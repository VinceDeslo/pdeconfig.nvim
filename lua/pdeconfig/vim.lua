local function set_vim_g()
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
end

-- https://neovim.io/doc/user/options.html
local function set_vim_o()
    local settings = {
	hlsearch = false,
	mouse = 'a',
        clipboard = 'unnamedplus',
	breakindent = true,
	undofile = true,
	ignorecase = true,
	smartcase = true,
	updatetime = 250,
	timeoutlen = 300,
	completeopt = 'menuone,noselect',
        termguicolors = true,
        expandtab = true,
        tabstop = 4,
        scrolloff = 5,
        shiftwidth = 4,
        splitright = true,
    }

    for k, v in pairs(settings) do
        vim.o[k] = v
    end
end

local function set_vim_wo()
    local settings = {
        foldmethod = 'expr',
        foldexpr = 'nvim_treesitter#foldexpr()',
        foldlevel = 99,
        number = true,
        relativenumber = true,
        wrap = false,
	signcolumn = 'yes'
    }

    for k, v in pairs(settings) do
        vim.wo[k] = v
    end
end

local function set_vim_opt()
    vim.opt.list = true
    vim.opt.listchars:append "eol:↴"
end

local function set_vim_keymaps()
    local options = { noremap = false, silent = true }

    -- Window navigation
    vim.keymap.set('n', '<leader>h', '<CMD>wincmd h<CR>', options)
    vim.keymap.set('n', '<leader>j', '<CMD>wincmd j<CR>', options)
    vim.keymap.set('n', '<leader>k', '<CMD>wincmd k<CR>', options)
    vim.keymap.set('n', '<leader>l', '<CMD>wincmd l<CR>', options)

    -- Diagnostics
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
end

local function set_highight_on_yank()
    local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
    vim.api.nvim_create_autocmd('TextYankPost', {
      callback = function()
        vim.highlight.on_yank()
      end,
      group = highlight_group,
      pattern = '*',
    })
end

local function init()
    set_vim_g()
    set_vim_o()
    set_vim_wo()
    set_vim_opt()
    set_vim_keymaps()
    set_highight_on_yank()
end

return {
    init = init,
}
