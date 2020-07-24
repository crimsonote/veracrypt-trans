#!/bin/bash
TMPFILE="$(mktemp -d)"
en_xml="Common/Language.xml"
locale=$(echo ${LANG}|cut f 1 -d '.'|tr '_' '-'|tr 'A-Z' 'a-z' )
locale_xml="Translations/Language.${locale}.xml"
key_total="$(xmllint --xpath "/VeraCrypt/localization/entry/@key" locale_xml|wc -l)"
keynum=1
function sed_code_trans(){
    sed "s#"${1}"#${2}#Ig" -i ${3}
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
	    edit_code_file_list="$(echo "${filter_result}"|cut -f 1 -d ":"|sort | uniq|tr '\n' ' ')"
	    sed_code_trans ${2} "${en_string}" "${locale_string}" ${edit_code_file_list}
	    ;;
	c|d)
	    ;;
	e|f)
	    ;;
    esac	    
}
while [ "${keynum}" -le "${ket_total:-0}" ]
do
    num_key=$(xmllint --xpath "/VeraCrypt/localization/entry[1]/@key" "${locale_xml}"|cut -f 2 -d '=')
    key_xpath="/VeraCrypt/localization/entry[@key='${num_key}']/text()"
    en_string="$(xmllint --xpath ${key_xpath} ${en_xml}|sed "s#&amp;#&#g")"
    locale_string="$(xmllint --xpath ${key_xpath} ${locale_xml}|sed "s#&amp;#&#g")"
    edit_source_file=$(grep )
    filter_result="$(grep -ir "\"$(echo "${en_string}"|sed 's#\\#\\\\#g')\"" src/* --binary-files=without-match)"
    filter_num=$(echo -n "${filter_result}"|wc -l)
    if !(echo ${en_string}|grep ' ' >/dev/null)
    then #无空格输出
	if [ "${filter_num}" -le 10 ] && [ -n  "${filter_result}" ]
	then #无空格且筛选结果小于10
	    filter=b
	    echo "[${keynum}]=============${en_string}" >> ${b}
	    echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${b}
	elif [ "${filter_num}" -gt 10 ] #无空格 大于10
	then
	    filter=d
	    echo "[${keynum}]=============${en_string}" >> ${d}
	    echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${d}
	elif  [ -z "${filter_result}" ] #无空格 无结果
	then
	    filter=f
	    echo "[${keynum}]=============${en_string}" >> ${f}
	    echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${f}
	fi 
    else
	if [ "${filter_num}" -le 10 ] && [ -n "${filter_result}" ]
	then #筛选结果小于10
	    filter=a
	    echo "[${keynum}]=============${en_string}" >> ${a}
	    echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${a}
	elif [ "${filter_num}" -gt 10 ] #大于10
	then
	    filter=c
	    echo "[${keynum}]=============${en_string}" >> ${c}
	    echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${c}
	elif  [ -z "${filter_result}" ] #无结果
	then
	    filter=e
	    echo "[${keynum}]=============${en_string}" >> ${e}
	    echo "${filter_result}" |sed "s#^#[${keynum}]=#g" >> ${e}
	fi
    fi
    echo  "${keynum}"-"${filter}""判断 "${en_string}" ,替换为 "${locale_string}""
    echo -ne "已筛选${keynum}/${key_total}\r"
    let keynum=keynum+1
done
