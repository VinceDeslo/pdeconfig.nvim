local codecompanion = require 'codecompanion'

-- https://github.com/olimorris/codecompanion.nvim/
local function setup_codecompanion()
    vim.keymap.set('n', '<leader>ac', "<cmd>CodeCompanionChat<cr>", { desc = 'Open [a]i [c]hat buffer' })
    vim.keymap.set('n', '<leader>ai', "<cmd>CodeCompanion<cr>", { desc = 'Run [a]i prompt [i]nline' })
    vim.keymap.set('n', '<leader>aa', "<cmd>CodeCompanionActions<cr>", { desc = 'Run [a]i [a]ctions' })

    codecompanion.setup {
        opts = {
            log_level = "DEBUG",
        },
        strategies = {
            chat = {
                adapter = "gemini",
            },
            inline = {
                adapter = "gemini",
            },
            cmd = {
                adapter = "gemini",
            },
        },
    }
end

local function init()
    setup_codecompanion()
end

return {
    init = init,
}
