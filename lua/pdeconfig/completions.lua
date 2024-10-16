local cmp = require 'cmp'
local cmp_lsp = require 'cmp_nvim_lsp'
local luasnip = require 'luasnip'
local loaders = require 'luasnip.loaders.from_vscode'

local function handle_tab(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local function handle_shift_tab(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.locally_jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/saadparwaiz1/cmp_luasnip
-- https://github.com/hrsh7th/cmp-nvim-lsp
-- https://github.com/rafamadriz/friendly-snippets
local function setup_cmp()
  loaders.lazy_load()
  luasnip.config.setup {}

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete {},
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(handle_tab, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(handle_shift_tab, { 'i', 's' }),
    },
  }

  -- Broadcast completion capabilities to LSP servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local function init()
  setup_cmp()
end

return {
  init = init,
}
