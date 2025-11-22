-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
--
-- Set globals
local function set_vim_g()
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
end
set_vim_g()

-- https://neovim.io/doc/user/options.html
local function set_vim_o()
	local settings = {
		hlsearch = false,
		mouse = "a",
		clipboard = "unnamedplus",
		breakindent = true,
		undofile = true,
		ignorecase = true,
		smartcase = true,
		updatetime = 250,
		timeoutlen = 300,
		completeopt = "menuone,noselect",
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
set_vim_o()

local function set_vim_wo()
	local settings = {
		foldmethod = "expr",
		foldexpr = "nvim_treesitter#foldexpr()",
		foldlevel = 99,
		number = true,
		relativenumber = true,
		wrap = false,
		signcolumn = "yes",
	}

	for k, v in pairs(settings) do
		vim.wo[k] = v
	end
end
set_vim_wo()

local function set_vim_opt()
	vim.opt.list = true
	-- vim.opt.listchars:append "eol:↴"
	vim.opt.listchars:append("eol:~")
end
set_vim_opt()

local function set_vim_keymaps()
	local options = { noremap = false, silent = true }

	-- Window navigation
	vim.keymap.set("n", "<leader>h", "<CMD>wincmd h<CR>", options)
	vim.keymap.set("n", "<leader>j", "<CMD>wincmd j<CR>", options)
	vim.keymap.set("n", "<leader>k", "<CMD>wincmd k<CR>", options)
	vim.keymap.set("n", "<leader>l", "<CMD>wincmd l<CR>", options)

	-- Diagnostics
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
end
set_vim_keymaps()

local function set_highight_on_yank()
	local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.highlight.on_yank()
		end,
		group = highlight_group,
		pattern = "*",
	})
end
set_highight_on_yank()

local function create_format_cmd()
	local desc = "Format current buffer with LSP"
    local function format()
        vim.lsp.buf.format()
    end

	vim.api.nvim_create_user_command("Format", format, { desc = desc })
	vim.keymap.set("n", "<leader>f", format, { desc = desc })
end
create_format_cmd()

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = {
        colorscheme = { "kanagawa-wave" }
    },
	checker = { enabled = true },
})
