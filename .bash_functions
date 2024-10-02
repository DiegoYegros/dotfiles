largest_files() {
    du -ah . | sort -rh | head -n 10
}
