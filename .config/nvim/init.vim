call plug#begin('~/.local/share/nvim/plugged')
" Language server protocol client
Plug 'neovim/nvim-lspconfig'
Plug 'folke/lsp-colors.nvim'
Plug 'kosayoda/nvim-lightbulb' " Code action
Plug 'ray-x/lsp_signature.nvim' " Signature Highlight

" Autocomplete 
Plug 'ms-jpq/coq_nvim', {'do' : ':COQdeps','branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat' }

" Powerline
Plug 'itchyny/lightline.vim'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

" Comments
Plug 'tpope/vim-commentary' " gc

" Tag manager
Plug 'ludovicchabant/vim-gutentags'

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

" sxhkd highlighting
Plug 'kovetskiy/sxhkd-vim'

" Nord colour theme
Plug 'shaunsingh/nord.nvim'
call plug#end()

" TODO Checkout nvim-dap, neorg, nvim-lsputils and lualine or galaxyline

" gdb in vim
" packadd termdebug

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

" Some easy mappings
nnoremap Y y$
nnoremap <leader>v <cmd>vsplit<cr>
nnoremap <leader>s <cmd>split<cr>
nnoremap <c-z> [s1z=``
inoremap <c-z> <Esc>[s1z=``a

" Remove borders between windows, note the white-space
set fillchars+=vert:\ 
highlight VertSplit cterm=NONE

" Coq
autocmd VimEnter * COQnow --shut-up
let g:coq_settings = { "keymap.recommended": v:false }
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

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

-- lsp

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }
    --TODO add telescope lsp commands
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
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)    

    require "lsp_signature".on_attach({
        doc_lines = 3,
        floating_window = false,
        hint_enable = true,
        hint_prefix = "",
    })
end

-- C++
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

-- Python
nvim_lsp.jedi_language_server.setup (coq.lsp_ensure_capabilities{
    on_attach = on_attach
})

-- efm Allows for formatters
nvim_lsp.efm.setup (coq.lsp_ensure_capabilities{
    on_attach = on_attach,  
    init_options = {documentFormatting = true},
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

-- R
nvim_lsp.r_language_server.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
})

-- Java :vomit:
nvim_lsp.jdtls.setup(coq.lsp_ensure_capabilities{
    on_attach = on_attach,
    cmd = {"jdtls"},
})

-- ltex-ls wait for upstream
EOF

" Code action lightbulb
let g:cursorhold_updatetime = 500

augroup hover
    au!
    autocmd CursorHold *.py lua if vim.fn.pumvisible() then vim.lsp.buf.hover() end
    autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb{sign={enabled=false},virtual_text={enabled=true}}
augroup END

" bufferline
set termguicolors
lua << EOF
require('bufferline').setup {
  options = {
    numbers = function(opts)
        return string.format('%s', opts.ordinal)
    end,
    show_buffer_close_icons = false,
    show_close_icon =  false,
  }
}
EOF

" These commands will navigate through buffers in order regardless of which mode you are using
nnoremap <leader>] :BufferLineCycleNext<CR>
nnoremap <leader>[ :BufferLineCyclePrev<CR>
nnoremap <leader>b <cmd>exe "BufferLineGoToBuffer " . v:count1<cr>
nnoremap <leader>d <cmd>exe "bd " . bufnr("%")<cr> 

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
nnoremap <leader>p <cmd>Telescope git_files<cr>  
nnoremap <leader>ff <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>ft <cmd>Telescope tags<cr>
nnoremap <leader>fm <cmd>Telescope man_pages<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr> 
nnoremap <leader>f<space> <cmd>Telescope builtin<cr>  

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

" Git Signs
lua << EOF
-- TODO configure
require('gitsigns').setup()
EOF

"Latex
let g:vimtex_view_general_viewer = 'zathura'

" R
augroup R_commands
    au!
    autocmd FileType rmd map <Leader>ll :let file_name=expand('%:r')<enter> :!echo<space>"require(rmarkdown);<space>render('<c-r>%', output_file = '<c-r>=file_name<enter>.pdf')"<space>\|<space>R<space>--vanilla<enter>
augroup END
