return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = false,
		overrides = function(colors)
			local theme = colors.theme
			return {
				-- Telescope customizations
				TelescopeBorder = { fg = theme.ui.border, bg = theme.ui.bg },
				TelescopeNormal = { bg = theme.ui.bg },
				TelescopePromptBorder = { fg = theme.ui.border, bg = theme.ui.bg_p1 },
				TelescopePromptNormal = { bg = theme.ui.bg_p1 },
			}
		end,
	},
	config = function()
		vim.cmd.colorscheme("kanagawa-wave")

		-- Force Noice styling after colorscheme loads
		local colors = require("kanagawa.colors").setup()
		local theme = colors.theme
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = theme.ui.bg })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = colors.palette.springBlue, bg = theme.ui.bg })
		vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = theme.syn.fun, bg = theme.ui.bg })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePrompt", { fg = theme.ui.fg, bg = theme.ui.bg })
		vim.api.nvim_set_hl(0, "NoiceCmdlineInput", { bg = theme.ui.bg })
	end,
}
