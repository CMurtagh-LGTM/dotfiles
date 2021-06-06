
call plug#begin('~/.local/share/nvim/plugged')
" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'deoplete-plugins/deoplete-tag'
Plug 'deoplete-plugins/deoplete-dictionary'

" Powerline
Plug 'itchyny/lightline.vim'

" File selector
Plug 'mcchrish/nnn.vim'

" Bracket Pairs - look into more
" Plug 'jiangmiao/auto-pairs'

" Comment <leader>cc
" Plug 'scrooloose/nerdcommenter'

" Icons
Plug 'ryanoasis/vim-devicons'

" Format
Plug 'sbdchd/neoformat'

" Code Check
Plug 'neomake/neomake'

" Multicursor
" Installed from AUR
" Plug 'git@github.com:mg979/vim-visual-multi.git', {'branch': 'master'}

" Highlight copy
Plug 'machakann/vim-highlightedyank'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Tags
Plug 'preservim/tagbar'

" Syntax Highlighting
Plug 'vim-syntastic/syntastic'

" Fuzzy finding
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Undo tree
Plug 'mbbill/undotree'

" Tex
Plug 'lervag/vimtex'

" sxhkd
Plug 'kovetskiy/sxhkd-vim'

" Nord colour theme
Plug 'arcticicestudio/nord-vim'
call plug#end()

" augroup fmt
"  autocmd!
"  autocmd BufWritePre * undojoin | Neoformat
" augroup END

function BarToggle()
    TagbarToggle
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


" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" Use deoplete.
let g:deoplete#enable_at_startup = 1
" deoplete autoclose preview
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif


" Deoplete neopsnippet
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"


" Git
" Git gutter update time in ms
set updatetime=100


" fuzzy finding options
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" UndoTree
" Put it on the right
let g:undotree_WindowLayout = 3

" python
let g:neomake_python_enabled_makers = ['pylint']
call neomake#configure#automake('nrwi', 500)


" Set rofi config syntax
au BufNewFile,BufRead /*.rasi setf css


" Latex
let g:vimtex_view_general_viewer = 'zathura'


" Tagbar extra languages
let g:tagbar_type_markdown = {
  \ 'ctagstype'	: 'markdown',
  \ 'kinds'		: [
    \ 'c:chapter:0:1',
    \ 's:section:0:1',
    \ 'S:subsection:0:1',
	\ 't:subsubsection:0:1',
    \ 'T:l4subsection:0:1',
    \ 'u:l5subsection:0:1',
  \ ],
  \ 'sro'			: '""',
  \ 'kind2scope'	: {
    \ 'c' : 'chapter',
    \ 's' : 'section',
    \ 'S' : 'subsection',
    \ 't' : 'subsubsection',
    \ 'T' : 'l4subsection',
  \ },
  \ 'scope2kind'	: {
    \ 'chapter' : 'c',
    \ 'section' : 's',
    \ 'subsection' : 'S',
    \ 'subsubsection' : 't',
    \ 'l4subsection' : 'T',
  \ },
\ }

let g:tagbar_type_yaml = {
    \ 'ctagstype' : 'yaml',
    \ 'kinds' : [
        \ 'a:anchors',
        \ 's:section',
        \ 'e:entry'
    \ ],
  \ 'sro' : '.',
    \ 'scope2kind': {
      \ 'section': 's',
      \ 'entry': 'e'
    \ },
    \ 'kind2scope': {
      \ 's': 'section',
      \ 'e': 'entry'
    \ },
    \ 'sort' : 0
    \ }
