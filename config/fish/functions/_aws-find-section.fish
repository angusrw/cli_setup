function _aws-find-section
    set -l label $argv[1]
    set -l pattern $argv[2]
    set -l cmd $argv[3..]

    set_color yellow
    echo "=== $label ==="
    set_color normal

    set -l output (aws-ai $cmd 2>&1)
    if test $status -ne 0
        set_color brblack
        if string match -q "*AccessDenied*" -- "$output"
            echo "  (access denied)"
        else
            echo "  (error: "(string split \n -- $output)[1]")"
        end
        set_color normal
        return
    end

    set -l matches (string join \n -- $output | tr '\t' '\n' | grep -iE $pattern)
    if test -z "$matches"
        set_color brblack
        echo "  (no matches)"
        set_color normal
    else
        printf "  %s\n" $matches
    end
end
