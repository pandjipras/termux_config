if empty(glob('~/.config/nvim/autoload/plug.vim'))
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/autoload/plugs')

  " Themes
  Plug 'joshdick/onedark.vim'
  Plug 'morhetz/gruvbox'
  Plug 'lifepillar/vim-gruvbox8'
  Plug 'ayu-theme/ayu-vim'

  " statusline
  Plug 'itchyny/lightline.vim'

  " VS Code like intellisense and language-servers
  Plug 'neoclide/coc.nvim'

  " Auto pairs for (), [], "", '', {}
  Plug 'jiangmiao/auto-pairs'

  " for better syntax highlighting
  Plug 'sheerun/vim-polyglot'
  "Plug 'uiiaoo/java-syntax.vim' " for java

  " FUZZY FINDER file finder
  Plug 'junegunn/fzf'

  " NERDTree file explorer
  Plug 'preservim/nerdtree'

  " Dev icons displays file's icons
  Plug 'ryanoasis/vim-devicons'

  " git tracker plugin
  Plug 'airblade/vim-gitgutter'

  " indent line
  Plug 'Yggdroot/indentLine'

  " nerd commenter
  Plug 'preservim/nerdcommenter'

  " vim fugitive
  Plug 'tpope/vim-fugitive'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" auto save file ke github
augroup autosync_github
  autocmd!
  " Amati file *.vim, *.zshrc, *.vimrc, dan *.sh
  autocmd BufWritePost *.vim,*.zshrc,*.vimrc,*.sh call SyncWithGithub()
augroup END

function! SyncWithGithub()
  let repo_path = '/data/data/com.termux/files/home/termux_config'

  " Perform git pull to sync local state with remote
  let pull_result = system('git -C ' . repo_path . ' pull origin master')
  echo pull_result

  " Stage all modified files
  let add_result = system('git -C ' . repo_path . ' add .')  " Tambahkan semua perubahan
  echo add_result

  " Commit the changes with a message
  let commit_msg = 'Auto-sync after saving ' . expand('%:t')
  let commit_result = system('git -C ' . repo_path . " commit -m '" . commit_msg . "'")
  echo commit_result

  " Push changes to GitHub
  let push_result = system('git -C ' . repo_path . ' push origin master')
  echo push_result
endfunction
