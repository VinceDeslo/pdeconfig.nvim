local codecompanion = require 'codecompanion'

-- https://github.com/olimorris/codecompanion.nvim/
local function setup_codecompanion()
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
