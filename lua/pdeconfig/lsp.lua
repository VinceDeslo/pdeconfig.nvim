local lspconfig = require 'lspconfig'
local builtin = require 'telescope.builtin'

local function create_format_cmd(buffer)
  local function format()
    vim.lsp.buf.format()
  end
  local desc = 'Format current buffer with LSP'
  vim.api.nvim_buf_create_user_command(buffer, 'Format', format, { desc = desc })
  vim.keymap.set('n', '<leader>f', format, { desc = desc })
end

local function list_workspace()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end

local function on_attach(_, buffer)
  -- Helper to set LSP keymaps
  local function nmap(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = buffer, desc = desc })
  end

  -- Vim LSP keymaps
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', list_workspace, '[W]orkspace [L]ist Folders')

  -- Telescope LSP keymaps
  nmap('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
  nmap('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Custom Commands
  create_format_cmd(buffer)

  vim.lsp.set_log_level("error")
end

local function setup_language_servers()
  local language_servers = {
    bashls = {},
    jsonls = {},
    yamlls = {
        on_attach = function(client, bufnr)
          local path = vim.fn.expand("%:p")
          if path:match("/helm/") then
            client.stop()
          end
        end,
    },
    html = {},
    cssls = {},
    ts_ls = {},
    zls = {},
    docker_ls = {},
    helm_ls = {
        settings = {
            ['helm-ls'] = {
                yamlls = {
                    path = "yaml-language-server",
                }
            }
        }
    },
    terraformls = {},
    diagnosticls = {},
    gopls = {
        settings = {
            gopls = {
                gofumpt = true,
            },
        },
    },
    nil_ls = {
        settings = {
            ['nil'] = {
                formatting = { command = { "alejandra" } },
            },
        }
    },
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                },
                runtime = {
                    version = 'LuaJIT',
                },
                telemetry = {
                    enable = false,
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        }
    },
  }

  for server, server_config in pairs(language_servers) do
      local config = { on_attach = on_attach }

      if server_config then
          for k, v in pairs(server_config) do
              config[k] = v
          end
      end

      lspconfig[server].setup(config)
  end
end

local function init()
    setup_language_servers()
end

return {
  init = init
}
