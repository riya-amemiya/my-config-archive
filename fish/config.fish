if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path /opt/homebrew/bin
end
starship init fish | source
fish_add_path --prepend /usr/local/bin
set -x GOPATH $HOME/go
fish_add_path $GOPATH/bin
fish_add_path $HOME/.cargo/bin
set -gx LDFLAGS -L/opt/homebrew/opt/llvm/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/llvm/include
set -gx LDFLAGS -L/opt/homebrew/opt/libffi/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/libffi/include
fish_add_path /opt/homebrew/opt/grep/libexec/gnubin
set -gx LDFLAGS -L/opt/homebrew/opt/bzip2/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/bzip2/include
fish_add_path $HOME/Library/Android/sdk/platform-tools

# anyenv
fish_add_path $HOME/.anyenv/bin
# eval (anyenv init - | source)
anyenv init - fish | source

fish_add_path $HOME/fvm/default/bin
status --is-interactive; and rbenv init - fish | source
set -x PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source
set -x NODE_VERSION (node -v | string replace -r '^v' '')
fish_add_path $NODENV_ROOT/versions/$NODE_VERSION/bin

set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"
set -gx LDFLAGS -L/opt/homebrew/opt/mysql-client/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/mysql-client/include

# ghq + fzf
function ghq_fzf_repo -d 'Repository search'
    ghq list --full-path | fzf --reverse --height=100% | read select
    [ -n "$select" ]; and cd "$select"
    echo " $select "
    commandline -f repaint
end

# fish key bindings
function fish_user_key_bindings
    bind \cg ghq_fzf_repo
end
set -gx CPPFLAGS -I/opt/homebrew/opt/openjdk/include

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

#alias
alias all-upgrade='brew update && brew upgrade && magic self-update && anyenv update && rustup update && cargo install-update -a && npm update -g && brew autoremove'
alias make='gmake'
alias ccusage='bunx ccusage@latest'
alias ccusage-pull='cd ~/.claude && git pull origin main && bunx ccusage@latest'

alias claude="~/.claude/local/claude"

fish_add_path ~/.modular/binmagic completion | source

string match -q "$TERM_PROGRAM" kiro and . (kiro --locate-shell-integration-path fish)
