#!/bin/bash
function intercept_the_content_in_quotes(){
    #指定一个文件，从此文件提取引号内的内容。
    cat ${1} |sed 's#\"#\n&#g'|grep -E '"[A-Za-z0-9&-]'|sort|uniq|sed "s#\"#EN:#g;s/$/\nLOCALE:/g" >>${2}
}
function intermediate_file_for_xml(){
    meso_file="${cat "${1}")"
    start_line="$(echo "${meso_file}"|grep -En '^EN:'|sed -n "1p"|cut -f 1 -d ':')"
    total_line=$(echo -n "${meso_file}"|grep -En '^EN:|^LOCALE:'|wc -l)
}
