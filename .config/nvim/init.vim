call plug#begin('~/.local/share/nvim/plugged')
" Language server protocol client
Plug 'neovim/nvim-lspconfig'
Plug 'kosayoda/nvim-lightbulb' " Code action
Plug 'ray-x/lsp_signature.nvim' " Signature Highlight
Plug 'brymer-meneses/grammar-guard.nvim' " Grammar in markdown

" Autocomplete 
Plug 'ms-jpq/coq_nvim', {'do' : ':COQdeps','branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

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
Plug 'numToStr/Comment.nvim'

" Tag manager
Plug 'ludovicchabant/vim-gutentags'

" CursorHold time changer
Plug 'antoinemadec/FixCursorHold.nvim'

" Dependency for telescope, git signs, yode, spectre
Plug 'nvim-lua/plenary.nvim'

" Finder 
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-bibtex.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'rudism/telescope-dict.nvim' 

" Comment generator
Plug 'danymat/neogen'

" Terminal
Plug 'akinsho/toggleterm.nvim'

" Git
Plug 'lewis6991/gitsigns.nvim'

" Undo tree
Plug 'mbbill/undotree'

" Better wildmenu
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

" Intent markers
Plug 'lukas-reineke/indent-blankline.nvim'

" Keymap explainer
Plug 'folke/which-key.nvim'

" Auto pairs
Plug 'windwp/nvim-autopairs'

" Virtual text on search, required by scrollbar
Plug 'kevinhwang91/nvim-hlslens'

" Scrollbar
Plug 'petertriho/nvim-scrollbar'

" Floating text windows
Plug 'hoschi/yode-nvim'

" Startup Screen
Plug 'goolord/alpha-nvim'

" Search and replace in workspace
Plug 'windwp/nvim-spectre'

" Virtual text on close brackets
Plug 'haringsrob/nvim_context_vt'

" See lsp progress
Plug 'j-hui/fidget.nvim'

" Display colours
Plug 'norcalli/nvim-colorizer.lua'

" Tex
Plug 'lervag/vimtex'

" sxhkd highlighting
Plug 'kovetskiy/sxhkd-vim'

" eww yuck highlighting
Plug 'elkowar/yuck.vim'

" Nord colour theme
Plug 'shaunsingh/nord.nvim'
call plug#end()

" TODO Checkout nvim-dap (with telescope and coq_3p), goto-preview, telescope-lsp-handlers.nvim, nvim-code-action-menu,
" windline or heirline or feline, telescope-vimwiki + vimwiki, beauwilliams/focus.nvim
" checkout later after more development ray-x/navigator.lua

" For when move to lua shift-d/mappy.nvim, Olical/aniseed, https://github.com/nanotee/nvim-lua-guide

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
" Use smartcase in searching
set smartcase

" Some easy mappings
nnoremap Y y$
nnoremap <c-z> [s1z=``
inoremap <c-z> <Esc>[s1z=``a
" something is causing q: not to be <nop>
nnoremap q: <nop>
nnoremap Q <nop>

" Highlight yank
augroup highlight_yank
autocmd!
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=500, on_visual=true}
augroup END

" Which Key
set timeoutlen=250
lua << EOF
require("which-key").setup{
    plugins = {
        spelling = {
            enabled = true,
            suggestions = 20,
        },
    },
}
-- TODO document mappings
require("which-key").register({
    ["<leader>"] = {
    },
})
EOF
nnoremap  <cmd>WhichKey<cr>
inoremap  <cmd>WhichKey<cr>

" Git Signs
lua << EOF
require('gitsigns').setup{
    signcolumn = false,
    numhl = true,
    on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', '<leader>}', '<cmd>Gitsigns next_hunk<CR>')
        map('n', '<leader>{', '<cmd>Gitsigns prev_hunk<CR>')

        -- Actions
        map('n', '<leader>Gs', '<cmd>Gitsigns stage_hunk<CR>')
        map('v', '<leader>Gs', '<cmd>Gitsigns stage_hunk<CR>')
        map('n', '<leader>Gr', '<cmd>Gitsigns reset_hunk<CR>')
        map('v', '<leader>Gr', '<cmd>Gitsigns reset_hunk<CR>')
        map('n', '<leader>GS', '<cmd>Gitsigns stage_buffer<CR>')
        map('n', '<leader>Gu', '<cmd>Gitsigns undo_stage_hunk<CR>')
        map('n', '<leader>GR', '<cmd>Gitsigns reset_buffer<CR>')
        map('n', '<leader>Gp', '<cmd>Gitsigns preview_hunk<CR>')
        map('n', '<leader>Gd', '<cmd>Gitsigns diffthis<CR>')
        map('n', '<leader>GD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
        map('n', '<leader>Gt', '<cmd>Gitsigns toggle_deleted<CR>')
    end
}
EOF

" Coq
let g:coq_settings = { "keymap.recommended": v:false, "keymap.jump_to_mark": "", "auto_start": "shut-up" }
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
inoremap <C-H> <cmd>lua if require("neogen").jumpable() then require("neogen").jump_next() else COQ.Nav_mark() end<cr>
nnoremap <C-H> <cmd>lua if require("neogen").jumpable() then require("neogen").jump_next() else COQ.Nav_mark() end<cr>

lua << EOF
-- TODO check other modules
require("coq_3p") {
    { src = "nvimlua", short_name = "nLUA", conf_only = true },
    { src = "vimtex", short_name = "vTEX" },
    { src = "bc", short_name = "MATH", precision = 6 },
}
EOF

" Tree sitter, autopairs and lsp
lua << EOF
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
    ensure_installed = {"python", "cpp", "latex", "lua", "r", "vim", "java", "gdscript", "godot_resource", "markdown"},
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
        -- highlight_current_scope = { enable = true }, -- TODO change to some other ui
        -- Maybe work out if treesitter has better rename/goto_definition
    },
    textobjects = {
        -- TODO look at the other options
        -- swap = {
        --     enable = true,
        --     swap_next = {
        --         ["<leader>a"] = "@parameter.inner",
        --     },
        --     swap_previous = {
        --         ["<leader>A"] = "@parameter.inner",
        --     },
        -- },
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
    buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader><leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
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
        max_height = 3,
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
                    {lintCommand = "flake8 --max-line-length 120 --stdin-display-name={$INPUT} -", lintStdin = true},
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
                    {lintCommand = "flake8 --max-line-length 120 --stdin-display-name={$INPUT} -", lintStdin = true},
                    {lintCommand = "mypy --show-column-numbers"},
                }
            }
        }
    })
