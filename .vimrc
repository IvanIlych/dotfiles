"--------------------------------------------------
" NeoBundle Init

" Use 256 colors in vim
" some plugins not work without it
set t_Co=256

" Turn off filetype plugins before bundles init
filetype off
" Auto installing NeoNeoBundle
let isNpmInstalled = executable("npm")
" default path for node-modules
let s:defaultNodeModules = '~/.vim/node_modules/.bin/'
let iCanHazNeoBundle=1
let neobundle_readme=expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    if !isNpmInstalled
        echo "==============================================="
        echo "Your need to install npm to enable all features"
        echo "==============================================="
    endif
    echo "Installing NeoBundle.."
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    let iCanHazNeoBundle=0
endif

" Call NeoBundle
if has('vim_starting')
    set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand($HOME.'/.vim/bundle/'))

" Determine make or gmake will be used for making additional deps for Bundles
let g:make = 'gmake'
if system('uname -o') =~ '^GNU/'
    let g:make = 'make'
endif

" " The Silver Searcher
" if executable('ag')
"   " Use ag over grep
"   set grepprg=ag\ --nogroup\ --nocolor
" endif
"
" nnoremap K :grep! --word-regexp "<C-R><C-W>"<CR>:cw<CR>
" nnoremap <silent><C-t> :Ag<space>
nnoremap ; :
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"--------------------------------------------------
" Bundles
" Let NeoNeoBundle manage NeoNeoBundle
NeoBundle 'Shougo/neobundle.vim'

NeoBundle 'junegunn/fzf'
NeoBundle 'junegunn/fzf.vim'

NeoBundle 'arcticicestudio/nord-vim'

" Great file system explorer, it appears when you open dir in vim
" Allow modification of dir, and may other things
" Must have
NeoBundle 'scrooloose/nerdtree'

" Add smart commands for comments like:
" gcc - Toggle comment for the current line
" gc  - Toggle comments for selected region or number of strings
" Very useful
NeoBundle 'tomtom/tcomment_vim'

" Best git wrapper for vim
" But with my workflow, i really rarely use it
" just Gdiff and Gblame sometimes
NeoBundle 'tpope/vim-fugitive'

" Fix-up dot command behavior
" it's kind of service plugin
NeoBundle 'tpope/vim-repeat'

" Add usefull hotkey for operation with surroundings
" cs{what}{towhat} - inside '' or [] or something like this allow
" change surroundings symbols to another
" and ds{what} - remove them
NeoBundle 'tpope/vim-surround'

" Improved json syntax highlighting
NeoBundle 'elzr/vim-json'

" Nice statusline/ruler for vim
" NeoBundle 'vim-airline/vim-airline'
" NeoBundle 'vim-airline/vim-airline-themes'

NeoBundle 'itchyny/lightline.vim'
NeoBundle 'mengelbrecht/lightline-bufferline'
" Plugin for chord mappings
NeoBundle 'kana/vim-arpeggio'

" Puppet plugin
NeoBundle 'rodjek/vim-puppet'

" Multiple cursors
NeoBundle 'terryma/vim-multiple-cursors'

" Yaml plugin
NeoBundle 'chase/vim-ansible-yaml'

" Ctrlspace plugin
NeoBundle 'vim-ctrlspace/vim-ctrlspace'

NeoBundle 'andrewstuart/vim-kubernetes'

NeoBundle 'morhetz/gruvbox'
" NeoBundle 'chriskempson/base16-vim'
NeoBundle 'nathanaelkane/vim-indent-guides'

NeoBundle 'habamax/vim-asciidoctor'
" Some support functions used by delimitmate, and snipmate
" NeoBundle 'vim-scripts/tlib'

NeoBundle 'ctrlpvim/ctrlp.vim'

NeoBundle 'leafgarland/typescript-vim'

" Improve bookmarks in vim
" Allow word for bookmark marks, and nice quickfix window with bookmark list
" NeoBundle 'AndrewRadev/simple_bookmarks.vim'

" Snippets engine with good integration with neocomplcache
" NeoBundle 'Shougo/neosnippet'
" Default snippets for neosnippet, i prefer vim-snippets
" NeoBundle 'Shougo/neosnippet-snippets'
" Default snippets
" NeoBundle 'honza/vim-snippets'

" Dirr diff
" NeoBundle 'vim-scripts/DirDiff.vim'

" Allow autoclose paired characters like [,] or (,),
" and add smart cursor positioning inside it,
" NeoBundle 'Raimondi/delimitMate'

