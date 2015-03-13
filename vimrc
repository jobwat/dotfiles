set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-rails'
"Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-haml'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kchmck/vim-coffee-script'
Plugin 'kfl62/textile.vim'
Plugin 'edsono/vim-matchit'
Plugin 'depuracao/vim-rdoc'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'dterei/VimBookmarking'
Plugin 'vim-scripts/upAndDown'
Plugin 'Townk/vim-autoclose'
Plugin 'tsaleh/vim-align'
Plugin 'godlygeek/tabular'
Plugin 'rogerz/vim-json'
Plugin 'rodjek/vim-puppet'
"Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'kien/ctrlp.vim'
"Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tpope/vim-fugitive'
Plugin 'rking/ag.vim'
"Plugin 'honza/vim-snippets'
Plugin 'bogado/file-line'
Plugin 'vim-scripts/bufkill.vim'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'vim-scripts/vibrantink'
Plugin 'joker1007/vim-ruby-heredoc-syntax'
Plugin 'chase/vim-ansible-yaml'
Plugin 'trotter/autojump.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" block vim-ruby balloon tooltips -
" http://stackoverflow.com/questions/8534055/why-am-i-getting-a-popup-message-when-i-hover-on-any-word-of-a-ruby-file
if has('noballooneval')
  set noballooneval=
  set balloonexp=
endif

" assigning a leader key and mapping some commands to it
let mapleader = ","
" ',s' to clean trailing spaces and remove tabs
map <leader>s :%s/\s\+$//e \| :%s/\t/  /ge<CR><C-o>  
" ',=' to xml re-indent
map <leader>= <Esc>:1,$!xmllint --format -<CR>
" ',l' to toggle wordwrap
nnoremap <leader>k :set invwrap wrap?<CR>
" ',d' to toggle the NERDTree
nnoremap <leader>d :NERDTreeToggle<CR>  
" ',;' to toggle paste mode
set pastetoggle=<leader>;

" ',p' put current buffer filepath to the clipboard
let s:uname = system("uname")
if s:uname == "Darwin\n"
  " Do Mac stuff here
  colorscheme railscasts
  nmap <leader>p :let @* = expand("%:.")<CR> " use ',p' to copy the current file relative path to the system clipboard
  nmap <leader>P :let @* = expand("%:p")<CR> " use ',P' to copy the current file absolute path to the system clipboard

else
  " Do Linux Specifc here (gvim)
  colorscheme vibrantink " at home(linux) I can't see shit with railscast theme...
  nmap <leader>p :!echo "%:." \|xsel -ib<CR><CR>
  nmap <leader>P :!echo "%:p" \|xsel -ib<CR><CR>
endif

" :Ack configuration
let g:ackprg="ack -H --nocolor --nogroup --column --ignore-dir log --ignore-dir tmp --ignore-dir .sass-cache --ignore-dir build"

" notepad++ style bookmarks (nobody's perfect) -- bookmarking extension
:map 22 :ToggleBookmark<CR>
:map <C-2> :NextBookmark<CR>
:map <C-@> :PreviousBookmark<CR>

" mapping over the wonderful surround.vim plugin -- thx Tim
:vmap "" S"
:vmap '' S'

" add mapping for json beautify - require CPAN module JSON::XS -- http://visibletrap.blogspot.com.au/2010/05/vim-how-to-format-and-syntax-highlight.html
map <leader>jb <Esc>:%!json_xs -f json -t json-pretty<CR>

" set options
set nocompatible " needed by some plugins
set backspace=indent,eol,start
set autoindent sw=2 et " auto-indend at new line
set copyindent " copy the previous indentation on autoindenting
set list " show special characters
set history=1000 " default is 20
set undolevels=1000 " use many muchos levels of undo
set cmdwinheight=50 " number of line of the Command Window (used by :Ack results)
set ruler " show <row>,<column> position on the right of the status bar
set wrap " word wrapping is on by default
syntax on "syntax highlighting
set nobackup       " no backup files
set ignorecase " we don't the case on the search
set hlsearch      " highlight search terms
set smartcase " in fact we do care the case unless search is all lowercased
set nowritebackup  " only in case you don't want a backup file while editing
set hidden " non-visible buffers are just hidden, not closed (keep buffer history)
set noswapfile     " no swap files
set showcmd  " display incomplete commands
set incsearch  " do incremental searching
set number    " display line numbers
set showmatch  " show matching bracket
set foldmethod=manual   " folding like a nerd
set nofoldenable    " disable folding by default
set laststatus=2 " Always display the status line
set tabstop=2 shiftwidth=2 expandtab " tabs are converted into 2 spaces
set wildignore=log/**,tmp/cache,BUILD/**,BUILDROOT/*,RPMS,SOURCES,*.xcodeproj/**,CordovaLib/**,www/**,*.png,*.gif,*.jpg,*.jpeg,*.ico " ignore some files (used by command-t plugin)
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

nnoremap K :Ag <C-R><C-W><CR>


" -- some functions --


" DoPrettyXML beautifies an XML buffer (XML must be valid)
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML :call DoPrettyXML()
command! BeautifyXML :call DoPrettyXML()

command! PrettyJSON :%!python -m json.tool
command! BeautifyJSON :%!python -m json.tool

" RePackXML de-beautify an XML buffer (compact style)
function! RePackXML()
  " remove extra space at beginning of lines
  %s/^\s\+//e
  " same for end of line spaces
  %s/\s\+$//e
  " remove end of line return
  %s/\n//e
endfunction
command! PackXML :call RePackXML()
command! RePackXML :call RePackXML()

" mapping to change the working directory to the current file path
nnoremap ,cd :lcd %:p:h<CR>

" associate specific extensions with specific filetypes
autocmd BufRead,BufNewFile *.rc set filetype=sh
autocmd BufRead,BufNewFile *.hamlc,*.hamstache set filetype=haml
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

" Delete file from current buffer - from http://vim.wikia.com/wiki/Delete_files_with_a_Vim_command
function! DeleteFile(...)
  if(exists('a:1'))
    let theFile=a:1
  elseif ( &ft == 'help' )
    echohl Error
    echo "Cannot delete a help buffer!"
    echohl None
    return -1
  else
    let theFile=expand('%:p')
  endif
  let delStatus=delete(theFile)
  if(delStatus == 0)
    echo "Deleted " . theFile
  else
    echohl WarningMsg
    echo "Failed to delete " . theFile
    echohl None
  endif
  return delStatus
endfunction
"delete the current file
com! Rm call DeleteFile()
"delete the file and quit the buffer (quits vim if this was the last file)
com! RM call DeleteFile() <Bar> q!

" Let's stay lazy !
" Force write the file using sudo permissions
command! Sudow w !sudo tee % > /dev/null
" Often type W instead of w
command! W w
" Ex is not Explore only anymore... - http://stackoverflow.com/questions/14367440/map-e-to-explore-in-command-mode
command! Ex Explore
" Often typing E instead of e"
command! E e

" Show/Hide special characters (can't remember that 'list' toggle)
command! ShowSpecialCharacters set list
command! HideSpecialCharacters set nolist

" Add syntax rule
let g:ruby_heredoc_syntax_filetypes = {
        \ "xml" : {
        \   "start" : "XML",
        \},
  \}
