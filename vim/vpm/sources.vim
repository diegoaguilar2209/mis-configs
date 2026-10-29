" NERDTree
"it will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Lazy loading (on demand)
"Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
"autocmd! User goyo.vim echom 'Goyo is now loaded!'

" Others
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'MarcWeber/vim-addon-commenting'
"Plug 'vim-scripts/vcscommand.vim'
"Plug 'vim-syntastic/syntastic'
"Plug 'tomtom/tlib_vim' | Plug 'MarcWeber/vim-addon-mw-utils' | Plug 'garbas/vim-snipmate'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'kien/ctrlp.vim'

" YouCompleteMe
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !python3 install.py --java-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" Plug 'davidhalter/jedi-vim'

" XML/HTML tags navigation
Plug 'vim-scripts/matchit.zip'

" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'
Plug 'zweifisch/pipe2eval'

" Vim-markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Unmanaged plugin (manually installed and updated)
"Plug '~/myplugin'
