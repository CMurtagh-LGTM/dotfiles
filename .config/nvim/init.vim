call plug#begin('~/.local/share/nvim/plugged')
" Language server protocol client
Plug 'neovim/nvim-lspconfig'
Plug 'folke/lsp-colors.nvim'

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

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Finder 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Undo tree
Plug 'mbbill/undotree'

" Intent markers
Plug 'lukas-reineke/indent-blankline.nvim'

" Pretty tabs
Plug 'akinsho/bufferline.nvim'

" Tex
Plug 'lervag/vimtex'

" R
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}

" sxhkd highlighting
Plug 'kovetskiy/sxhkd-vim'

" Nord colour theme
Plug 'arcticicestudio/nord-vim'
call plug#end()

" TODO Checkout barbar and which-key

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

" Remove borders between windows, note the white-space
set fillchars+=vert:\ 
highlight VertSplit cterm=NONE

" Coq
autocmd VimEnter * COQnow --shut-up

" Tree sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
lua <<EOF
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}
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
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>c', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- C++
nvim_lsp.ccls.setup {
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
nvim_lsp.jedi_language_server.setup {}

-- efm Allows for formatters
nvim_lsp.efm.setup {
    init_options = {documentFormatting = true},
    settings = {
        languages = {
            python = {
                -- TODO isort, flake8 and mypy
                {formatCommand = "black --quiet -", formatStdin = true}
            }
        }
    }
}
EOF

" Git
" Git gutter update time in ms
set updatetime=100


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

"Latex
let g:vimtex_view_general_viewer = 'zathura'

" R
" If there is X open pdf viewer when we first compile
if $DISPLAY != ""
    let R_openpdf = 1
endif

