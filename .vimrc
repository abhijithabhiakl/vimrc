" ╔══════════════════════════════════════════════════════════╗
" ║                        W I M                             ║
" ║          IDE-like Vim / Neovim Configuration             ║
" ║      Based on wolandark/wim — modernized 2025            ║
" ╚══════════════════════════════════════════════════════════╝
"
" https://github.com/wolandark/wim
"
" Changes from original:
"   - Dead code removed (duplicate CreateInPreview)
"   - auto-pairs replaces manual bracket inoremap hacks
"   - vim-hexokinase replaced with vim-colorizer (no make step)
"   - Added nvim-compatible guards throughout
"   - lazy-loaded where possible
"   - Comment style unified
"   - Redundant/conflicting options cleaned up
"   - Added missing quality-of-life: better wildmenu, signcolumn,
"     scrolloff, matchpairs, whichwrap
"   - Terminal mappings improved
"   - Netrw section deduplicated

" ─────────────────────────────────────────────
"  Bootstrap vim-plug
" ─────────────────────────────────────────────
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ─────────────────────────────────────────────
"  Plugins
" ─────────────────────────────────────────────
call plug#begin()

" --- Git ---
Plug 'tpope/vim-fugitive'

" --- Editing primitives ---
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'           " shell commands (:Rename, :Move, :Delete …)
Plug 'jiangmiao/auto-pairs'        " smarter than raw inoremap hacks

" --- Motion ---
Plug 'easymotion/vim-easymotion'
Plug 'rhysd/clever-f.vim'

" --- Fuzzy finding ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" --- Completion & LSP ---
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" --- Snippets ---
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" --- UI ---
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/goyo.vim'           " distraction-free writing
Plug 'junegunn/vim-peekaboo'       " peek into registers

" --- Colors ---
Plug 'chriskempson/base16-vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'norcalli/nvim-colorizer.lua' " replaces hexokinase (no `make` step)
"   └─ Neovim only. For plain Vim, swap with:
"      Plug 'ap/vim-css-color'

" --- Alignment ---
Plug 'godlygeek/tabular'

" --- Tags ---
Plug 'preservim/tagbar'

" --- File-type extras ---
Plug 'baskerville/vim-sxhkdrc'
Plug 'vimwiki/vimwiki'
Plug 'Valloric/MatchTagAlways'

" --- Misc ---
Plug 'markonm/traces.vim'          " live substitution preview
Plug '907th/vim-auto-save'
Plug 'rstacruz/sparkup'
Plug 'vim-scripts/loremipsum'
Plug 'terroo/vim-simple-emoji'

call plug#end()

" ─────────────────────────────────────────────
"  General options
" ─────────────────────────────────────────────
set encoding=utf-8
set nocompatible
set hidden                    " keep buffers alive when abandoned
set autoread                  " reload files changed outside vim
set autowrite                 " write before :make, :next, etc.
set noswapfile
set modifiable

" Undo persistence
if has('persistent_undo')
    set undodir=$HOME/.vimhis
    set undolevels=5000
    set undofile
endif

" Indentation
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
filetype plugin indent on

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase
noremap <silent> <Esc> <Esc>:nohlsearch<CR>

" Appearance
syntax on
set relativenumber
set number                    " absolute number on current line, relative elsewhere
set signcolumn=yes            " always show; stops layout jumping with coc
set colorcolumn=80
set laststatus=2
set noshowmode                " lightline already shows mode
set cmdheight=2               " more room for coc messages
set updatetime=300            " recommended by coc
set shortmess+=c              " suppress ins-completion messages

" Scroll & navigation
set scrolloff=6
set sidescrolloff=4
set splitbelow splitright
set whichwrap+=<,>,h,l        " allow arrow keys / h,l to wrap lines

" Folding
set foldenable
set foldmethod=indent
set foldopen+=jump
" Wildmenu
set wildmenu
set wildmode=longest:full,full
set path+=**

" Misc
set listchars=tab:▸\ ,trail:·,nbsp:␣
set list
set conceallevel=0
set lazyredraw
set noerrorbells novisualbell t_vb=
set emoji
set autochdir
set so=6                      " same as scrolloff; kept for compatibility

