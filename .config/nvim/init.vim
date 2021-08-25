
call plug#begin('~/.local/share/nvim/plugged')
" Autocomplete
Plug 'neovim/nvim-lspconfig' " TODO
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

" Format
Plug 'sbdchd/neoformat'

" Comments
Plug 'tpope/vim-commentary' " gc

" Tag manager
Plug 'ludovicchabant/vim-gutentags'

" Multicursor
" Installed from AUR
" Plug 'git@github.com:mg979/vim-visual-multi.git', {'branch': 'master'}

" Highlight copy
Plug 'machakann/vim-highlightedyank'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fuzzy finding
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

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
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
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

" fuzzy finding options
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" UndoTree
" Put it on the right
let g:undotree_WindowLayout = 3


" Set rofi config syntax
" au BufNewFile,BufRead /*.rasi setf css


"Latex
let g:vimtex_view_general_viewer = 'zathura'

" R
" If there is X open pdf viewer when we first compile
if $DISPLAY != ""
    let R_openpdf = 1
endif

