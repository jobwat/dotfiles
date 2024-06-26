" https://github.com/junegunn/vim-plug/wiki/faq
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" syntax plugins
Plug 'tpope/vim-markdown', { 'for':  'markdown' }
Plug 'tpope/vim-haml', { 'for':  'haml' }
Plug 'elzr/vim-json', { 'for':  'json' }
Plug 'vim-ruby/vim-ruby', { 'for':  'ruby' }
Plug 'kchmck/vim-coffee-script', { 'for':  'coffee' }
Plug 'moll/vim-node', { 'for':  'node' }
Plug 'chase/vim-ansible-yaml', { 'for':  'yml' }
Plug 'chr4/nginx.vim', { 'for':  'nginx.conf' }
Plug 'hashivim/vim-terraform', { 'for':  'tf' }
Plug 'arzg/vim-sh'
Plug 'towolf/vim-helm'
" ruby / rails plugins
Plug 'tpope/vim-rails' " rails syntax and more
Plug 'tpope/vim-endwise' " end certain structures automatically
" fold plugins
Plug 'nelstrom/vim-markdown-folding', { 'for':  'markdown' }
" theme plugins
Plug 'jobwat/vim-railscasts-theme'
Plug 'vim-scripts/vibrantink'
" toys
Plug 'scrooloose/nerdcommenter' "toggle line comment with the same ,c shortcut whatever the language
Plug 'vim-scripts/matchit.zip' "enable easy jumps from/to matching bracket/tag
Plug 'tpope/vim-surround' "surrounding words, motion, selection with quotes or tags
Plug 'vim-scripts/upAndDown' "move selected lines up/down with option-arrows (formerly with shift)
Plug 'Townk/vim-autoclose' "auto-close brackets for you !
Plug 'tsaleh/vim-align' "helper to align things
Plug 'tpope/vim-abolish' "few Time Pope's toys, including the `Coercion` one `crc`, `crs`, `cr-`.. etc
"Plug 'dense-analysis/ale' "linting (use rubocop)
"Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parenthesis, quotes in pair.
"Plug 'tpope/vim-fugitive' "embedded git, the Tim Pope's way
"Plug 'tpope/vim-rhubarb' "enable github page browse through vim-fugitive & hub
Plug 'tpope/vim-unimpaired' "magic ]q jumps
Plug 'mileszs/ack.vim' " silversearcher via ack.vim
Plug 'bogado/file-line' "open file at line :line
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " the amazing fuzzy file search
Plug 'junegunn/fzf.vim'
if has('mac')
  Plug 'junegunn/vim-xmark' " render Markdown in browser
endif
call plug#end()

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
" Change few NerdTree shortcuts
let NERDTreeMapOpenVSplit='v'
let NERDTreeMapOpenSplit='s'
" ',;' to toggle paste mode
set pastetoggle=<leader>;
" ',cd' to change directory to the current file path
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

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

" mapping over the wonderful surround.vim plugin -- thx Tim
:vmap "" S"
:vmap '' S'