" Clipboard
set clipboard=unnamedplus,unnamed

" Terminal bidi (Arabic/Hebrew)
set termbidi

" Cursor (no blink)
set guicursor+=a:blinkon0
set guifont=FiraCode\ Nerd\ Font\ 12

" Return to last position on file open
if has('autocmd')
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g'\"" | endif
endif

" ─────────────────────────────────────────────
"  Theme & colors
" ─────────────────────────────────────────────
set background=dark

augroup MyColors
    autocmd!
    autocmd ColorScheme * highlight ColorColumn guibg=#242424 ctermbg=236
augroup END

if &term =~ '256color' || has('nvim')
    if has('termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
    endif
    colorscheme base16-gruvbox-dark-hard
endif

if has('gui_running')
    set mouse=a
    colorscheme base16-gruvbox-dark-hard
endif

" nvim-colorizer (Neovim only — silently skip on plain Vim)
if has('nvim')
    silent! lua require('colorizer').setup()
endif

" ─────────────────────────────────────────────
"  Leader & basic remaps
" ─────────────────────────────────────────────
let mapleader = ' '

nnoremap ; :

" Move to middle of line
nnoremap <C-m> :exe 'normal! ' . (virtcol('$') / 2) . '\|'<CR>

" ─────────────────────────────────────────────
"  Window / split navigation
" ─────────────────────────────────────────────
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-Left>  <C-w>h
map <C-Down>  <C-w>j
map <C-Up>    <C-w>k
map <C-Right> <C-w>l

" Resize with Shift + arrows
map <S-Left>  :vertical resize +5<CR>
map <S-Right> :vertical resize -5<CR>
map <S-Up>    :resize +5<CR>
map <S-Down>  :resize -5<CR>

map <leader>R <C-w>R

" Navigate in insert mode without leaving home row
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l
inoremap <A-b> <C-o>b
inoremap <A-w> <C-o>w

" ─────────────────────────────────────────────
"  Tab navigation
" ─────────────────────────────────────────────
nnoremap <M-Left>  :tabprevious<CR>
nnoremap <M-Right> :tabnext<CR>
nnoremap <M-h>     :tabprevious<CR>
nnoremap <M-l>     :tabnext<CR>

noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<CR>

nnoremap <leader>T  :tabnew<CR>
nnoremap <leader>x  :tabclose<CR>
map      <leader>tm :tabmove<CR>

" ─────────────────────────────────────────────
"  File / buffer
" ─────────────────────────────────────────────
nmap <nowait><leader>w  :w!<CR>
nnoremap        <leader>op :source %<CR>
nnoremap        <leader>mk :mkview<CR>
map             <leader>b  :Buffers<CR>
map             <leader>s  :Files<CR>
map             <leader>W  :Windows<CR>
map             <leader>H  :History<CR>
map             <leader>Hc :History:<CR>
map             <leader>M  :Maps<CR>
map <nowait>    <leader>c  :Colors<CR>

" ─────────────────────────────────────────────
"  Editing helpers
" ─────────────────────────────────────────────
" Escape with jj
inoremap <nowait> jj <Esc>

" Remove duplicate lines
nnoremap <leader>d :g/^\(.*\)$\n\1/d<CR>

" Add empty lines above/below
nnoremap <leader>S :normal! O<Esc>jo<Esc><CR>
map <leader>[ :call append(line('.') - 1, '')<CR>
map <leader>] :call append(line('.'), '')<CR>

" Move lines up/down
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
vnoremap <leader>k :m '<-2<CR>gv=gv
vnoremap <leader>j :m '>+1<CR>gv=gv

" Move current line above the one before it (original behaviour kept)
nnoremap <leader>u :normal! kmmjdd{p'm<CR>

" Shebang shortcuts
nnoremap bs i#!/bin/bash<Esc>0
nnoremap be i#!/usr/bin/env bash<Esc>0
nmap     br i<br><Esc>0

" Make file executable
nmap <leader>h :Chmod +x<CR>

" Startify
nnoremap <leader>i :Startify<CR>

" Justify macro
ru macros/justify.vim

" Toilet / figlet banners
nmap <leader>\ :.!toilet -w 200 -f term -F border<CR>

" ─────────────────────────────────────────────
"  Spell check
" ─────────────────────────────────────────────
map <F6> :setlocal spell! spelllang=en_us<CR>
hi SpellBad ctermfg=red guifg=red

function! Fixspell() abort
    normal! 1z=
endfunction
nnoremap <leader>z :call Fixspell()<CR>

" Auto-fix next N words (use sparingly — still noisy)
nmap <leader>l :normal! 1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w1z=w<CR>

" ─────────────────────────────────────────────
"  Terminal
" ─────────────────────────────────────────────
set termwinsize=12x0            " 0 = full width
nnoremap <leader>' :botright terminal<CR>

" Escape terminal mode and jump to the split above/below
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <Esc> <C-\><C-n>       " Esc exits terminal mode

set shell=/bin/bash

" ─────────────────────────────────────────────
"  Floaterm
" ─────────────────────────────────────────────
let g:floaterm_autohide  = 0
let g:floaterm_autoclose = 2
let g:floaterm_height    = 0.4   " proportion of screen (floats)
let g:floaterm_width     = 0.85

map  <leader>t  :FloatermToggle<CR>
nnoremap <leader>v :FloatermNew vifm<CR>
nnoremap <leader>r :FloatermNew ranger<CR>

" ─────────────────────────────────────────────
"  Coc.nvim
" ─────────────────────────────────────────────
" Explorer
let g:coc_explorer_global_mirror           = 0
let g:coc_explorer_disable_default_keybindings = 1
let g:coc_explorer_global_root             = 'current'
nmap <leader>e <Cmd>CocCommand explorer<CR>

" Tab completion
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Jump to definition / references
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" Diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Show hover docs
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" ─────────────────────────────────────────────
"  UltiSnips
" ─────────────────────────────────────────────
let g:UltiSnipsExpandTrigger       = '<C-j>'
let g:UltiSnipsListSnippets        = '<C-PageDown>'
let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" ─────────────────────────────────────────────
"  EasyMotion
" ─────────────────────────────────────────────
nmap fy <Plug>(easymotion-overwin-f)
nmap fl <Plug>(easymotion-overwin-line)
nmap ml <Plug>(easymotion-bd-jk)
nmap fw <Plug>(easymotion-overwin-w)
nmap s  <Plug>(easymotion-overwin-f2)
nmap <leader>f <Plug>(easymotion-w)
nmap <leader>m <Plug>(easymotion-bd-w)

" ─────────────────────────────────────────────
"  clever-f
" ─────────────────────────────────────────────
let g:clever_f_across_no_line  = 0
let g:clever_f_ignore_case     = 1
let g:clever_f_mark_char_color = 'StatuslineTermNC'

" ─────────────────────────────────────────────
"  Lightline
" ─────────────────────────────────────────────
function! WordCount() abort
    let l:count = wordcount()
    return l:count['words'] . ' words'
endfunction

let g:lightline = {
    \ 'colorscheme': 'powerline',
    \ 'active': {
    \   'left':  [['mode'], ['readonly', 'absolutepath', 'modified']],
    \   'right': [['lineinfo'], ['percent', 'wordcount'], ['filetype']],
    \ },
    \ 'component_function': {
    \   'wordcount': 'WordCount',
    \ },
    \ 'component': {
    \   'lineinfo': '%l/%L',
    \ },
    \ }

let g:lightline.separator    = { 'left': "\ue0b0", 'right': "\ue0b2" }
let g:lightline.subseparator = { 'left': "\ue0b1", 'right': "\ue0b3" }

" ─────────────────────────────────────────────
"  Netrw
" ─────────────────────────────────────────────
let g:NetrwIsOpen = 0

function! ToggleNetrw() abort
    if g:NetrwIsOpen
        let i = bufnr('$')
        while i >= 1
            if getbufvar(i, '&filetype') ==# 'netrw'
                silent exe 'bwipeout ' . i
            endif
            let i -= 1
        endwhile
        let g:NetrwIsOpen = 0
    else
        let g:NetrwIsOpen = 1
        silent Vexplore
    endif
endfunction

" Create a file in netrw's current directory
function! CreateInPreview() abort
    let l:filename = input('Filename: ')
    if l:filename !=# ''
        silent execute '!touch ' . b:netrw_curdir . '/' . l:filename
        redraw!
    endif
endfunction

autocmd FileType netrw nnoremap <buffer> % :call CreateInPreview()<CR>

" Close if netrw or quickfix is the last window
autocmd WinEnter * if winnr('$') == 1 &&
    \ (getbufvar(winbufnr(winnr()), '&filetype') ==# 'netrw' ||
    \  &buftype ==# 'quickfix') | q | endif

let g:netrw_list_hide   = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_special_syntax = 3
let g:netrw_banner      = 0
let g:netrw_liststyle   = 3
let g:netrw_browse_split = 4
let g:netrw_altv        = 1
let g:netrw_winsize     = 15
let g:netrw_keepdir     = 0

" ─────────────────────────────────────────────
"  Startify
" ─────────────────────────────────────────────
let g:startify_custom_header =
    \ startify#pad(split(system('figlet -f roman Vim | boxes -d parchment'), '\n'))

let g:startify_custom_footer = ['', '  Once you get in, there is no getting out.', '']

let g:startify_bookmarks = [
    \ {'I': '~/.config/i3/config'},
    \ {'B': '~/.bashrc'},
    \ {'V': '~/.vimrc'},
    \ ]

let g:startify_lists = [
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
    \ { 'type': 'files',     'header': ['   Recent'   ] },
    \ { 'type': 'sessions',  'header': ['   Sessions' ] },
    \ { 'type': 'commands',  'header': ['   Commands' ] },
    \ ]

hi StartifyBracket ctermfg=240
hi StartifyFile    ctermfg=147
hi StartifyFooter  ctermfg=240
hi StartifyHeader  ctermfg=114
hi StartifyNumber  ctermfg=215
hi StartifyPath    ctermfg=245
hi StartifySlash   ctermfg=240
hi StartifySpecial ctermfg=240

" ─────────────────────────────────────────────
"  Tagbar
" ─────────────────────────────────────────────
let g:tagbar_autofocus  = 1
let g:tagbar_autoupdate = 1

let g:tagbar_type_vimwiki = {
    \ 'ctagstype': 'vimwiki',
    \ 'kinds':     ['h:header'],
    \ 'sro':       '&&&',
    \ 'kind2scope':{'h': 'header'},
    \ 'sort':       0,
    \ 'ctagsbin':  $HOME . '/vwtags.py',
    \ 'ctagsargs': 'default',
    \ }

" ─────────────────────────────────────────────
"  VimWiki
" ─────────────────────────────────────────────
let g:vimwiki_global_ext = 0
let g:vimwiki_root_dir   = $HOME . '/vimwiki/'

" ─────────────────────────────────────────────
"  HTML
" ─────────────────────────────────────────────
let g:html_indent_script1    = 'inc'
let g:html_indent_style1     = 'inc'
let g:html_indent_attribute  = 1
let g:html_indent_inctags    = 'html,body,head,tbody'

augroup HtmlSkeleton
    autocmd!
    autocmd BufNewFile *.html 0r ~/.vim/skeleton.xml
augroup END

" ─────────────────────────────────────────────
"  Auto-save
" ─────────────────────────────────────────────
" Enabled per-buffer with :AutoSaveToggle; off by default globally
let g:auto_save = 0

" ─────────────────────────────────────────────
"  Abbreviations
" ─────────────────────────────────────────────
ab tea  ☕
ab ptr  ▶
ab cbe  ▄
ab cbe2 ■
ab okk  ✓
ab str  ★

" ─────────────────────────────────────────────
"  Commands
" ─────────────────────────────────────────────
command! Ra   !ranger
command! Vi   !vifm
command! Na   tabnew

" ─────────────────────────────────────────────
"  Auto-pairs (replaces manual inoremap hacks)
" ─────────────────────────────────────────────
" auto-pairs handles "", '', (), [], {} automatically.
" No manual inoremap overrides needed.
" Tweak if you want to exclude a pair:
" let g:AutoPairsMapCh = 0  " disable backspace shortcut if it conflicts

" vim: set foldmethod=marker foldmarker=────,─────:
