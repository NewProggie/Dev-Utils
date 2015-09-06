#!/bin/bash
# Convenience script for dev helpers

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# assuming ./src and ./tools/share/scripts folders
SOURCE_DIR=${SCRIPT_DIR}/../../../src/
FILES_PATTERN='\.(cpp|cxx|hpp|h)?$'
SRC_FILES="$(find ${SOURCE_DIR} -name "*" | grep -E ${FILES_PATTERN})"

while getopts "ircas" opt; do
    case "$opt" in
        i)
            echo "===> Check code indentation (Astyle)"
            echo ${SRC_FILES} | xargs astyle --options=${SCRIPT_DIR}/astyle.rc
            ;;
        r)
            echo "===> Check code with clang-analyzer"
            echo ${SRC_FILES} | xargs clang -std=c++11 --analyze
            ;;
        c)
            echo "===> Check code indentation (clang-format)"
            echo ${SRC_FILES} | xargs clang-format -i -style=file
            ;;
        a)
            echo "===> Static code analysis (cppcheck)"
            CPP_OPTS=$(awk -vORS=' ' '{ print $1 }' ${SCRIPT_DIR}/cppcheck.rc)
            echo ${SRC_FILES} | xargs cppcheck ${CPP_OPTS}
            ;;
        s)
            echo "===> Similarity analyzer (simian)"
            echo ${SRC_FILES} | xargs simian -config=${SCRIPT_DIR}/simian.rc
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    echo "Params: "
    echo "-i    Check code indentation (Astyle)"
    echo "-r    Check code with clang-analyzer"
    echo "-c    Check code indentation (clang-format)"
    echo "-a    Static code analysis (cppcheck)"
    echo "-s    Similarity analyzer (simian)"
fi

exit 0

