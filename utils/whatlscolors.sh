# copy and paste into terminal
eval $(echo "no:global default;fi:normal;di:directory;tw:sticky other writeable;ow:other writeable"|sed -e 's/:/="/g; s/\;/"\n/g')
{
    IFS=:
    for i in $LS_COLORS
    do
        echo -e "\e[${i#*=}m$( x=${i%=*}; [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m"
    done
}