" map option-arrow to move lines up and down, to mimic VS Code comportment
nmap <M-Up> <Plug>upAndDownUp
nmap <M-Down> <Plug>upAndDownDown
imap <M-Up> <Plug>upAndDownInsertUp
imap <M-Down> <Plug>upAndDownInsertDown
vmap <M-Up> <Plug>upAndDownVisualUp
vmap <M-Down> <Plug>upAndDownVisualDown

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
set foldlevelstart=99 " set entry folding to unfolded
set laststatus=2 " Always display the status line
set tabstop=2 shiftwidth=2 expandtab " tabs are converted into 2 spaces
set wildignore=log/**,tmp/cache,BUILD/**,BUILDROOT/*,RPMS,SOURCES,*.xcodeproj/**,CordovaLib/**,www/**,*.png,*.gif,*.jpg,*.jpeg,*.ico " ignore some files (used by command-t plugin)
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep


" mapping to change vim working directory to the current file path
nnoremap <leader>cd :lcd %:p:h<CR>

" mapping Ctrl-P to FZF
nnoremap <c-p> :FZF<CR>

" associate specific extensions with specific filetypes
autocmd BufRead,BufNewFile *.es6 set filetype=javascript
autocmd BufRead,BufNewFile *.rc set filetype=sh
autocmd BufRead,BufNewFile *.go set nolist
autocmd BufWritePost *_test.go :GoTest
autocmd BufRead,BufNewFile *.hamlc,*.hamstache set filetype=haml
autocmd BufRead,BufNewFile *.json.template,*.json set filetype=json foldmethod=syntax
autocmd BufRead,BufNewFile *.yaml.template,*.yml.template set filetype=yaml foldmethod=syntax
let g:vim_json_syntax_conceal = 0 " specific to vim-json plugin (to keep the double quotes visible)
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

" Fugitive setups -  http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
" Auto-clean fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

" Auto-clean spaces
autocmd BufWritePre * :RemoveTrailingSpaces
autocmd BufWritePre * :RemoveTrailingEmptyLine

let g:ale_linters = {
      \   'ruby': ['standardrb', 'rubocop'],
      \   'python': ['flake8', 'pylint'],
      \   'javascript': ['eslint', 'prettier'],
      \   'css': ['prettier'],
      \}

let g:ale_fixers = {
      \    'ruby': ['standardrb'],
      \}
let g:ale_fix_on_save = 1

" -- some functions --

" linting status in status bar - https://www.vimfromscratch.com/articles/vim-for-ruby-and-rails-in-2019/
"function! LinterStatus() abort
  "let l:counts = ale#statusline#Count(bufnr(''))

  "let l:all_errors = l:counts.error + l:counts.style_error
  "let l:all_non_errors = l:counts.total - l:all_errors

  "return l:counts.total == 0 ? '✨ all good ✨' : printf(
        "\   '😞 %dW %dE',
        "\   all_non_errors,
        "\   all_errors
        "\)
"endfunction

"set statusline=
"set statusline+=%m
"set statusline+=\ %f
"set statusline+=%=
"set statusline+=\ %{LinterStatus()}

" Sort lines and spot duplicated ones -- https://stackoverflow.com/questions/1268032/how-can-i-mark-highlight-duplicate-lines-in-vi-editor/28690847#28690847
command! DuplicatedLines :sort | g/^\(.*\)$\n\1$/p

" Remove trailing spaces -- https://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
command! RemoveTrailingSpaces :%s/\s\+$//e

" Remove trailing empty line -- https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim
command! RemoveTrailingEmptyLine :silent! :%s#\($\n\s*\)\+\%$##

" Flip the files (handy for some logs)
command! ReverseLinesOrder :g/^/m0

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

command! BeautifyJSON :%!python -m json.tool
command! PrettyJSON :BeautifyJSON

command! PackJSON :%!jj -u
command! RePackJSON :PackJSON

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

" silver-searcher `ag` command through the ack.vim plugin - https://github.com/rking/ag.vim/issues/124#issuecomment-227038003
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack

" -- Let's stay lazy ! --

" Force write the file using sudo permissions
command! Sudow w !sudo tee % > /dev/null
" Often type W instead of w
command! W w
" Ex is not Explore only anymore... - http://stackoverflow.com/questions/14367440/map-e-to-explore-in-command-mode
command! Ex Explore
" Why not just E for Explore
command! E Ex
" And just Se and Ve for Split-Explore & Vertical-Explore
command! Se Sex
command! Ve Vex

" Show/Hide special characters (can't remember the 'list' toggle)
command! ShowSpecialCharacters set list
command! HideSpecialCharacters set nolist

" Add syntax rule
let g:ruby_heredoc_syntax_filetypes = {
        \ "xml" : {
        \   "start" : "XML",
        \},
  \}

" Base64 Encode/Decode functions and mappings
" Thanks https://stackoverflow.com/questions/26124424/sending-visual-selection-to-external-program-without-affecting-the-buffer
function! Base64enc() range
    " get selection in register n
    silent! normal gv"ny
    " base64 encode register n in var base64_string
    let base64_string = system('base64', @n)
    " Remove newlines spaces
    let base64_string = substitute(base64_string,'\n','','g')
    " Remove trailing spaces
    let base64_string = substitute(base64_string,' $','','g')
    " set the register n with base64_string
    let @n = base64_string
    " replace selection with register n
    normal! gv"npgv
endfunction
function! Base64dec() range
    " get selection in register n
    silent! normal gv"ny
    " base64 decode register n into decoded_string var
    let decoded_string = system('base64 --decode', @n)
    " set the register n with decoded_string
    let @n = decoded_string
    " replace selection with register n
    normal! gv"npgv
endfunction
xnoremap <leader>e :call Base64enc()<CR>
xnoremap <leader>d :call Base64dec()<CR>

" set autoFmt at save
let g:terraform_fmt_on_save=1

" Clean a terraform file
function! TerraformNeat() range
  " ensure format set to tf
  set ft=tf
  " reload
  e %
  " remove empty lines
  g/^$/d
  " add line breaks after each resource block
  %s/^}$/}
/
  " run fmt
  TerraformFmt
endfunction
command! Tflint call TerraformNeat()

"command! rubyOldHashToNewHash() :%s/:\(\w\+\)\(\s*=>\s*\)/\1: /gc

"https://stackoverflow.com/questions/1268032/how-can-i-mark-highlight-duplicate-lines-in-vi-editor
function! HighlightRepeats() range
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    if lineText != ""
      let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
    endif
    let lineNum = lineNum + 1
  endwhile
  exe 'syn clear Repeat'
  for lineText in keys(lineCounts)
    if lineCounts[lineText] >= 2
      exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
    endif
  endfor
endfunction

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()

" https://vi.stackexchange.com/questions/2280/how-to-show-only-matching-lines
command! FoldAllButSearch setlocal foldexpr=getline(v:lnum)=~@/?0:1 foldmethod=expr
