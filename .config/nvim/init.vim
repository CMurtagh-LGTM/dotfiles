
call plug#begin('~/.local/share/nvim/plugged')
" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'deoplete-plugins/deoplete-tag'
Plug 'deoplete-plugins/deoplete-dictionary'
Plug 'deoplete-plugins/deoplete-clang'
" Better tab complete
" Plug 'ervandew/supertab'

" Files
Plug 'preservim/nerdtree' |
	\ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Powerline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Bracket Pairs - look into more
Plug 'jiangmiao/auto-pairs'

" Comment <leader>cc
Plug 'scrooloose/nerdcommenter'

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

" Documentation
Plug 'sunaku/vim-dasht'

" Undo tree
Plug 'mbbill/undotree'

" Tex
Plug 'lervag/vimtex'
call plug#end()

"augroup cameron_initialisation
"autocmd!
" Start tagbar
"autocmd VimEnter * TagbarOpen
" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window left.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
"    \ quit | endif
"augroup END

" augroup fmt
"  autocmd!
"  autocmd BufWritePre * undojoin | Neoformat
" augroup END

function BarToggle()
    TagbarToggle
    UndotreeToggle
    NERDTreeToggle
endfunction

command BarToggle call BarToggle()

" Theme
let g:airline_theme='dark'


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
" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
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


" Dasht
let g:dasht_filetype_docsets = {}
" search related docsets
nnoremap <silent> <Leader>K :call Dasht(dasht#cursor_search_terms())<Return>

" UndoTree
" Put it on the right
let g:undotree_WindowLayout = 3

" clang
g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
g:deoplete#sources#clang#std = {'c': 'c11', 'cpp': 'c++17', 'objc': 'c11', 'objcpp': 'c++1z'}


" python
let g:neomake_python_enabled_makers = ['pylint']
call neomake#configure#automake('nrwi', 500)
" When in Python, also search NumPy, SciPy, and Pandas:
let g:dasht_filetype_docsets['python'] = ['(num|sci)py', 'pandas']



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
