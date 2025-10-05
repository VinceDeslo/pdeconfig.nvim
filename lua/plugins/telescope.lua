return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local builtin = require("telescope.builtin")

		local function current_fuzzy()
			builtin.current_buffer_fuzzy_find(themes.get_dropdown({
				previewer = false,
			}))
		end

		local function find_git_root()
			-- Use the current buffer's path as the starting point for the git search
			local current_file = vim.api.nvim_buf_get_name(0)
			local current_dir
			local cwd = vim.fn.getcwd()
			-- If the buffer is not associated with a file, return nil
			if current_file == "" then
				current_dir = cwd
			else
				-- Extract the directory from the current file's path
				current_dir = vim.fn.fnamemodify(current_file, ":h")
			end

			-- Find the Git root directory from the current file's path
			local git_root =
				vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
			if vim.v.shell_error ~= 0 then
				print("Not a git repository. Searching on current working directory")
				return cwd
			end
			return git_root
		end

		local function grep_git_root()
			local git_root = find_git_root()
			if git_root then
				require("telescope.builtin").live_grep({
					search_dirs = { git_root },
				})
			end
		end

		local function list_workspace()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
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

		-- Vim LSP keymaps
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[W]orkspace [A]dd Folder" })
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "[W]orkspace [R]emove Folder" })
		vim.keymap.set("n", "<leader>wl", list_workspace, { desc = "[W]orkspace [L]ist Folders" })

		-- Telescope LSP keymaps
		vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
		vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
		vim.keymap.set("n", "gI", builtin.lsp_implementations, { desc = "[G]oto [I]mplementation" })
		vim.keymap.set("n", "<leader>D", builtin.lsp_type_definitions, { desc = "Type [D]efinition" })
		vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
		vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
	end,
}
