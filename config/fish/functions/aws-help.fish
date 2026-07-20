function aws-help --description "List custom aws-* fish functions with their descriptions"
    for f in ~/.config/fish/functions/aws-*.fish
        set -l name (basename $f .fish)
        set -l desc (string match -rg '"([^"]+)"' (head -1 $f))
        if test -n "$desc"
            printf "  %-16s %s\n" $name $desc
        else
            printf "  %s\n" $name
        end
    end
end
