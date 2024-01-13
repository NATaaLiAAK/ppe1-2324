#!/usr/bin/bash

urls="url_health_ch.txt"
word="health"
word_reg='(健康)'

regex_html='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

html_filename="dependency_ch.html"
table_head='<table style="text-align:center"><thead><tr><th>N</th><th>http code</th><th>URL</th><th>DumpText</th><th>Context</th></tr></thead><tbody>'
echo "$table_head" > $html_filename
# PIP=$(pip install thulac)
line_num=1
while read -r url;
do
    echo "-----------------------------------------------"
 	echo "reading url $line_num: $url";
    if [[ $url =~ $regex_html ]]
    then
        echo "url is valid. getting $url"
        RESPONSE=$(curl -ILs $url | tr -d "\r")
		CODE=$(./get_response_code.sh "$RESPONSE")
		CHARSET=$(./get_response_charset.sh "$RESPONSE")
        echo "$CODE $CHARSET"

        if [[ $CODE -eq 200 ]]
        then
            DUMP=$(w3m -cookie "$url")
            dump_file="dump/$word-$line_num.txt"
            echo "$DUMP" > $dump_file
            if [[ $CHARSET -ne "UTF-8" && $CHARSET -ne "utf-8" && $CHARSET -ne "" && -n "$DUMP" ]]
            then
                DUMP=$(echo $DUMP | iconv -f $CHARSET -t UTF-8//IGNORE)
            fi
            context_filename="contexts/$word-$line_num.txt"
            CONTEXT1=$(./tokenize_chinese.py $dump_file)
			#CONTEXT=$(echo $CONTEXT1 | egrep -io "([^ ]* ){0,10}[^ ]?$word_reg[^ ]?([^ ]* ){0,10}")
            CONTEXT=$(echo $CONTEXT1 | egrep -io "([^ ]* ){0,2}[^ ]?$word_reg[^ ]?([^ ]* ){0,2}")                   
        else
            DUMP=""
            CHARSET=""
            CONTEXT=""
	    fi
        echo "$CONTEXT" > $context_filename
        echo -e "<tr><td>$line_num</td><td>$CODE</td><td><a href=\"$url\">$url</a></td><td><a href=\"$dump_file\">Text</a></td><td><a href=\"$context_filename\">Context</a></td></tr>" >> $html_filename

    else
        echo "url is not valid. It will be skipped."
    fi
 	line_num=$((line_num+1));
done < $urls

echo "</tbody></table>" >> $html_filename
