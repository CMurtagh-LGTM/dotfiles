call plug#begin('~/.local/share/nvim/plugged')
" Language server protocol client
Plug 'neovim/nvim-lspconfig'
Plug 'kosayoda/nvim-lightbulb' " Code action
Plug 'ray-x/lsp_signature.nvim' " Signature Highlight

" Autocomplete 
Plug 'ms-jpq/coq_nvim', {'do' : ':COQdeps','branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty'

" Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

" Powerline
Plug 'hoob3rt/lualine.nvim'

" Pretty tabs
Plug 'akinsho/bufferline.nvim'

" Comments
Plug 'b3nj5m1n/kommentary'

" Tag manager
Plug 'ludovicchabant/vim-gutentags'

" Highlight copy
Plug 'machakann/vim-highlightedyank'

" CursorHold time changer
Plug 'antoinemadec/FixCursorHold.nvim'

" Dependency for telescope, git signs, neorg
Plug 'nvim-lua/plenary.nvim'

" Finder 
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Terminal
Plug 'akinsho/toggleterm.nvim'

" Git
Plug 'lewis6991/gitsigns.nvim'
" TODO think about how to integrate git,
" ideas, telescope-github, git fututive, neogit, git-messenger, diffview, lazygit.nvim. gihhub-notifications.nvim

" Undo tree
Plug 'mbbill/undotree'

" Better wildmenu
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

" Intent markers
Plug 'lukas-reineke/indent-blankline.nvim'

" Key shortcut explainer
Plug 'folke/which-key.nvim'

" Auto pairs
Plug 'windwp/nvim-autopairs'

" Neorg
Plug 'vhyrro/neorg'
Plug 'vhyrro/neorg-telescope'

" Tex
Plug 'lervag/vimtex'

" sxhkd highlighting
Plug 'kovetskiy/sxhkd-vim'

" Nord colour theme
Plug 'shaunsingh/nord.nvim'
call plug#end()

" TODO Checkout nvim-dap (with telescope), goto-preview, telescope-lsp-handlers.nvim, nvim-code-action-menu, windline
" telescope-vimwiki + vimwiki, ltex-ls/grammar-gaurd
" checkout later after more development ray-x/navigator.lua

" Theme
colorscheme nord

" Line numbers
set number
" Spelling check
set spelllang=en_gb
set spell
" tab size
set tabstop=4
set shiftwidth=4
set expandtab
" Hide the mode text
set noshowmode
" Use system clipboard
set clipboard=unnamedplus
" Set ruler for code length
set colorcolumn=120
" Allow unsaved hidden buffers
set hidden
" Allow mouse clicks
set mouse=a

" Some easy mappings
nnoremap Y y$
nnoremap <c-z> [s1z=``
inoremap <c-z> <Esc>[s1z=``a
" something is causing q: not to be <nop>
nnoremap q: <nop>
nnoremap Q <nop>

" Coq
autocmd VimEnter * COQnow --shut-up
let g:coq_settings = { "keymap.recommended": v:false, "keymap.jump_to_mark": "<C-a>" }
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

lua << EOF
-- TODO check other modules
require("coq_3p") {
  { src = "vimtex", short_name = "vTEX" },
}
EOF

" Tree sitter, autopairs and lsp
lua <<EOF
local npairs = require("nvim-autopairs") 
local nvim_lsp = require('lspconfig')
local coq = require('coq')

_G.MUtils = {}

-- npairs

npairs.setup({
    check_ts = true,
    map_bs = false,
    disable_filetype = { "TelescopePrompt" , "vim", "rmd" },
})

local Rule = require('nvim-autopairs.rule')
npairs.add_rule(Rule("\\(","\\)","tex"))

-- Decide to do either coq or npairs keybinds

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return npairs.esc('<c-y>')
    else
      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
vim.api.nvim_set_keymap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

-- Tresitter
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
parser_configs.norg = {
    install_info = {
        url = "https://github.com/vhyrro/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}

require'nvim-treesitter.configs'.setup {
    ensure_installed = {"python", "cpp", "latex", "lua", "r", "norg", "java", "gdscript", "godotResource"},
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    autopairs = {
        enable = true,
    },
    refactor = {
        highlight_definitions = { enable = true },
        -- highlight_current_scope = { enable = true }, TODO change to some other ui
        -- Maybe work out if treesitter has better rename/goto_definition
    },
    textobjects = {
        -- TODO look at the other options
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
}

-- lsp

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }
    -- TODO work out incomming-outgoing calls
    -- Code lens?
    --buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>c', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>d', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>n', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    --buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    --buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>l', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)    

    require "lsp_signature".on_attach({
        floating_window = true,
        hint_enable = false,
    })
end

-- C++
local root_pattern = nvim_lsp.util.root_pattern('.git')
local function get_project_dir_lower()
    local filename = vim.fn.getcwd()
    -- Then the directory of the project
    local project_dirname = root_pattern(filename) or nvim_lsp.util.path.dirname(filename)
    -- And finally perform what is essentially a `basename` on this directory
    return string.lower(vim.fn.fnamemodify(nvim_lsp.util.find_git_ancestor(project_dirname), ':t'))
end

-- C++
if (get_project_dir_lower() == "nubots") then
    nvim_lsp.clangd.setup(coq.lsp_ensure_capabilities{
        on_attach = on_attach,
        -- TODO unhardcode
        cmd = {
            "/home/cameron/.config/nvim/docker_start.sh"
        },
    })
else
    nvim_lsp.ccls.setup (coq.lsp_ensure_capabilities{
        on_attach = on_attach,  
        init_options = {
            cache = {
                directory = ".ccls-cache"
            },
            clang = {
                extraArgs = {"-std=c++20"}
            }
        }
    })
end

-- Python
nvim_lsp.jedi_language_server.setup (coq.lsp_ensure_capabilities{
    on_attach = on_attach
})

-- efm Allows for formatters
if (get_project_dir_lower() == "nubots") then
    nvim_lsp.efm.setup (coq.lsp_ensure_capabilities{
        on_attach = on_attach,  
        init_options = {documentFormatting = true},
        filetypes = {"python"},
        settings = {
            languages = {
                python = {
                    {formatCommand = "black --quiet -", formatStdin = true},
                    {formatCommand = "isort --quiet -", formatStdin = true},
                    {lintCommand = "flake8 --stdin-display-name={$INPUT} -", lintStdin = true},
                }
            }
        }
    })
else
    nvim_lsp.efm.setup (coq.lsp_ensure_capabilities{
        on_attach = on_attach,  
        init_options = {documentFormatting = true},
        filetypes = {"python"},
        settings = {
            languages = {
                python = {
                    {formatCommand = "black --quiet -", formatStdin = true},
                    {formatCommand = "isort --quiet -", formatStdin = true},
                    {formatCommand = "doq", formatStdin = true},  
                    {lintCommand = "flake8 --stdin-display-name={$INPUT} -", lintStdin = true},
                    {lintCommand = "mypy --show-column-numbers"},
                }
            }
        }
    })
end

-- R
nvim_lsp.r_language_server.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- Vimscript
nvim_lsp.vimls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- gdscript
nvim_lsp.gdscript.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- LaTeX -- TODO configure formatting
--nvim_lsp.texlab.setup(coq.lsp_ensure_capabilities{
--    on_attach = on_attach,
--})

-- Java :vomit:
nvim_lsp.jdtls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
    cmd = {"jdtls"},
})

-- ltex-ls wait for upstream
EOF

" TODO make toggle able
augroup before_save
    au!
    " autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
augroup END

" Code action lightbulb
let g:cursorhold_updatetime = 500

" TODO make toggle able
"augroup hover
"    au!
"    autocmd CursorHold *.py lua if vim.fn.pumvisible() then vim.lsp.buf.hover() end
"    autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb{sign={enabled=false},virtual_text={enabled=true}}
"augroup END

" bufferline
set termguicolors
lua << EOF
local bufferline = require'bufferline'
bufferline.setup {
  options = {
    numbers = function(opts)
        return string.format('%s', opts.ordinal)
    end,
    show_buffer_close_icons = false,
    show_close_icon =  false,
  }
}

function _G.bdel(num)
    bufferline.buf_exec(
        num,
        function(buf, visible_buffers)
            vim.cmd('bdelete '..buf.id)
        end
    )
end

vim.cmd [[
    command -count Bdel lua _G.bdel(<count>)
]]
EOF

" These commands will navigate through buffers in order regardless of which mode you are using
nnoremap <leader>] :BufferLineCycleNext<CR>
nnoremap <leader>[ :BufferLineCyclePrev<CR>
nnoremap <leader>b <cmd>exe "BufferLineGoToBuffer " . v:count1<cr>
nnoremap <leader>d <cmd>exe "Bdel " . v:count1<cr>

" lualine TODO copy vieb colours for modes
lua << EOF
require('lualine').setup {
    options = {
        theme = 'nord',
        component_separators = "",
        section_separators = "",
    },
    sections = {
        lualine_a = {
            {-- mode
                function()
                    local mode_names = {
                        V = 'VL',
                        [''] = 'VB',
                    }
                    if mode_names[vim.fn.mode()] == nil then
                        return vim.fn.mode()
                    else
                        return mode_names[vim.fn.mode()]
                    end
                end,
                upper = true,
            }
        },
        lualine_b = {'branch'},
        lualine_c = {
            {'filename', path = 1},
            {function() return '%=' end},
            { -- Lsp server name .
                function()
                    local msg = 'No Active Lsp'
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then return msg end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = ' ',
                color = {fg = '#ffffff', gui = 'bold'}
            }
        },
        lualine_x = {{'filetype', colored = false}},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{'filename', file_status = false}},
        lualine_x = {{'filetype', colored = false}},
        lualine_y = {'location'},
        lualine_z = {}
    },
}
EOF

" UndoTree
" Put it on the right
let g:undotree_WindowLayout = 3

" Wilder
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     [
      \       wilder#check({_, x -> empty(x)}),
      \       wilder#history(),
      \     ],
      \     wilder#python_file_finder_pipeline({
      \       'file_command': ['find', '.', '-type', 'f', '-printf', '%P\n'],
      \       'dir_command': ['find', '.', '-type', 'd', '-printf', '%P\n'],
      \       'filters': ['fuzzy_filter', 'difflib_sorter'],
      \     }),
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 1,
      \     }),
      \     wilder#python_search_pipeline({
      \         'pattern': 'fuzzy',
      \     }),
      \   ),
      \ ])
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': [
      \   wilder#pcre2_highlighter(),
      \   wilder#basic_highlighter(),
      \ ],
      \ 'left': [
      \   wilder#popupmenu_devicons(),
      \   wilder#popupmenu_buffer_flags(),
      \ ],
      \ 'right': [
      \   ' ',
      \   wilder#popupmenu_scrollbar(),
      \ ],
      \ }))

