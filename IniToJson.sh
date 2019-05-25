#!/usr/bin/env bash
#Author: Narges Ahmadi (NarcisLinux)  Email:n.sedigheh.ahmadi@gmail.com
#Vertion 1
#
#Convert ini to json.
#
#############Variables#############
LineNumber=1
#EndLine=            //assigned value in code
FilenameIni=$1
FilenameIniWithOutCom=$(mktemp /tmp/IniToJson.XXXXXX)
#############Trap#############
trap "rm -rf /tmp/IniToJson*;exit" 0 2 15
#--------------Primary code--------------#
#

cat $FilenameIni |grep -v "^#" |grep -v "^;"|grep -v "^$"  > $FilenameIniWithOutCom
EndLine=$(wc -l < $FilenameIniWithOutCom)

echo "{"
while read i
do
  if [[ $i == [* ]]
  then
    echo "$i" | sed 's/\[\(.*\)\]/\  "\1":{/g' && LineNumber=$((LineNumber+1))
    if [[ $(($LineNumber-1)) == $EndLine ]]
    then
       echo "  }"
    fi
  else

    if [[ ! $(echo $i |grep "=")  ]]
    then
        echo -e "IniToJson: \e[31mError\e[0m Line $LineNumber, what's the meaning of '$i'!"
        exit
    elif [[ -z $(echo $i | sed 's/\(.*\)=\(.*\)/\2/') ]]
    then
        echo -e "IniToJson: \e[31mError\e[0m Line $LineNumber, '$i' has no value!"
        exit
    fi

    if [[ $( sed -n $((LineNumber+1))p $FilenameIniWithOutCom ) == [* ]] ||  [[ $LineNumber == $EndLine ]]
    then
        echo "$i" |sed 's/"/\\"/g' |sed 's/\(.*\)=\(.*\)/        "\1": "\2"/' && LineNumber=$((LineNumber+1))

        if [[ $(($LineNumber-1)) == $EndLine ]]
        then
            echo "  }"
        else
            echo "  },"
        fi

    else
        echo $i |sed 's/"/\\"/g' | sed 's/\(.*\)=\(.*\)/        "\1": "\2",/' && LineNumber=$((LineNumber+1))
    fi

  fi
done < $FilenameIniWithOutCom

echo "}"

#
#--------------end--------------#