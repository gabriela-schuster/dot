call plug#begin()

Plug 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
Plug 'preservim/NERDtree'
Plug 'vim-airline/vim-airline'    "status bar at the bottom
Plug 'frazrepo/vim-rainbow'	" matches brackets/parentesis/etc.
Plug 'dense-analysis/ale'     " kinda of debugger, ALEToggle
Plug 'morhetz/gruvbox'    "colorscheme gruvbox
Plug 'mg979/vim-visual-multi', {'branch': 'master'}	" multiple cursors
Plug 'sheerun/vim-polyglot'     " better syntax for languages
Plug 'jiangmiao/auto-pairs'     "autopairs parentesis etc.
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

"======== Themes ========

Plug 'morhetz/gruvbox'
Plug 'franbach/miramare'
Plug 'sainnhe/forest-night'

call plug#end()

"======== Plugs configs ========

" NERDtree config
cd ~/Documents
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" autocmd VimEnter * NERDTree     "open by default, below exit vim if nerd is the only tab open
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" vim-rainbow config
let g:rainbow_active = 1      "enable it globally

" deoplete config
let g:deoplete#enable_at_startup = 1

"======== Setting things ========

set hidden	" lets unsaved files in memory without needed saving
set number
set relativenumber
set mouse=a

au BufReadPost *.html set syntax=html

"themes settings
let g:miramare_enable_italic = 1
let g:miramare_disable_italic_comment = 0
let g:miramare_transparent_background = 1

let g:gruvbox_material_background = 'soft'
let g:gruvbox_transparent_bg = 1
let g:gruvbox_italicize_comments = 1

set termguicolors
let g:airline_theme = 'miramare'
colorscheme miramare
"hi Normal guibg=NONE ctermbg=NONE  transparent bg, do an if later with
"miramare

"======== nnoremap ========

let mapleader=" "

" move between panels with C h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
