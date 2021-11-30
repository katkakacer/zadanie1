#!/bin/bash
cat << THE_END
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
</head>
<body>
THE_END

ZOZ=0

while IFS= read LINE
do
    if echo "$LINE" | grep '<https://[^>]*>' >/dev/null
    then 
        LINE=$(echo "$LINE" | sed 's@<https://\([^>]*\)>@<a href="https://\1">https://\1</a>@g')
        echo "$LINE"
        continue
    fi

    if echo "$LINE" | grep '^ - ' > /dev/null
    then
        if [ "$ZOZ" = 0 ]
        then
            echo '<ul>'
            ZOZ=1
        fi
        LINE=$(echo "$LINE" | sed 's@ - \(.*\)@<li>\1</li>@')
        echo "$LINE"
        continue
    else
        if [ "$ZOZ" = 1 ]
        then
            echo '</ul>'
        fi
    fi

    if echo "$LINE" | grep '^[[:space:]]*$' > /dev/null
    then
        echo '<p>'
        continue
    elif echo "$LINE" | grep '^# ' > /dev/null
    then
        LINE=$(echo "$LINE" | sed 's@# @@')
        echo '<h1>'"$LINE"'</h1>'
        continue
    elif echo "$LINE" | grep '^## ' > /dev/null
    then
        LINE=$(echo "$LINE" | sed 's@## @@')
        echo '<h2>'"$LINE"'</h2>'
        continue
    fi

    if echo "$LINE" | grep '\(__\)[^_]*\1' > /dev/null
    then
        LINE=$(echo "$LINE" | sed 's@__\([^_]*\)__@<strong>\1</strong>@g')
        echo "$LINE"
        continue
    fi
    if echo "$LINE" | grep '\(_\)[^_]*\1' > /dev/null
    then
        LINE=$(echo "$LINE" | sed 's@_\([^_]*\)_@<em>\1</em>@g')
        echo "$LINE"
        continue
    fi    
 
    echo "$LINE"    
    
done    

cat << THE_END
</body>
</html>
THE_END