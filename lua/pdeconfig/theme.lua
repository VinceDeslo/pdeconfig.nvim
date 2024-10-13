local kanagawa = require 'kanagawa'
local lualine = require 'lualine'
local gitsigns = require 'gitsigns'
local notify = require 'notify'
local noice = require 'noice'
local comment = require 'comment'

-- https://github.com/rebelot/kanagawa.nvim
local function set_theme()
    kanagawa.setup {
      transparent = true,
    }
    vim.cmd.colorscheme 'kanagawa-wave'
end

-- https://github.com/nvim-lualine/lualine.nvim
local function setup_lualine()
    lualine.setup {
      options = {
        icons_enabled = false,
        theme = 'palenight',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {
          {
            'filename',
            path = 1,
          }
        },
      },
    }
end

-- https://github.com/lewis6991/gitsigns.nvim
local function setup_gitsigns()
  gitsigns.setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }
end

-- https://github.com/rcarriga/nvim-notify
local function setup_notify()
    notify.setup {
        render = "wrapped-compact",
        timeout = 2500,
    }
end

-- https://github.com/folke/noice.nvim
local function setup_noice()
    noice.setup {
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
    }
end

-- https://github.com/numToStr/Comment.nvim
local function setup_comment()
    comment.setup {} -- defaults are solid
end

local function init()
    set_theme()
    setup_lualine()
    setup_gitsigns()
    setup_notify()
    setup_noice()
    setup_comment()
end

return {
    init = init
}
