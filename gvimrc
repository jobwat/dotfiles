" gvimrc is used by gvim under Linux but also by mvim under Mac... pain!

set guioptions-=T " hide toolbar

let s:uname = system("uname")
if s:uname == "Darwin\n"

  " Do Mac stuff here

  set guifont=Monaco:h14

  " nathanaelkane/vim-command-w specific
  macmenu &File.Close key=<nop>
  nmap <D-w> :q<CR>
  imap <D-w> <Esc>:q<CR>

else

  " Do Linux Specifc here
  set tabstop=2 shiftwidth=2 expandtab " tabs are converted into 2 spaces
  set guifont=Monospace\ 14
  colorscheme railscasts

  " forcing terminal style Copy/Paste shortcuts
  map <S-C-x> "+x
  map <S-C-c> "+y
  " map <S-C-v> "+gP
  imap <S-C-v> <Esc>"+gpi
  " forcing Mac style Copy/Paste shortcuts
  map <M-x> "+x
  map <M-c> "+y
  map <M-v> "+gP
  imap <M-v> <Esc>"+gpi
  " and other Mac style shortcuts
  map <M-w> q
  imap <M-w> q
  " Alt-S can't be mapped because it triggers the menu...
  "map <M-s> w
  "imap <M-s> w

  " Ctrl-A selects all
  map <C-a> ggVG
  imap <C-a> <Esc>ggVG
  vmap <C-a> <Esc>ggVG

  " Ctrl-S saves the current buffer
  map <C-s> :w<CR>
  imap <C-s> <Esc>:w<CR>a
  vmap <C-s> <Esc>:w<CR>gv

  " Ctrl-A selects all
  map <C-a> ggVG
  imap <C-a> <Esc>ggVG
  vmap <C-a> <Esc>ggVG

  " Ctrl-S saves the current buffer
  map <C-s> :w<CR>
  imap <C-s> <Esc>:w<CR>a
  vmap <C-s> <Esc>:w<CR>gv

endif
