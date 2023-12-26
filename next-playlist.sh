playlists=($(mpc lsplaylists))

if [ ${#playlists[@]} -eq 0 ]; then
	echo "No playlists available."
	exit 1
fi

current_song=$(mpc current)
current_playlist=$(mpc -f %playlist% playlist | grep -Fm1 "$current_song")

index=-1
for i in "${!playlists[@]}"; do
	if [[ "${playlists[$i]}" = "$current_playlist" ]]; then
		index=$i
		break
	fi
done

if [[ $index -eq -1 ]]; then
	next_index=0
else
	next_index=$(((index + 1) % ${#playlists[@]}))
fi

mpc load "${playlists[$next_index]}"
mpc play
