"call pathogen#infect()
syntax on
filetype plugin indent on

"let &t_Co=256
let &colorcolumn=120
let ruby_fold=1

colorscheme gotham
"colorscheme Mustang

let mapleader=','

command! ListAutoAdds echo substitute(system('cd ~/.vim/inserts && find . -type f'), "\\./", "", "g")
function! InsertThing(selected)
	silent exec ":r ~/.vim/inserts/" . a:selected
endfunction

function! CreateInits()
	:!touch "tests/__init__.py"

	let fileStructure = []
	for folder in split(expand("%"), "/")
		if folder == expand("%:t")
			break
		endif
		call add(fileStructure, folder)
		silent exec "!touch ". join(fileStructure, "/") . "/__init__.py"
	endfor
endfunction

function! GetRightTestFile()
	if expand("%:t")!~#'test_.*.py'
		return substitute('tests/'.expand("%:h").'/test_'.expand("%:t:r"), "/", ".", "g")
	elseif expand("%:t")=~#'.*.py'
		return substitute(expand("%:h").'/'.expand("%:t:r"), "/", ".", "g")
	endif
	return ''
endfunction

nnoremap <leader>ta :!python manage.py test<CR>
nnoremap <leader>tt :!python manage.py test <C-r>=GetRightTestFile()<CR><CR>
nnoremap <leader>tc :vs tests/%:h/test_%:t:r.py<CR>

nnoremap <leader>i :call tlib#cmd#BrowseOutputWithCallback('InsertThing','ListAutoAdds')<CR>


set termguicolors

set nocompatible
set autoread


set hidden
set number

set completeopt=longest,menuone
function! Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
	return "\<C-n>\<C-r>=pumvisible() ? \"\\<Down>\" : \"\"\<CR>"
    else
        return "\<Tab>"
    endif
endfunction

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

augroup BWCCreateDir
    autocmd!
        autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
        autocmd BufWritePre * if expand("%:t")=~#'test_.*.py' | call CreateInits() | redraw | endif
augroup END

set history=1000
set undolevels=10000
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

autocmd FileType ruby,cucumber,haml,yaml,lettuce,qml,eruby,html,htmldjango setlocal expandtab shiftwidth=2 softtabstop=2 foldlevel=999
autocmd FileType javascript,python,markdown,css,scss,php setlocal expandtab shiftwidth=4 softtabstop=4
"autocmd FileType javascript setlocal foldlevel=999
"autocmd FileType javascript call JavaScriptFold()
au BufRead,BufNewFile *.twig set filetype=html

"autocmd FileType python omnifunc=pythoncomplete#Comlete
"inoremap <C-Space> <C-x><C-o>

"autocmd VimEnter * NERDTree

hi Folded ctermbg=None
nnoremap <Space> za

function! MethodsFirstFolds()
  let line = getline(v:foldstart)
  let num_lines = v:foldend - v:foldstart
  return '+' . v:folddashes . line . "\t[" .num_lines .' lines folded]'
endfunction

set foldtext=MethodsFirstFolds()

highlight ColorColumn ctermbg=235 guibg=#2c2d27

let g:airline_powerline_fonts = 1

"nnoremap <leader>t :w<CR>:!rspec<CR>
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/tlib_vim
let g:tlib#input#filter_mode = 'fuzzy'
