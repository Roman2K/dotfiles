user_full_name() {
	local n=$(getent passwd "$USER" | cut -d: -f5 | cut -d, -f1)
	[ -n "$n" ] || {
		n=$USER
		echo "full name not set, using \"$n\" - set with usermod -c" >&2
	}
	echo $n
}
whome=/mnt/c/Users/$(user_full_name)

cbp() {
	powershell.exe -Command Get-Clipboard
}
cbc() {
	clip.exe
}

if [[ $- = *i* ]]; then
	cd whome > /dev/null
fi