end

-- R
-- TODO work out why its not working for rmd
nvim_lsp.r_language_server.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- Grammar
require("grammar-guard").init()
nvim_lsp.grammar_guard.setup(coq.lsp_ensure_capabilities{
  cmd = { '/usr/bin/ltex-ls' }, -- add this if you install ltex-ls yourself
	settings = {
		ltex = {
            enabled = {'bibtex', 'html', 'latex', 'markdown', 'org', 'restructuredtext', 'rsweave', 'rmd'},
			language = "en",
			dictionary = {},
			disabledRules = {},
			hiddenFalsePositives = {},
		},
	},
})

-- Vimscript
nvim_lsp.vimls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- gdscript
nvim_lsp.gdscript.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- Java :vomit:
nvim_lsp.jdtls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
    cmd = {"jdtls"},
})

EOF

" TODO make toggle able
" augroup before_save
    " au!
    " autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
" augroup END

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
nnoremap <leader>u <cmd>UndotreeToggle<cr>

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
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>

nnoremap <leader>flr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fli <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>fld <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>flc <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader>fls <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>flw <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>flp <cmd>Telescope diagnostics<cr>

nnoremap <leader>fB <cmd>Telescope bibtex cite<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>lua require'telescope.builtin'.man_pages({sections={"2", "3", "3p", "4", "7"}})<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>

nnoremap <leader>fT <cmd>Telescope tags<cr>
nnoremap <leader>ft <cmd>Telescope treesitter<cr>

nnoremap <leader>f<leader> <cmd>Telescope builtin<cr>
nnoremap <leader>fp <cmd>Telescope planets<cr>

nnoremap <leader>fg <cmd>Telescope git_status<cr>
nnoremap <leader>fGi <cmd>Telescope gh issues<cr>
nnoremap <leader>fGp <cmd>Telescope gh pull_request<cr>
nnoremap <leader>fGg <cmd>Telescope gh gist<cr>
nnoremap <leader>fGr <cmd>Telescope gh run<cr>

" TODO make dictionary searchable as well as synonyms
nnoremap <leader>fz <cmd>lua require('telescope').extensions.dict.synonyms()<cr>

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
    prompt_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    use_less = false,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil, 
  }
}
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('bibtex')
require('telescope').load_extension('file_browser')
require('telescope').load_extension('gh')
EOF

" Neogen
lua << EOF
require('neogen').setup()
require("which-key").register({
    ["<leader>"] = {
        a = {"<cmd>Neogen<cr>", "Generate annotation"}
    },
})
EOF

" Indent Blankline
lua << EOF
require("indent_blankline").setup {
    buftype_exclude = {"terminal", "nofile"},
    show_current_context = true,
}
EOF

