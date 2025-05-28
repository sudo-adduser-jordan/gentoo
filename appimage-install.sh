#!/bin/bash

APPIMAGE_FILE=$(realpath $1)

[[ $APPIMAGE_FILE == *.AppImage ]] || (echo "File doesn't have AppImage extension" && exit 1)

TEMPDIR=$(mktemp -d)

function unpack_and_install() {
    $APPIMAGE_FILE --appimage-extract 'usr/share/icons/*' > /dev/null
    cp -r squashfs-root/usr/share/icons/* ~/.local/share/icons/
    $APPIMAGE_FILE --appimage-extract '*.desktop' > /dev/null
    APPIMAGE_DESKTOP_FILE=$(find squashfs-root -type f -iname '*.desktop')
    sed -e "s/Exec=AppRun --no-sandbox %U/Exec=\/home\/${USER}\/.local\/bin\/$(basename $APPIMAGE_FILE)/" -i $APPIMAGE_DESKTOP_FILE
    cp $APPIMAGE_DESKTOP_FILE ~/.local/share/applications
    cp $APPIMAGE_FILE ~/.local/bin/
}

(cd $TEMPDIR; unpack_and_install; cd /; rm -r $TEMPDIR)