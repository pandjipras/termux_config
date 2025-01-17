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

 ""auto save file ke github
"augroup autosync_github
  "autocmd!
  "" amati file *.vim, *.zshrc, *.vimrc, dan *.sh
  "autocmd bufwritepost *.vim,*.zshrc,*.vimrc,*.sh call syncwithgithub()
"augroup end

"function! syncwithgithub()
  "let repo_path = '/data/data/com.termux/files/home/termux_config'

  "" perform git pull to sync local state with remote
  "let pull_result = system('git -c ' . repo_path . ' pull origin master')
  "echo pull_result

  "" stage all modified files
  "let add_result = system('git -c ' . repo_path . ' add .')  " tambahkan semua perubahan
  "echo add_result

  "" commit the changes with a message
  "let commit_msg = 'auto-sync after saving ' . expand('%:t')
  "let commit_result = system('git -c ' . repo_path . " commit -m '" . commit_msg . "'")
  "echo commit_result

  "" push changes to github
  "let push_result = system('git -c ' . repo_path . ' push origin master')
  "echo push_result
"endfunction

"" auto save zshrc di dalam neovim
"augroup autosync_zshrc
  "autocmd!
  "" amati file .zshrc untuk autosync
  "autocmd bufwritepost *.zshrc call synczshrcwithgithub()
"augroup end

"function! synczshrcwithgithub()
  "let repo_path = '/data/data/com.termux/files/home/termux_config'

  "" print a message indicating the sync process
  "echo "syncing .zshrc to github..."

  "" copy the updated .zshrc file to the repository
  "let copy_result = system('cp ~/.zshrc ' . repo_path)
  "if v:shell_error
    "echo "failed to copy .zshrc"
    "return
  "endif

  "" perform git status check to see if there are changes
  "let status = system('git -c ' . repo_path . ' status --porcelain')
  "if status != ''
    "" stage .zshrc, commit, and push changes if any are detected
    "let add_result = system('git -c ' . repo_path . ' add .zshrc > /dev/null 2>&1')
    "let commit_result = system('git -c ' . repo_path . " commit -m 'auto-update .zshrc' > /dev/null 2>&1")
    "if v:shell_error
      "echo "failed to commit changes"
      "return
    "else
      "" display the detailed file change summary
      "let commit_details = system('git -c ' . repo_path . ' show --stat --oneline -1')
      "echo commit_details
    "endif

    "" push the changes, suppressing unnecessary output
    "let push_result = system('git -c ' . repo_path . ' push --quiet origin master')
    "if v:shell_error
      "echo "failed to push to github"
      "return
    "else
      "echo "pushed to github successfully"
    "endif
  "else
    "" no changes detected
    "echo "no changes detected in .zshrc"
  "endif
"endfunction

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
    call system('git -C ' . repo_path . ' add .zshrc > /dev/null 2>&1')
    call system('git -C ' . repo_path . " commit -m 'Auto-update .zshrc' > /dev/null 2>&1")
    
    " Dlay the detailed file change summary
    let commit_details = system('git -C ' . repo_path . ' show --stat --oneline -1')
    echo commit_details

    " Push the changes, suppressing unnecessary output
    let push_result = system('git -C ' . repo_path . ' push --quiet origin master')
    if v:shell_error
      echo "Failed to push to GitHub"
    else
      echo "Pushed to GitHub successfully"
    endif
  else
    " No changes detected
    echo "No changes detected in .zshrc"
  endif
endfunction
