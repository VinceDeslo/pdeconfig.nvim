local kanagawa = require("kanagawa")
local kanagawa_colors = require("kanagawa.colors")
local lualine = require("lualine")
local gitsigns = require("gitsigns")
local notify = require("notify")
local noice = require("noice")
local comment = require("Comment")
local indent_blankline = require("ibl")

-- https://github.com/rebelot/kanagawa.nvim
local function set_theme()
	kanagawa.setup({
		transparent = true,
	})
	vim.cmd.colorscheme("kanagawa-wave")
end

-- https://github.com/nvim-lualine/lualine.nvim
local function setup_lualine()
	lualine.setup({
		options = {
			icons_enabled = false,
			theme = "palenight",
			component_separators = "|",
			section_separators = "",
		},
		sections = {
			lualine_a = {
				{
					"filename",
					path = 1,
				},
			},
		},
	})
end

-- https://github.com/lewis6991/gitsigns.nvim
local function setup_gitsigns()
	gitsigns.setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	})
end

-- https://github.com/rcarriga/nvim-notify
local function setup_notify()
	notify.setup({
		render = "wrapped-compact",
		timeout = 2500,
	})
end

-- https://github.com/folke/noice.nvim
local function setup_noice()
	local colors = kanagawa_colors.setup()

	local fg = colors.palette.lotusRed4
	local bg = colors.theme.ui.bg

	-- Set the cmdline colors to fix background
	vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = fg, bg = bg })
	vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = fg, bg = bg })

	noice.setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			inc_rename = false,
			long_message_to_split = true,
			lsp_doc_border = false,
		},
	})
end

-- https://github.com/numToStr/Comment.nvim
local function setup_comment()
	comment.setup({}) -- defaults are solid
end

-- https://github.com/lukas-reineke/indent-blankline.nvim
local function setup_indent_blankline()
	indent_blankline.setup({}) -- defaults are solid
end

local function init()
	set_theme()
	setup_lualine()
	setup_gitsigns()
	setup_notify()
	setup_noice()
	setup_comment()
	setup_indent_blankline()
end

return {
	init = init,
}
