if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# This script was automatically generated by the broot function
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br
    set f (mktemp)
    broot --outcmd $f $argv
    if test $status -ne 0
        rm -f "$f"
        return "$code"
    end
    set d (cat "$f")
    rm -f "$f"
    eval "$d"
end