" NeoBundle 'Xuyuanp/nerdtree-git-plugin'



" Git gutter
" NeoBundle 'airblade/vim-gitgutter'



" Add aditional hotkeys
" Looks like i'm not using it at all
"NeoBundle 'tpope/vim-unimpaired'


" -----------------------------
"  Python IDE

" NeoBundle 'davidhalter/jedi-vim'
"
" let g:jedi#auto_initialization = 1
" set completeopt-=preview
" let g:jedi#completions_enabled = 0
" let g:jedi#auto_vim_configuration = 0
" let g:jedi#smart_auto_mappings = 0
" let g:jedi#popup_on_dot = 0
" let g:jedi#completions_command = ""
" let g:jedi#show_call_signatures = "1"
"
" NeoBundle 'ycm-core/YouCompleteMe'
" let g:ycm_auto_trigger = 0
" let g:ycm_key_invoke_completion = '<C-Space>'
" "
" NeoBundle 'lepture/vim-jinja'
"
" NeoBundle 'neomake/neomake'
"
" " NeoBundle 'majutsushi/tagbar'
" "
" " nmap <F8> :TagbarToggle<CR>
"
" NeoBundle 'mileszs/ack.vim'

" -----------------------------

call neobundle#end()

" Enable Indent in plugins
" filetype plugin indent on
" Enable syntax highlighting
syntax on
:map <F7> :if exists("g:syntax_on") <Bar>
    \   syntax off <Bar>
    \ else <Bar>
    \   syntax enable <Bar>
    \ endif <CR>
" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.

" disable annoying prompt on initial bundle install
set nomore

" fix issue when github refuse connections on initial install
let g:neobundle#install_max_processes=2

" Install all bundles on first launch
if !iCanHazNeoBundle
    NeoBundleInstall
endif

" Check new bundles on startup
NeoBundleCheck

"-------------------------
" NERDTree

" autocmd VimEnter * NERDTree

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Tell NERDTree to display hidden files on startup
let NERDTreeShowHidden=1

" Disable bookmarks label, and hint about '?'
let NERDTreeMinimalUI=1

" Do not close NERDTree when I open a file
let NERDTreeQuitOnOpen=0

" Custom characters for the tree
let g:NERDTreeDirArrowExpandable = '[+]'
let g:NERDTreeDirArrowCollapsible = '[-]'
let g:NERDTreeDirArrows = 1
" Display current file in the NERDTree ont the left
 nmap <silent> <leader>f :NERDTreeFind<CR>

 set splitright

" File associations

"-------------------------
" Fugitive

" Blame on current line
nmap <silent> <leader>gb :.Git blame<cr>
" Blame on all lines in the file
nmap <silent> <leader>b :Git blame<cr>
" Git status
nmap <silent> <leader>gst :Gstatus<cr>
" like git add
nmap <silent> <leader>gw :Gwrite<cr>
" git diff
nmap <silent> <leader>gd :Gdiff<cr>
" git commit
nmap <silent> <leader>gc :Gcommit<cr>
" git commit all
nmap <silent> <leader>gca :Gcommit -a<cr>
" git fixup previous commit
nmap <silent> <leader>gcf :Gcommit -a --amend<cr>

"-------------------------
" Relative numbers
nmap <silent> <leader>r :set rnu!<cr>

"-------------------------
" " DelimitMate
"
" " Delimitmate place cursor correctly n multiline objects e.g.
" " if you press enter in {} cursor still be
" " in the middle line instead of the last
" let delimitMate_expand_cr = 1
"
" " Delimitmate place cursor correctly in singleline pairs e.g.
" " if x - cursor if you press space in {x} result will be { x } instead of { x}
" let delimitMate_expand_space = 1
"
" " Without this we can't disable delimitMate for specific file types
" let loaded_delimitMate = 1
"
" "-------------------------
" " Solarized
"
" " if You have problem with background, uncomment this line
" " let g:solarized_termtrans=1
"

"-------------------------
" " vim-airline
"
" " Colorscheme for airline
" let g:airline_theme='nord'
" " let g:airline_theme='gruvbox'
"
" " Set custom left separator
" "let g:airline_left_sep = '▶'
" let g:airline_left_sep = ''
"
" " Set custom right separator
" let g:airline_right_sep = ''
"
" " Enable airline for tab-bar
" let g:airline#extensions#tabline#enabled = 1
"
" " Don't display buffers in tab-bar with single tab
" let g:airline#extensions#tabline#show_buffers = 1
"
" " Display only filename in tab
" let g:airline#extensions#tabline#fnamemod = ':t'
"
" " Don't display encoding
" let g:airline_section_y = ''
"
" " Don't display filetype
" "let g:airline_section_x = ''
"
" " Powerline fonts
" let g:airline_powerline_fonts = 1

