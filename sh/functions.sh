#!/bin/bash

# Check if a command exists in PATH
# $1: command
function exists {
	[[ -z "$1" ]] && echo "Usage: exists <command>" && return
	[[ -x "$(command -v "$1")" ]] && return 0 || return 1
}

# Create and cd into a directory
# $1: dir
function mkcd {
	[[ -z "$1" ]] && echo "Usage: mkcd <dir>" && return
	mkdir -p "$1"
	cd "$1" || return
}

# Update packages and dotfiles
function upd {
	function up_dot {
		echo "Updating dotfiles..."
		DOTFILES="$HOME/dotfiles"
		git -C "$DOTFILES" fetch
		if [[ $(git -C "$DOTFILES" rev-parse HEAD) == $(git -C "$DOTFILES" rev-parse @\{u\}) ]]; then
			echo "No updates to pull"
		else
			git -C "$DOTFILES" pull --rebase --autostash
			echo "Dotfiles updated"
		fi
	}
	function up_pkg {
		echo "Updating packages..."
		echo "Updating system packages..."
		yay -Syu --noconfirm
		echo "Updating rust packages..."
		if exists rustup; then
			rustup update
			cargo install-update -a
		fi
		echo "Updating node packages..."
		if exists npm; then
			npm update --global --latest
		fi
		echo "Updating rye..."
		if exists rye; then
			rye self update
		fi
	}
	function up_all {
		up_dot
		up_pkg
	}

	[[ $# -eq 0 ]] && up_all
	while getopts :adph opt; do
		case $opt in
		a) up_all ;;
		d) up_dot ;;
		p) up_pkg ;;
		h)
			echo "Updater

Usage: upd [OPTIONS]

Options:
  -a  Update all (default)
  -d  Update dotfiles
  -p  Update packages"
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			echo "Run 'upd -h' for help"
			;;
		esac
	done
}

# Find listening ports
# $1: port
function port() {
	[[ -z "$1" ]] && echo "Usage: port <port>" && return
	ss -tulnp | grep "$1" | trim
}

# Load environment variables from file
# Defaults to .env in current directory
# $1: path to env file
function loadenv {
	env_file="${1:-.env}"
	if [[ -f "$env_file" ]]; then
		while IFS= read -r line; do
			if [[ -n "$line" ]] && [[ "$line" != \#* ]]; then
				line=$(echo "$line" | xargs | sed -e "s/^['\"]//" -e "s/['\"]$//")
				export "${line?}"
			fi
		done <"$env_file"
		echo "$env_file loaded"
	else
		echo "$env_file not found"
	fi
}

# Clone a git repository and cd into it
# $1: repo url
function gcl {
	[[ -z "$1" ]] && echo "Usage: gcl <repo_url>" && return
	git clone --recurse-submodules "$1" && cd "$(basename "$1" .git)" || return
}

# Encrypt a file using gpg
# $1: recipient public key
# $2: input file
# #3?: output file (default = "encrypted.gpg")
function gpgenc {
	[[ -z "$1" ]] || [[ -z "$2" ]] && echo "Usage: gpgenc <public_key> <input_file> <output_file?>" && return
	output_file="${3:-encrypted}.gpg"
	gpg --encrypt --recipient "$1" --output "$output_file" "$2"
}

# Decrypt a file using gpg
# $1: input file
# #2?: output file (default = "decrypted")
function gpgdec {
	[[ -z "$1" ]] && echo "Usage: gpgdec <input_file> <output_file?>" && return
	output_file="${2:-decrypted}.txt"
	gpg --output "$output_file" --decrypt "$1"
}

# Update grub
function upgrub {
	sudo grub-mkconfig -o /boot/grub/grub.cfg
}

# Burn an ISO to a disk
# $1: disk name
# $2: path to iso
function burniso {
	[[ -z "$1" ]] || [[ -z "$2" ]] && echo "Usage: burniso <disk_name> <path_to_iso>" && return

	disk_name="$1"
	path_to_iso="$2"

	sudo dd bs=4M if="$path_to_iso" of="$disk_name" status=progress oflag=sync
}

# Reformat a drive
# $1: disk name
function reformat {
	[[ -z "$1" ]] && echo "Usage: reformat <disk_name>" && return

	disk_name="$1"
	disk_partition="$1"1

	# wipe all data
	sudo wipefs --all "$disk_name"

	# create partition
	# gpt -> new -> enter -> write -> yes -> quit
	sudo cfdisk "$disk_name"

	# format partition
	sudo mkfs.vfat "$disk_partition"
}
