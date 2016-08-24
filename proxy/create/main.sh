#!/bin/sh

/bin/echo -e "Content-type: text/html\n\n";

url=$(printf "%s" "$QUERY_STRING" | sed -e 's:&:\n:g' | grep '^url=' -i | sed -e 's:^url=::i')

decoded=$(printf "%s" "$url" | perl -pe 's/\+/ /g; s/%([0-9a-f]{2})/chr(hex($1))/eig')

printf "%s" "$decoded"

if [ -z "$decoded" ]; then
    cat proxy_homepage.html
else
    curl -L "$decoded"
fi
