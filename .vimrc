" Minimal Vim configuration.
" Adapted from the core options and keymaps in soulz3r/cvim.
" Neovim-only and plugin-dependent features are intentionally omitted.

set nocompatible
set backspace=indent,eol,start
set history=1000

" Editing and indentation.
set autoindent
set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Display.
set number
set relativenumber
set numberwidth=2
set cursorline
set signcolumn=yes
set nowrap
set scrolloff=4
set sidescrolloff=8
set laststatus=2
set showmatch
set matchtime=2
set cmdheight=1

" Search.
set hlsearch
set incsearch
set ignorecase
set smartcase

" Splits and completion.
set splitbelow
set splitright
set wildmenu
set wildmode=longest:full,full
set pumheight=10

" Files and performance.
set nobackup
set nowritebackup
set noswapfile
set undofile
set updatetime=300
set timeoutlen=500
set autoread
set hidden

" Change the terminal cursor shape by Vim mode (WezTerm / DECSCUSR).
" Normal: steady block. Insert: blinking bar. Replace: underline.
let &t_EI = "\<Esc>[2 q"
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[4 q"

" Terminal and clipboard.
set mouse=a
set termguicolors
set clipboard=unnamedplus

" Keep the leader consistent with CVIM.
let mapleader = " "

" Window navigation.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <M-Tab> <C-^>

" Search results stay centered.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Use visual screen lines for movement.
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

" Start/end of the visible line.
nnoremap <S-h> ^
xnoremap <S-h> ^
onoremap <S-h> ^
nnoremap <S-l> g_
xnoremap <S-l> g_
onoremap <S-l> g_

" Editing behavior.
xnoremap p "_dP
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Move lines and visual selections.
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
xnoremap <M-j> :m '>+1<CR>gv=gv
xnoremap <M-k> :m '<-2<CR>gv=gv

" Common actions.
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>cd :cd %:p:h<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>nm :messages<CR>
nnoremap <leader>ni :execute "edit" fnameescape($MYVIMRC)<CR>

" Double comma exits Insert/Visual mode; in Normal mode it clears search.
inoremap ,, <Esc>
xnoremap ,, <Esc>
nnoremap ,, :nohlsearch<CR>