" Lightline
let g:lightline                  = {}
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
set showtabline=2
"-------------------------
" Arpeggio

" map jk to escape
call arpeggio#map('i', '', 0, 'jk', '<ESC>')

" asciidoc


" Fold sections, default `0`.
let g:asciidoctor_folding = 1
"
" " Fold options, default `0`.
let g:asciidoctor_fold_options = 1
"

"--------------------------------------------------
" Colorscheme

" colorscheme gruvbox
colorscheme nord

" Setting up light color scheme
set background=dark

" set highlighting for colorcolumn
highlight ColorColumn ctermbg=darkGrey

"--------------------------------------------------
" General options

" Enable per-directory .vimrc files and disable unsafe commands in them
"set exrc secure

" Set up leader key <leader>, i use default \
"let mapleader = ','

" Buffer will be hidden instead of closed when no one display it
set hidden
set nocompatible

" Auto reload changed files
set autoread

" Always change current directory to current-editing-file dir
" set autochdir

" Indicates fast terminal connection
set ttyfast

" Set character encoding to use in vim
set encoding=utf-8

" Let vim know what encoding we use in our terminal
set termencoding=utf-8

" Which EOL used. For us it's unix
" Not works with modifiable=no
if &modifiable
    set fileformat=unix
endif

" Enable Tcl interface. Not shure what is exactly mean.
" set infercase

" Interprete all files like binary and disable many features.
" set binary


"--------------------------------------------------
" Display options

" Hide showmode
" Showmode is useless with airline
set noshowmode

" Show file name in window title
set title

" Mute error bell
set novisualbell

" Remove all useless messages like intro screen and use abbreviation like RO
" instead readonly and + instead modified
set shortmess=atI

" Enable display whitespace characters
set list

" Setting up how to display whitespace characters
set listchars=tab:⇥\ ,trail:·,extends:⋯,precedes:⋯,nbsp:~

" Wrap line only on characters in breakat list like ^I!@*-+;:,./?
" Useless with nowrap
" set linebreak

" Numbers of line to scroll when the cursor get off the screen
" Useless with scrolloff
" set scrolljump=5

" Numbers of columns to scroll when the cursor get off the screen
" Useless with sidescrollof
" set sidescroll=4

" Numbers of rows to keep to the left and to the right off the screen
set scrolloff=10

" Numbers of columns to keep to the left and to the right off the screen
set sidescrolloff=10

" Vim will move to the previous/next line after reaching first/last char in
" the line with this commnad (you can add 'h' or 'l' here as well)
" <,> stand for arrows in command mode and [,] arrows in visual mode
set whichwrap=b,s,<,>,[,],

" Display command which you typing and other command related stuff
set showcmd

" Indicate that last window have a statusline too
set laststatus=2

" Add a line / column display in the bottom right-hand section of the screen.
" Not needed with airline plugin
"set ruler

" Setting up right-hand section(ruller) format
" Not needed with airline plugin
"set rulerformat=%30(%=\:%y%m%r%w\ %l,%c%V\ %P%)

" The cursor should stay where you leave it, instead of moving to the first non
" blank of the line
set nostartofline

" Disable wrapping long string
set nowrap

" Display Line numbers
set number

" Highlight line with cursor
" set cursorline

" maximum text length at 80 symbols, vim automatically breaks longer lines
" set textwidth=80

" higlight column right after max textwidth
set colorcolumn=+1


"--------------------------------------------------
" Tab options

" Copy indent from previous line
set autoindent

" Enable smart indent. it add additional indents whe necessary
set smartindent

" Replace tabs with spaces
set expandtab

" Whe you hit tab at start of line, indent added according to shiftwidth value
set smarttab

" number of spaces to use for each step of indent
" set shiftwidth=2

" Number of spaces that a Tab in the file counts for
set tabstop=2

" Same but for editing operation (not shure what exactly does it means)
" but in most cases tabstop and softtabstop better be the same
set softtabstop=2

" Round indent to multiple of 'shiftwidth'.
" Indentation always be multiple of shiftwidth
" Applies to  < and > command
set shiftround

"--------------------------------------------------
" Search options

