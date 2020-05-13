set relativenumber
set number
set cc=81
set smartindent
set autoindent
set ruler
set mouse=a
set lazyredraw
tnoremap kj <c-\><c-n>
inoremap kj <esc>
set splitbelow
set splitright
set tabstop=4
set shiftwidth=4 

set winwidth=86 "Set minimum width of current window to 86
autocmd WinEnter * wincmd = "and make other windows have equal size
							"(avoids having one window that's really small
							"after the winwidth auto resize)

set ignorecase
set smartcase
set wrapscan                      " Circle search

set inccommand=nosplit "realtime regex in neovim, very cool

" autoread and autowrite
augroup save
  au!
  au WinEnter * wall
augroup END
set nohidden
set nobackup
set noswapfile
set autoread
set autowrite
set autowriteall

" persistent-undo
set undodir=~/.config/nvim/undo
set undofile
set undolevels=2000

cnoreabbrev Vsp vsp

set scrolloff=7                   " Show 7 lines of context around the cursor.

set shell=bash		"use bash instead of fish because it's faster for fugitive

"but use fish in terminal buffers

function Fish_Term() 
	set shell=fish
	:terminal
	set shell=bash
endfunction

command Ter call Fish_Term()
cnoreabbrev ter Ter

function Hide_term_statusline() "hide statusline in term buffers because of an airline bug
	:AirlineToggle
	set ft=hide
	:AirlineToggle
endfunction

augroup term
	autocmd!
	autocmd TermOpen * call Hide_term_statusline()
augroup END

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$' "highlight git conflict markers

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'sjl/gundo.vim'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
Plug 'yegappan/mru'
Plug 'fratajczak/vim-operator-highlight'
Plug 'chrisbra/Colorizer'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'psliwka/vim-smoothie'
Plug 'haya14busa/incsearch.vim'
Plug '~/.brew/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'unblevable/quick-scope'
Plug 'pandark/42header.vim'
Plug 'tmsvg/pear-tree'
Plug 'vim-airline/vim-airline'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'ryanoasis/vim-devicons'
Plug 'christoomey/vim-conflicted'
Plug 'sodapopcan/vim-twiggy'

call plug#end()

augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary guifg='#E06C75' gui=underline ctermfg=155 cterm=underline
	autocmd ColorScheme * highlight QuickScopeSecondary guifg='#98C379' gui=underline ctermfg=81 cterm=underline
augroup END

""set termguicolors
set background=dark
colorscheme palenight
let g:airline_theme = 'palenight'
if !has('gui_running')
	set t_Co=256
endif

let g:ale_linters = {
			\	'c': ['norminette'],
			\   'cpp': ['norminette'],
			\   'h': ['norminette'],
			\   'hpp': ['norminette']
			\}

let mapleader = "\<Space>"

noremap <leader>f :GFiles<CR>
noremap <leader>t :Tags<CR>
noremap <leader>l :Lines<CR>
noremap <leader>r :Rg<CR>
au FileType fzf tnoremap <c-s> <c-x>

"open :Gstatus in new tab
noremap <leader>s :Gtabedit : <CR> :set previewwindow<CR>

let s:startify_ascii_header = [
			\ '                                        ▟▙            ',
			\ '                                        ▝▘            ',
			\ '██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖',
			\ '██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██',
			\ '██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██',
			\ '██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██',
			\ '▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀',
			\ '',
			\]
let g:startify_custom_header = map(s:startify_ascii_header +
			\ startify#fortune#quote(), '"   ".v:val')

let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" floating fzf
let $FZF_DEFAULT_OPTS=' --layout=reverse  --margin=1,4'
function! FloatingFZF()
	let buf = nvim_create_buf(v:false, v:true)
	call setbufvar(buf, '&signcolumn', 'no')
	let width = float2nr(&columns * 0.8)
	let height = float2nr(&lines * 0.6)
	let opts = { 'relative': 'editor',
				\ 'row': (&lines - height) / 2,
				\ 'col': (&columns - width) / 2,
				\ 'width': width,
				\ 'height': height,
				\ 'style': 'minimal'}
	call nvim_open_win(buf, v:true, opts)
endfunction

let g:fzf_layout = { 'window': 'call FloatingFZF()' }

let preview_file = '~/.config/nvim/preview.sh'
command! -bang -nargs=* Tags
  \ call fzf#vim#tags(<q-args>, {
  \      'window': 'call FloatingFZF()',
  \      'options': '
  \         --with-nth 1,2
  \         --prompt "=> "
  \         --preview-window="50%"
  \         --preview ''' . preview_file . ' {}'''
  \ }, <bang>0)

command Stdheader FortyTwoHeader

let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#vcs_checks = ['untracked']
let g:airline_mode_map = {}
let g:airline_mode_map['ic'] = 'INSERT'

let g:airline_exclude_filetypes = ["hide"]
let g:airline#extensions#term#enabled = 0
let g:airline#extensions#whitespace#enabled = 0

let g:pear_tree_repeatable_expand = 0 "both brackets appear instantly on newlines

set updatetime=300
set signcolumn=yes

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <leader>d  :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>n <Plug>(coc-rename)

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
