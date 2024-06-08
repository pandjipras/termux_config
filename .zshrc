export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="nvim /data/data/com.termux/files/home/.config/nvim/general/maps.vim"
alias ll="ls -lah"
alias rmf="rm -rf"
alias upd="apt update && apt upgrade"
alias ins="apt install"
alias ytmp3="yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata --progress -o '/storage/emulated/0/Music/%(artist)s - %(title)s.%(ext)s'"
alias ytmp4="yt-dlp -f mp4 -o '/storage/emulated/0/Download/Ytdlp/%(title)s.%(ext)s'"

songcut() {
    local temp_output_file="_temp_output.mp3"

    for input_file in "$1"; do
        local start_time="$2"
        local end_time="$3"

        # Menambahkan tanda ":" ke waktu jika panjangnya 4 karakter
        if [ ${#start_time} -eq 4 ]; then
            start_time="${start_time:0:2}:${start_time:2:2}"
        fi

        # Mengecek apakah end_time tidak diberikan
        if [ -z "$end_time" ]; then
            ffmpeg -y -i "$input_file" -ss "$start_time" -acodec copy "${input_file%.*}_cut.mp3"
        else
            # Menambahkan tanda ":" ke waktu jika panjangnya 4 karakter
            if [ ${#end_time} -eq 4 ]; then
                end_time="${end_time:0:2}:${end_time:2:2}"
            fi

            ffmpeg -y -i "$input_file" -ss "$start_time" -to "$end_time" -acodec copy "${input_file%.*}_cut.mp3"
        fi

        # Menimpa file asli dengan hasil potongan
        mv "${input_file%.*}_cut.mp3" "$input_file"
    done
}

volup() {
    if [ -z "$1" ]; then
        echo "Usage: volup <input_file> [<output_file>] [<volume_level>]"
        return 1
    fi
    
    input_file="$1"
    output_file="${2:-volup_${input_file}}"
    volume_level="${3:-1.5}"

    if ! [[ "$volume_level" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Volume level must be a numeric value"
        return 1
    fi

    ffmpeg -i "$input_file" -filter:a "volume=$volume_level" "$output_file"
}
