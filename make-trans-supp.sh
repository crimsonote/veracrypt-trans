#!/bin/bash
function intercept_the_content_in_quotes(){
    #指定一个文件，从此文件提取引号内的内容。
    cat ${1} |sed 's#\"#\n&#g'|grep -v '.h$'|grep -E '"[A-Za-z0-9~!@#$%^&*<>_+-.,]'|grep -Ev '[A-Z]_[A-Z]'|sort|uniq|sed "s#\"#EN:#g;s/$/\nLOCALE:/g" 
}
function intermediate_file_for_xml(){
    [ -f "${1}" ]||(echo "${1} is not file.";return)
    locale=$(echo ${LANG}|tr '.' ' '|cut -f 1 -d ' '|tr '_' '-'|tr 'A-Z' 'a-z' )
    locale=${locale:-zh-cn}
    mkdir -p Translations/
    meso_var="$(cat "${1}"|sed "s#\&#\&amp\;#g;s#[<]#\&lt\;#g;s#[>]#\&gt\;#g"|grep -v "^ *#")"
    start_line="$(echo "${meso_var}"|grep -En '^EN:'|sed -n "1p"|cut -f 1 -d ':')"
    total_line="$(echo -n "${meso_var}"|grep -En '^EN:|^LOCALE:'|wc -l)"
    line=${start_line}
    num=1
    echo "<!--en-->" >Translations/attach-language.en.xml
    echo "<!--${locale}-->" >Translations/attach-language.${locale}.xml
    while [ "${line}" -le "${total_line}" ]
    do
	en_string="$(echo "${meso_var}"|sed -n "${line}p"|grep -E '^EN:'||error=99999999999999999999999)"
	echo "<entry lang=\"en\" key=\"MAKE_TRANS_SUPP_${num}\">${en_string}</entry>"|sed "s#EN:##g" >> Translations/attach-language.en.xml
	let line=line+1
	
	locale_string="$(echo "${meso_var}"|sed -n "${line}p"|grep -E '^LOCALE:'||error=99999999999999999999999)"
	echo "<entry lang=\"${locale}\" key=\"MAKE_TRANS_SUPP_${num}\">${locale_string}</entry>"|sed "s#LOCALE:##g" >> Translations/attach-language.${locale}.xml
	let line=line+1
	if [ -n "${error}" ]
	then
	    echo "转换时出错"
	    return 255
	fi
	echo -ne "已完成"${line}"/"${total_line}"\r"
	let num=num+1
    done
}
