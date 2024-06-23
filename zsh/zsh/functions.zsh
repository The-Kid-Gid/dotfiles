#
# Things too long for an alias and too short for a standalone script
#

# Make a new directory and enter it.
mk() {
    mkdir "$@" && cd "$@"
}

# Quickly enter a project directory.
c() {
    cd "$PROJECTS/$1"
}

# Quickly open VS Code in a project directory
v() {
    code "$PROJECTS/$1"
}

# Quickly open VS code in the current directory
vwd() {
    code $(pwd)
}

# List everything in the current directory with nice defaults
d() {
    du -h --all --max-depth 1 "$@" | sort --human-numeric-sort --reverse
}

# Start programs silently and without making them dependent on an open terminal
start() {
    nohup "$@" > /dev/null 2> /dev/null
}

# Execute a command in a specific directory
xin() {
    cd "$1"
    shift
    "${@}"
}

# Add current conda env to jupyter notebook
addtojupyter() {
    python -m pip install ipykernel
    python -m ipykernel install --user --name "$CONDA_DEFAULT_ENV" --display-name "Python ($CONDA_DEFAULT_ENV)"
}

# Remove current conda env from jupyter notebook
removefromjupyter() {
    rm ~/.local/share/jupyter/kernels/test/ -rf
}

# Create file and directories on path to file if none exist
tp() {
    mkdir -p "${1%/*}" && touch "$1"
}

# Get proper word count from LaTeX doc
latexwc() {
    if [[ $# -eq 2 ]]; then
        wc_opts="$2"
    else
        wc_opts="-w"
    fi
    detex "$1" | wc "$wc_opts"
}

## Dotfile management ##
# Update dotfiles
dfu() {
    cd "$PROJECTS/dotfiles" && git pull --ff-only && ./install
}

# Update VS Code extensions list
upext() {
    xin "$PROJECTS/dotfiles" ./script/code-export-ext && git reset > /dev/null && git stage "vscode/extensions.txt" > /dev/null && git commit -m "Update extensions list" && git push
}

# Remove from PATH
path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

# Append to PATH
path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

# Prepend to PATH
path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}
