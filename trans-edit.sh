#!/bin/bash
TMPFILE="$(mktemp -td vera_transXXXXX)"
en_xml="Common/Language.xml"
locale=$(echo ${LANG}|tr '.' ' '|cut -f 1 -d ' '|tr '_' '-'|tr 'A-Z' 'a-z' )
locale_xml="../Translations/Language.${locale}.xml"
key_total="$(xmllint --xpath "/VeraCrypt/localization/entry/@key" ${locale_xml}|wc -l)"
keynum=1
function sed_code_trans(){
    en_sed_string="$(echo "${1}"|sed "s#[\][n]#[\\\][n]#g")"
    locale_sed_string="$(echo "${2}"|sed "s#[\][n]#\\\\\\\\\\\n#g")"
    sed "s#\"${1}\"#\"${2}\"#g" -i ${3}
    #echo "s#${1}#${2}#g" "-i"  "${3}"
}
function filter_code(){
    filter=${1}
    echo "[${keynum}]=============${en_string}" >> ${2}.log
    echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${2}.log
    continue_filter ${filter} "${en_string}" "${locale_string}"
}
function continue_filter(){
    case $1 in
	a|b)
	    echo "${filter_result}" >> /tmp/fulter,log
	    edit_code_file_list="$(echo "${filter_result}"|cut -f 1 -d ":"|grep -v ".cpp"|sort | uniq|tr '\n' ' ')"
	    sed_code_trans "${en_string}" "${locale_string}" ${edit_code_file_list}
	    ;;
	c|d)
	    ;;
	e|f)
	    ;;
    esac	    
}
while [ "${keynum}" -le "${key_total:-0}" ]
do
    num_key=$(xmllint --xpath "/VeraCrypt/localization/entry[${keynum}]/@key" "${locale_xml}"|cut -f 2 -d '=')
    #key_xpath="/VeraCrypt/localization/entry[@key='${num_key}']/text()"
    key_xpath="/VeraCrypt/localization/entry[@key="${num_key}"]/text()"
    en_string="$(xmllint --xpath ${key_xpath} ${en_xml}|sed "s#&amp;#\&#g"|sed 's#&lt;#<#g'|sed 's#&gt;#>#g')"
    locale_string="$(xmllint --xpath ${key_xpath} ${locale_xml}|sed "s#&amp;#\&#g"|sed "s#&lt;#<#g"|sed "s#&gt;#>#g")"
    #en_string="$(xmllint --xpath ${key_xpath} ${en_xml}|sed "s#&amp;#&#g")"
    #locale_string="$(xmllint --xpath ${key_xpath} ${locale_xml}|sed "s#&amp;#&#g")"
    #edit_source_file=$(grep )
    filter_result="$(grep -ir "\"$(echo "${en_string}"|sed 's#\\#\\\\#g')\"" * --binary-files=without-match|tr '\r' '\n')"
    filter_num=$(echo -n "${filter_result}"|wc -l)
    if !(echo ${en_string}|grep ' ' >/dev/null)
    then #无空格输出
	if [ "${filter_num}" -le 10 ] && [ -n  "${filter_result}" ]
	then #无空格且筛选结果小于10
	    filter_code b ${TMPFILE}/b.log
	    #filter=b
	    #echo "[${keynum}]=============${en_string}" >> ${b}
	    #echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${b}
	elif [ "${filter_num}" -gt 10 ] #无空格 大于10
	then
	    filter_code d ${TMPFILE}/d.log
	    #filter=d
	    #echo "[${keynum}]=============${en_string}" >> ${d}
	    #echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${d}
	elif  [ -z "${filter_result}" ] #无空格 无结果
	then
	    filter_code f ${TMPFILE}/fa.log
	    #filter=f
	    #echo "[${keynum}]=============${en_string}" >> ${f}
	    #echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${f}
	fi 
    else
	if [ "${filter_num}" -le 10 ] && [ -n "${filter_result}" ]
	then #筛选结果小于10
	    filter_code a ${TMPFILE}/a.log
	    #filter=a
	    #echo "[${keynum}]=============${en_string}" >> ${a}
	    #echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${a}
	elif [ "${filter_num}" -gt 10 ] #大于10
	then
    	    filter_code c ${TMPFILE}/c.log
	    # filter=c
	    # echo "[${keynum}]=============${en_string}" >> ${c}
	    # echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${c}
	elif  [ -z "${filter_result}" ] #无结果
	then
	    filter_code e ${TMPFILE}/e.log
	    #filter=e
	    #echo "[${keynum}]=============${en_string}" >> ${e}
	    #echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${e}
	fi
    fi
    echo  "${keynum}"-"${filter}""判断 "${en_string}" ,替换为 "${locale_string}""
    echo -ne "已筛选${keynum}/${key_total}\r"
    let keynum=keynum+1
done
mv Common/Language.xml ../Translations/Language.en.xml
cp ../Translations/Language.zh-cn.xml Common/Language.xml