" Telescope
" Possible extensions telescope media files, telescope dap
" It'd be cool if undotree
nnoremap <leader>f<space> <cmd>Telescope git_files<cr>
nnoremap <leader>ff <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fT <cmd>Telescope tags<cr>
nnoremap <leader>fm <cmd>lua require'telescope.builtin'.man_pages({sections={"2", "3", "3p", "4", "7"}})<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fi <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>fc <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader>fs <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>fw <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>fD <cmd>Telescope lsp_document_diagnostics<cr>
nnoremap <leader>ft <cmd>Telescope treesitter<cr>
nnoremap <leader>f<leader> <cmd>Telescope builtin<cr>
nnoremap <leader>fp <cmd>Telescope planets<cr>

lua << EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    selection_strategy = "reset",
    use_less = false,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil, 
  }
}
require('telescope').load_extension('fzy_native')
EOF

" Indent Blankline
lua << EOF
require("indent_blankline").setup {
    buftype_exclude = {"terminal"},
    show_current_context = true,
}
EOF

" Toggleterm TODO more advanced config
lua << EOF
require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  open_mapping = [[<leader>t]],
  insert_mappings = false,
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_terminals = true,
  start_in_insert = true,
  direction = 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
}
EOF

" kommentary
lua << EOF
require('kommentary.config').use_extended_mappings()
require('kommentary.config').configure_language("default", {
    prefer_single_line_comments = true,
    use_consistent_indentation = true,
})
EOF

