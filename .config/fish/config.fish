
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/anaconda3/bin/conda
    eval /opt/anaconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/opt/anaconda3/etc/fish/conf.d/conda.fish"
        . "/opt/anaconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /opt/anaconda3/bin $PATH
    end
end
# <<< conda initialize <<<
function runcpp
    set filename (basename $argv[1] .cpp)
    g++-13 $argv[1] -o $filename && ./$filename
end
function zi
    set -l dir (find * -type d | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end