" Add the g flag to search/replace by default
set gdefault

" Highlight search results
set hlsearch

" Ignore case in search patterns
set ignorecase

" Override the 'ignorecase' option if the search patter ncontains upper case characters
set smartcase

" Live search. While typing a search command, show where the pattern
set incsearch

" Disable higlighting search result on Enter key
nnoremap <silent> <cr> :nohlsearch<cr><cr>

" Show matching brackets
set showmatch

" Make < and > match as well
set matchpairs+=<:>


"--------------------------------------------------
" Wildmenu

" Extended autocmpletion for commands
set wildmenu

" Autocmpletion hotkey
set wildcharm=<TAB>

"--------------------------------------------------
" Folding

" No fold closed at open file
set foldlevelstart=99
set nofoldenable

" Keymap to toggle folds with space
nmap <space> za

"--------------------------------------------------
" Edit

" Allow backspace to remove indents, newlines and old text
set backspace=indent,eol,start

" toggle paste mode on \p
set pastetoggle=<leader>p

" Add '-' as recognized word symbol. e.g dw delete all 'foo-bar' instead just 'foo'
set iskeyword+=-

" Disable backups file
set nobackup

" Disable vim common sequense for saving.
" By defalut vim write buffer to a new file, then delete original file
" then rename the new file.
set nowritebackup

" Disable swp files
set noswapfile

" Do not add eol at the end of file.
set noeol

"--------------------------------------------------
" Diff Options

" Display filler
set diffopt=filler

" Open diff in horizontal buffer
set diffopt+=horizontal

" Ignore changes in whitespaces characters
set diffopt+=iwhite

" Do not redraw in the middle of running macros/scripts
set lazyredraw
set ttyfast
"--------------------------------------------------
" CtrlSpace configuration
let g:ctrlspace_use_mouse_and_arrows=1

"--------------------------------------------------
" Hotkeys

" Open new tab
nmap <leader>to :tabnew

" Resize vertical
nmap <leader>1 :vertical resize +30<CR>
nmap <leader>2 :vertical resize -30<CR>

" Replace
nmap <leader>s :%s//<left>
vmap <leader>s :s//<left>

" Moving between splits
nmap <leader>w <C-w>w

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

func! GetSelectedText()
    normal gv"xy
    let result = getreg("x")
    return result
endfunc

noremap <C-C> :call system('clip.exe', GetSelectedText())<CR>
noremap <C-X> :call system('clip.exe', GetSelectedText())<CR>gvx

"--------------------------------------------------
" Aautocmd

" It executes specific command when specific events occured
" like reading or writing file, or open or close buffer
if has("autocmd")
    " Define group of commands,
    " Commands defined in .vimrc don't bind twice if .vimrc will reload
    augroup vimrc
    " Delete any previosly defined autocommands
    au!
        " Auto reload vim after your cahange it
        " au BufWritePost *.vim source $MYVIMRC | AirlineRefresh
        " au BufWritePost .vimrc source $MYVIMRC | AirlineRefresh

        " Restore cursor position :help last-position-jump
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
          \| exe "normal g'\"" | endif

        " Set filetypes aliases
        au BufWinEnter * if line2byte(line("$") + 1) > 100000 | syntax clear | endif
        au BufRead,BufNewFile *.json set ft=json
        " Execute python \ -mjson.tool for autoformatting *.json
        au BufRead,BufNewFile *.plaintex set ft=plaintex.tex
        " au BufRead,BufNewFile *.yaml,*.yml,*.eyaml set ft=yaml foldmethod=indent
        " au BufRead,BufNewFile *.yaml,*.yml,*.eyaml so ~/.vim/syntax/yaml.vim
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
        autocmd FileType yaml.gotexttmpl setlocal ts=2 sts=2 sw=2 expandtab foldmethod=indent

        " Auto close preview window, it uses with tags,
        " I don't use it
        autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
        autocmd InsertLeave * if pumvisible() == 0|pclose|endif

        " Disable vertical line at max string length in NERDTree
        autocmd FileType * setlocal colorcolumn=+1
        autocmd FileType nerdtree setlocal colorcolumn=""

        " Not enable Folding - it really slow on large files, uses plugin vim-javascript-syntax
        " au FileType javascript* call JavaScriptFold()
        au FileType html let b:loaded_delimitMate = 1
        au FileType handlebars let b:loaded_delimitMate = 1
        au WinNew * wincmd V

    " Group end
    augroup END

endif

