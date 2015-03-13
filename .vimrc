call pathogen#infect()
syntax on
filetype plugin indent on

let &t_Co=256
let &colorcolumn=120
colorscheme mustang

set nocompatible
set autoread

set hidden
set number

set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell

set nobackup
set noswapfile
set ruler

set smartindent
set autoindent

set showmode
set showcmd
set incsearch
set ignorecase
set laststatus=2

fun! ClearAllTrailingSpaces()
    %s/\s\+$//
    %s/\t/    /g
endfun

"cmap ct :call ClearAllTrailingSpaces()<CR>

"set splitright
set wildmenu
set wildmode=list:longest

set statusline=%F%m%r%h%w\ [TYPE=%Y]\ \ \ \ \ \ \ \ \ \ \ \ [POS=%2l,%2v][%p%%]\ \ \ \ \ \ \ \ \ \ \ \ [LEN=%L]
set laststatus=2

set switchbuf=useopen

:set backspace=indent,eol,start

set list listchars=tab:»∙,trail:∙
"iabbrev rdebug require 'ruby-debug'; Debugger.settings[:autoeval] = 1; Debugger.setttings[:autolist] =1; debugger

au BufRead,BufNewFile *.sls setfiletype yaml
au BufRead,BufNewFile *.feature setfiletype ruby
au BufRead,BufNewFile *.pyx setfiletype python
au BufRead,BufNewFile *.qml setfiletype qml

autocmd FileType html,htmldjango setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType ruby,cucumber,haml,yaml,lettuce,qml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4


"autocmd FileType python omnifunc=pythoncomplete#Comlete
"inoremap <C-Space> <C-x><C-o>

"autocmd VimEnter * NERDTree

hi Folded ctermbg=None
set foldlevel=1
nnoremap <Space> za

function MethodsFirstFolds()
  let line = getline(v:foldstart)
  let num_lines = v:foldend - v:foldstart
  return '+' . v:folddashes . line . "\t[" .num_lines .' lines folded]'
endfunction

set foldtext=MethodsFirstFolds()

highlight ColorColumn ctermbg=235 guibg=#2c2d27

let g:airline_powerline_fonts = 1
