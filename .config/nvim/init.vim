call plug#begin('~/.local/share/nvim/plugged')
" Language server protocol client
Plug 'neovim/nvim-lspconfig'
Plug 'folke/lsp-colors.nvim'
Plug 'kosayoda/nvim-lightbulb' " Code action
Plug 'ray-x/lsp_signature.nvim' " Signature Highlight

" Autocomplete 
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat' }

" Powerline
Plug 'itchyny/lightline.vim'

" File selector
Plug 'mcchrish/nnn.vim'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

" Comments
Plug 'tpope/vim-commentary' " gc

" Tag manager
Plug 'ludovicchabant/vim-gutentags'

" Multicursor
Plug 'mg979/vim-visual-multi'

" Highlight copy
Plug 'machakann/vim-highlightedyank'

" CursorHold time changer
Plug 'antoinemadec/FixCursorHold.nvim'

" Dependency for telescope and git signs
Plug 'nvim-lua/plenary.nvim'

" Finder 
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Git
Plug 'lewis6991/gitsigns.nvim'

" Undo tree
Plug 'mbbill/undotree'

" Better wildmenu
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

" Intent markers
Plug 'lukas-reineke/indent-blankline.nvim'

" Pretty tabs
Plug 'akinsho/bufferline.nvim'

" Key shortcut explainer
Plug 'folke/which-key.nvim'

" Auto pairs
Plug 'windwp/nvim-autopairs'

" Tex
Plug 'lervag/vimtex'

" R
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}

" sxhkd highlighting
Plug 'kovetskiy/sxhkd-vim'

" Nord colour theme
Plug 'shaunsingh/nord.nvim'
call plug#end()

" TODO Checkout nvim-dap, neorg and nvim-lsputils

" gdb in vim
" packadd termdebug

function BarToggle()
    UndotreeToggle
endfunction

command BarToggle call BarToggle()

" nnn
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit' }
nmap mmm :Nnn<CR>


" Theme
colorscheme nord
let g:nord_cursor_line_number_background = 1
let g:lightline = {
            \ 'colorscheme': 'nord',
            \ }

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

" Remove borders between windows, note the white-space
set fillchars+=vert:\ 
highlight VertSplit cterm=NONE

" Coq
autocmd VimEnter * COQnow --shut-up

" Tree sitter and autopairs
lua <<EOF
local npairs = require("nvim-autopairs") 

npairs.setup({
    check_ts = true,
    disable_filetype = { "TelescopePrompt" , "vim" },
})

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    autopairs = {
        enable = true,
    },
}

local Rule = require('nvim-autopairs.rule')
npairs.add_rule(Rule("\\(","\\)","tex"))
EOF

" lsp
lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>c', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    require "lsp_signature".on_attach({
        doc_lines = 3,
        floating_window = false,
        hint_enable = true,
        hint_prefix = "",
    })
end

-- C++
nvim_lsp.ccls.setup {
    on_attach = on_attach,  
    init_options = {
        cache = {
            directory = ".ccls-cache"
        },
        clang = {
            extraArgs = {"-std=c++20"}
        }
    }
}

-- Python
nvim_lsp.jedi_language_server.setup {
    on_attach = on_attach
}

-- efm Allows for formatters
nvim_lsp.efm.setup {
    on_attach = on_attach,  
    init_options = {documentFormatting = true},
    settings = {
        languages = {
            python = {
                {formatCommand = "black --quiet -", formatStdin = true},
                {formatCommand = "isort --quiet -", formatStdin = true},
                {lintCommand = "flake8 --stdin-display-name={$INPUT} -", lintStdin = true},
                {lintCommand = "mypy --show-column-numbers"},
            }
        }
    }
}
EOF

" Code action lightbulb
let g:cursorhold_updatetime = 100
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb{sign={enabled=false},virtual_text={enabled=true}}

" bufferline
set termguicolors
lua << EOF
require('bufferline').setup {
  options = {
    numbers = "buffer_id",
    number_style = "",
    show_buffer_close_icons = false,
    show_close_icon =  false,
  }
}
EOF

" These commands will navigate through buffers in order regardless of which mode you are using
nnoremap <silent>b] :BufferLineCycleNext<CR>
nnoremap <silent>b[ :BufferLineCyclePrev<CR>

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

" Telescope TODO work out more pickers
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

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

" Git Signs
lua << EOF
-- TODO configure
require('gitsigns').setup()
EOF

"Latex
let g:vimtex_view_general_viewer = 'zathura'

" R
" If there is X open pdf viewer when we first compile
if $DISPLAY != ""
    let R_openpdf = 1
endif

