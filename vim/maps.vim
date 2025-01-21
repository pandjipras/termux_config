" F keys
" Display Termux F keys in ~/.termux/termux.properties > extra-keys
" Quick write session with F2
map <F2> :mksession! ~/.vim_session<cr>
" And load session with F3
map <F3> :source ~/.vim_session<cr>

" Fix indentation
map <F7> gg=G<C-o><C-o>
" Toggle auto change directory
map <F8> :set autochdir! autochdir?<CR>

" Toggle display NERDTree
map <C-n> :NERDTreeToggle<CR>

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" enter 1 baris
nnoremap <CR> o<Esc>

" enter 1 baris keatas
nnoremap <S-CR> O<Esc>

" hapus char di belakang
nnoremap <BS> X

" Save
nnoremap zw :w<cr>

" save & exit
nnoremap zz :wq<cr>

" force exit
nnoremap zq :q!<esc>

" Nonaktifkan default behavior `cc` untuk menghindari konflik
nnoremap cu <Plug>NERDCommenterToggle
vnoremap cu <Plug>NERDCommenterToggle

" Keybinding untuk menghapus seluruh fungsi dengan "da"
nnoremap da d0d}

" Control-C Copy in visual mode
vmap <C-C> y

" Control-V Paste in insert and command mode
imap <C-V> <esc>pa
cmap <C-V> <C-r>0

" Window Movement
nmap <M-h> <C-w>h
nmap <M-j> <C-w>j
nmap <M-k> <C-w>k
nmap <M-l> <C-w>l

" Resizing
nmap <C-M-H> 2<C-w><
nmap <C-M-L> 2<C-w>>
nmap <C-M-K> <C-w>-
nmap <C-M-J> <C-w>+

" Insert mode movement
imap <M-h> <left>
imap <M-j> <down>
imap <M-k> <up>
imap <M-l> <right>
imap <M-f> <C-right>
imap <M-b> <C-left>

" Alt-m for a new line underneath in insert mode
imap <M-m> <esc>o

" Cycle windows
nmap <M-o> <C-W>w
vmap <M-o> <C-W>w
tmap <M-o> <esc><C-W>w
imap <M-o> <esc><C-W>w

" Command mode history
cmap <M-p> <up>
cmap <M-n> <down>
cmap <M-k> <up>
cmap <M-j> <down>

" Highlight search dissapeared
nnoremap <silent><esc> :noh<cr><esc>

" Back to normal mode from insert
inoremap jk <esc>
inoremap JK <esc>

" quick edit init.vim
nnoremap <silent>,init :tabe ~/.config/nvim/init.vim<cr>
nnoremap <silent>,so :so ~/.config/nvim/init.vim<cr>:echo 'sourced'<cr>