" gutentags
let g:gutentags_project_root = [".enable_tags"]
let g:gutentags_file_list_command = {
    \ 'markers': {
        \ '.git': 'git ls-files',
        \ '.enable_tags' : 'find . -type f',
        \ },
    \ }

" Which Key
set timeoutlen=250
lua << EOF
require("which-key").setup {
    plugins = {
        spelling = {
            enabled = true,
            suggestions = 20
        }
    },
}
-- TODO document mappings
EOF
nnoremap  <cmd>WhichKey<cr>
inoremap  <cmd>WhichKey<cr>

" Git Signs
lua << EOF
-- TODO configure
require('gitsigns').setup()
EOF

" Neorg TODO work out how to use
lua << EOF
require('neorg').setup {
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.keybinds"] = { -- Configure core.keybinds
            config = {
                default_keybinds = true, -- Generate the default keybinds
                neorg_leader = "<Leader>o" -- This is the default if unspecified
            }
        },
        ["core.norg.concealer"] = { -- Allows for use of icons
            config = {
                icons = {
                    todo = {
                        enabled = true, -- Conceal todo items

                        done = {
                            enabled = true, -- Conceal whenever an item is marked as done
                            icon = ""
                        },
                        pending = {
                            enabled = true, -- Conceal whenever an item is marked as pending
                            icon = ""
                        },
                        undone = {
                            enabled = true, -- Conceal whenever an item is marked as undone
                            icon = "×"
                        }
                    },
                },
            },
        },
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    my_workspace = "~/Documents/neorg"
                },
                -- Automatically detect whenever we have entered a subdirectory of a workspace
                autodetect = true,
            }
        }
    },
}
EOF

"Latex
let g:vimtex_view_general_viewer = 'zathura'

" R
" TODO help command?
augroup R_commands
    au!
    autocmd FileType rmd map <Leader>ll :let file_name=expand('%:r')<enter> :!echo<space>"require(rmarkdown);<space>render('<c-r>%', output_file = '<c-r>=file_name<enter>.pdf')"<space>\|<space>R<space>--vanilla<enter>
augroup END