lua << EOF
require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  open_mapping = [[<leader>t]],
  insert_mappings = true,
  hide_numbers = true, -- hide the number column in toggleterm buffers
  start_in_insert = true,
  shade_terminals = false,
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
}

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
end
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
EOF

augroup toggleterm
    au!
    au TermOpen * setlocal nospell
augroup end

" Comment
lua << EOF
require('Comment').setup{
    ignore = "^$",
    toggler = {
        line = "<leader>cc",
        block = "<leader>cb",
    },
    opleader = {
        line = "<leader>cz",
        block = "<leader>cx",
    },
    mappings = {
        basic = true,
        extra = false,
        extended = false,
    },
}
EOF

" gutentags
let g:gutentags_project_root = [".enable_tags"]
let g:gutentags_file_list_command = {
    \ 'markers': {
        \ '.git': 'git ls-files',
        \ '.enable_tags' : 'find . -type f',
        \ },
    \ }

" hlslens
noremap <silent> n <cmd>execute('normal! ' . v:count1 . 'n')<cr>
            \<cmd>lua require('hlslens').start()<cr>
noremap <silent> N <cmd>execute('normal! ' . v:count1 . 'N')<cr>
            \<cmd>lua require('hlslens').start()<cr>
noremap * *<cmd>lua require('hlslens').start()<cr>
noremap # #<cmd>lua require('hlslens').start()<cr>
noremap g* g*<cmd>lua require('hlslens').start()<cr>
noremap g# g#<cmd>lua require('hlslens').start()<cr>
noremap <leader>h :nohlsearch<cr>

" Scrollbar TODO come back when more developed
lua << EOF
local nord = require("nord.colors")
require("scrollbar").setup{
    show = true,
    handle = {
        text = " ",
        color = nord.nord1_gui,
        hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
    marks = {
        Search = { text = { "-", "=" }, priority = 0, color = nord.nord8_gui },
        Error = { text = { "-", "=" }, priority = 1, color = nord.nord11_gui },
        Warn = { text = { "-", "=" }, priority = 2, color = nord.nord12_gui },
        Info = { text = { "-", "=" }, priority = 3, color = nord.nord13_gui },
        Hint = { text = { "-", "=" }, priority = 4, color = nord.nord14_gui },
        Misc = { text = { "-", "=" }, priority = 5, color = nord.nord15_gui },
    },
    handlers = {
        diagnostic = true,
        search = true,
    },
}
EOF

" Yode
lua require('yode-nvim').setup({})
map <Leader>yc      :YodeCreateSeditorFloating<CR>
map <Leader>yr :YodeCreateSeditorReplace<CR>
nmap <Leader>yd :YodeBufferDelete<cr>
imap <Leader>yd <esc>:YodeBufferDelete<cr>
" these commands fall back to overwritten keys when cursor is in split window
map <C-W>r :YodeLayoutShiftWinDown<CR>
map <C-W>R :YodeLayoutShiftWinUp<CR>
map <C-W>J :YodeLayoutShiftWinBottom<CR>
map <C-W>K :YodeLayoutShiftWinTop<CR>
" at the moment this is needed to have no gap for floating windows
" set showtabline=2

" alpha-nvim
lua << EOF
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , "<cmd>ene <bar> startinsert <cr>"),
    dashboard.button( "f", "  > Find file", "<cmd>Telescope find_files<cr>"),
	dashboard.button("t", "  > Find text", "<cmd>Telescope live_grep <cr>"),
    dashboard.button( "r", "  > Recent"   , "<cmd>Telescope oldfiles<cr>"),
    dashboard.button("p", "  > Update plugins", "<cmd>PlugUpgrade<bar>PlugUpdate<cr>"),
    dashboard.button( "q", "  > Quit NVIM", "<cmd>qa<cr>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
EOF

" Spectre
nnoremap <leader>s <cmd>lua require('spectre').open()<cr>
vnoremap <leader>s <cmd>lua require('spectre').open_visual()<CR>
lua << EOF
require('spectre').setup()
EOF

" Figet
lua << EOF
require"fidget".setup{
  timer = {
    task_decay = 200,        -- how long to keep around completed task, in ms
  },
}
EOF

" Colourizer
lua require'colorizer'.setup()

" Latex
let g:vimtex_view_general_viewer = 'zathura'

" R
" TODO help command?
augroup R_commands
    au!
    autocmd FileType rmd map <Leader>ll :let file_name=expand('%:r')<enter> :!echo<space>"require(rmarkdown);<space>render('<c-r>%', output_file = '<c-r>=file_name<enter>.pdf')"<space>\|<space>R<space>--vanilla<enter>
augroup END
