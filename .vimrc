set nocompatible              " be iMproved, required
filetype off                  " required


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'"
Plugin 'preservim/nerdtree'
Plugin 'vim-syntastic/syntastic'
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
"Plugin 'jremmen/vim-ripgrep'
Plugin 'jiangmiao/auto-pairs'
Plugin 'airblade/vim-gitgutter.git'
Plugin 'liuchengxu/vim-better-default'
Plugin 'leafgarland/typescript-vim'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'Quramy/tsuquyomi'
Plugin 'w0rp/ale'
Plugin 'tomtom/tlib_vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on
filetype plugin indent on

"let &t_Co=256
let &colorcolumn=120
let ruby_fold=1

"colorscheme gotham
"colorscheme Mustang
set background=dark
"colorscheme hybrid_material
colorscheme gotham
"colorscheme Mustang



set spell spelllang=en_us

let g:syntastic_python_checkers = ['python']
let g:syntastic_quiet_messages = { "type": "style" }

"let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_enable_balloons = 0

let g:ycm_clangd_uses_ycmd_caching = 0

let mapleader=','

command! ListAutoAdds echo substitute(system("find ~/.vim/inserts/ -type f | rev | cut -d '/' -f 1-2 | rev"), "\\./", "", "g")
function! InsertThing(selected)
    silent exec ":r ~/.vim/inserts/" . a:selected
endfunction


function! GetRightTestFile()
    if expand("%:t")!~#'test_.*.py'
        return substitute('tests/'.expand("%:h").'/test_'.expand("%:t:r"), "/", ".", "g")
    elseif expand("%:t")=~#'.*.py'
        return substitute(expand("%:h").'/'.expand("%:t:r"), "/", ".", "g")
    endif
    return ''
endfunction

let $FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
" --exclude .git

"nnoremap <leader>ta :!python manage.py test<CR>
"nnoremap <leader>tt :!python manage.py test <C-r>=GetRightTestFile()<CR><CR>
"
nnoremap <leader>cf :let @" = expand("%:p")<cr>
nnoremap <leader>ta :MarkAndSaveTestAll<CR>
nnoremap <leader>tm :MarkAndSaveTest <CR>
nnoremap <leader>tt :RunSavedCommand <CR>

nnoremap <leader>j /<cursor><CR>df>i
nnoremap <leader>tc :RunCoverage  <CR>
nnoremap <C-P> :FZF<CR>
nnoremap <silent> <Leader>f :Ag <C-R><C-W><CR>

"nnoremap <leader>ta :!python -m unittest discover tests <CR>
"nnoremap <leader>tt :!python -m unittest <C-r>=GetRightTestFile()<CR><CR>

nnoremap <leader>i :call tlib#cmd#BrowseOutputWithCallback('InsertThing','ListAutoAdds')<CR>
nnoremap <leader>nt :Vexplore<CR>

nnoremap <leader>cc :!python <CR>


let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

set nocompatible
set autoread
set antialias


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
    "autocmd!
    "autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END

set history=1000
set undolevels=10000
set wildignore=*.swp,*.bak,*.pyc,*.class ",*/node_modules/*,*DS_Store/*,*git/*,*env/*,db/migrate/*.rb,vendor/*
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

au BufWritePre * :%s/\s\+$//e


autocmd FileType ruby,cucumber,haml,yaml,lettuce,qml,eruby,html,htmldjango,javascript setlocal expandtab shiftwidth=2 softtabstop=2 foldlevel=999
autocmd FileType python,markdown,css,scss,php setlocal expandtab shiftwidth=4 softtabstop=4
"autocmd FileType javascript setlocal foldlevel=999
"autocmd FileType javascript call JavaScriptFold()
"autocmd BufWritePre * CreateInits
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
"let g:airline_theme='luna'
let g:airline_theme = "hybrid"

"nnoremap <leader>t :w<CR>:!rspec<CR>
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/tlib_vim
let g:tlib#input#filter_mode = 'fuzzy'
let g:buffergator_show_full_directory_path=0

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|env'

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25


let g:gitgutter_realtime=1

"t
"runtime! plugin/default.vim
"set norelativenumber
"
"function! PInsert2(item)
"	let @z=a:item
"	norm "zp
"	call feedkeys('a')
"endfunction
"
"function! CompleteInf()
"	let nl=[]
"	let l=complete_info()
"	for k in l['items']
"		call add(nl, k['word']. ' : ' .k['info'] . ' '. k['menu'] )
"	endfor
"	call fzf#vim#complete(fzf#wrap({ 'source': nl,'reducer': { lines -> split(lines[0], '\zs :')[0] },'sink':function('PInsert2')}))
"endfunction
"
"imap <c-'> <CMD>:call CompleteInf()<CR>
"
"set statusline+=%#warningmsg#
"
runtime! plugin/default.vim
set norelativenumber
