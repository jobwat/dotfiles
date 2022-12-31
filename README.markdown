### pre-requisite - git!

Linux:

```
    sudo apt-get install git
```

Mac: git is available by default

## Installation

```
git clone https://github.com/jobwat/dotfiles.git
cd ~/.dotfiles
git submodule update --init
rake install
```

## Later usage

### Changing shells:

    chsh -s /bin/zsh

or back to bash:

    chsh -s /bin/bash


### Vim-PLug

    vim plugins are managed through vimrc itself now, see https://github.com/junegunn/vim-plug

### Update

    rake update

### Acknowledgements

Thanks to [Rufus Post]( http://github.com/mynameisrufus/dotfiles) for the dotfiles idea !

And thx to all the coders that make this possible through their code share: [gmarik](https://github.com/gmarik/Vundle.vim), [Tim Pope](https://github.com/tpope), [Robby Russell](https://github.com/robbyrussell/oh-my-zsh) and so many more.
