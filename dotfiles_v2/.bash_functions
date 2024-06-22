largest_files() {
    du -ah . | sort -rh | head -n 10
}
sudameris_upload() {
    "$SUDA"/tomcat/scripts/upload.sh
}
