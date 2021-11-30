#!/bin/bash

#set -x

source_dir=$1

csudo=""

if command -v sudo > /dev/null; then
    csudo="sudo"
fi

[ ! -d /usr/local/taos/bin ] && mkdir -p /usr/local/taos/bin
${csudo} cp ${source_dir}/build/bin/taosdump /usr/local/taos/bin || echo -e "failed to copy taosdump"
${csudo} cp ${source_dir}/build/bin/taosdemo /usr/local/taos/bin || echo -e "failed to copy taosdemo"
${csudo} ln -sf /usr/local/taos/bin/taosdump /usr/local/bin/taosdump || echo -e "failed to link taosdump"
${csudo} ln -sf /usr/local/taos/bin/taosdemo /usr/local/bin/taosdemo || echo -e "failed to link taosdemo"

if [ -f ${source_dir}/build/lib/libavro.so.23.0.0 ];
    ${csudo} cp -rf ${source_dir}/build/lib/libavro* /usr/local/lib > /dev/null || echo -e "failed to copy avro libraries"
    ${csudo} cp -rf ${source_dir}/build/lib/pkgconfig /usr/local/lib > /dev/null || echo -e "failed to copy pkgconfig directory"
fi

if [ -f ${source_dir}/build/lib64/libavro.so.23.0.0 ];
    ${csudo} cp -rf ${source_dir}/build/lib64/libavro* /usr/local/lib > /dev/null || echo -e "failed to copy avro libraries"
    ${csudo} cp -rf ${source_dir}/build/lib64/pkgconfig /usr/local/lib > /dev/null || echo -e "failed to copy pkgconfig directory"
fi

if [ -d /etc/ld.so.conf.d ]; then
    echo "/usr/local/lib" | ${csudo} tee /etc/ld.so.conf.d/libavro.conf > /dev/null || echo -e "failed to write /etc/ld.so.conf.d/libavro.conf"
    ${csudo} ldconfig || echo -e "failed to run ldconfig"
else
    echo "/etc/ld.so.conf.d not found!"
fi
