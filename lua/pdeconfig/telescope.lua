local telescope = require("telescope")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local helpers = require("pdeconfig.helpers")

-- https://github.com/nvim-telescope/telescope.nvim
local function setup_telescope()
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-u>"] = false,
					["<C-d>"] = false,
				},
			},
		},
		pickers = {
			find_files = {
				hidden = true,
				theme = "dropdown",
			},
		},
	})
end

local function load_telescope_extensions()
	telescope.load_extension("notify")
	telescope.load_extension("fzf")
end

local function grep_git_root()
	local git_root = helpers.find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end

local function set_telescope_keymaps()
	local function current_fuzzy()
		builtin.current_buffer_fuzzy_find(themes.get_dropdown({
			previewer = false,
		}))
	end

	vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
	vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
	vim.keymap.set("n", "<leader>/", current_fuzzy, { desc = "[/] Fuzzily search in current buffer" })
	vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sG", grep_git_root, { desc = "[S]earch by [G]rep on Git Root" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
end

local function init()
	setup_telescope()
	load_telescope_extensions()
	set_telescope_keymaps()
end

return {
	init = init,
}
