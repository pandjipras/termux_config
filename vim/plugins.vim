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

" auto save zshrc di dalam neovim
augroup autosync_zshrc
  autocmd!
  " Amati file .zshrc untuk autosync
  autocmd BufWritePost *.zshrc call SyncZshrcWithGithub()
augroup END

function! SyncZshrcWithGithub()
  let repo_path = '/data/data/com.termux/files/home/termux_config'

  " Print a message indicating the sync process
  echo "Syncing .zshrc to GitHub..."

  " Copy the updated .zshrc file to the repository
  let copy_result = system('cp ~/.zshrc ' . repo_path)
  if v:shell_error
    echo "Failed to copy .zshrc"
    return
  endif

  " Perform git status check to see if there are changes
  let status = system('git -C ' . repo_path . ' status --porcelain')
  if status != ''
    " Stage .zshrc, commit, and push changes if any are detected
    let add_result = system('git -C ' . repo_path . ' add .zshrc > /dev/null 2>&1')
    let commit_result = system('git -C ' . repo_path . " commit -m 'Auto-update .zshrc' > /dev/null 2>&1")
    if v:shell_error
      echo "Failed to commit changes"
      return
    else
      " Display the detailed file change summary
      let commit_details = system('git -C ' . repo_path . ' show --stat --oneline -1')
      echo commit_details
    endif

    " Push the changes, suppressing unnecessary output
    let push_result = system('git -C ' . repo_path . ' push --quiet origin master')
    if v:shell_error
      echo "Failed to push to GitHub"
      return
    else
      echo "Pushed to GitHub successfully"
    endif
  else
    " No changes detected
    echo "No changes detected in .zshrc"
  endif
endfunction
