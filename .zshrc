export ZSH="$HOME/.oh-my-zsh"
export EDITOR="/data/data/com.termux/files/usr/bin/nvim"
export VISUAL="/data/data/com.termux/files/usr/bin/nvim"
export PATH=$HOME/bin:$PATH
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

alias r="omz reload"
alias x="exit"
alias rgr="ranger"
alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="/data/data/com.termux/files/home/nvim/init.vim"
alias nvimconfigkeymap="nvim /data/data/com.termux/files/home/.config/nvim/general/maps.vim"
alias ll="ls -lah"
alias rmf="rm -rf"
alias upd="apt update && apt upgrade && apt autoremove"
alias ytdlp_upd="pip install --upgrade yt-dlp"
alias ins="apt install"
alias yt3="yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata --sponsorblock-remove all --progress --parse-metadata 'title:(?P<title>[^-]+) - (?P<artist>[^(|]+)' -o '/storage/emulated/0/Music/%(artist,Unknown)s - %(title)s.%(ext)s'"
#alias yt4="yt-dlp -f mp4 -o '/storage/emulated/0/Download/Ytdlp/%(title)s.%(ext)s'"
alias yt4="yt-dlp -f 'bestvideo+bestaudio' --merge-output-format mp4 -o '/storage/emulated/0/Download/Ytdlp/%(title)s.%(ext)s'"
yt4cut() {
    if [ $# -lt 3 ]; then
        echo "Usage: yt4cut URL START_TIME END_TIME"
        echo "Example: yt4cut https://youtu.be/example 00:30 01:00"
        return 1
    fi

    URL=$1
    START_TIME=$2
    END_TIME=$3

    yt-dlp -f "bestvideo[height<=1080]+bestaudio/best" \
           --recode-video mp4 \
           --audio-quality 0 \
           --download-sections "*${START_TIME}-${END_TIME}" \
           -o "/storage/emulated/0/Download/Ytdlp/%(title)s_%(section_start)s-%(section_end)s.%(ext)s" \
           "$URL"
}
git-upload() {
    cd ~/termux_config || return

    # Menambahkan semua file ke staging
    git add .

    # Mengecek status Git untuk menentukan apakah ada perubahan
    if [[ $(git status --porcelain) ]]; then
        # Menampilkan daftar file yang ditambahkan atau diubah
        echo "Berikut adalah file yang akan di-commit:"
        git status --porcelain | awk '{print $2}' # Menampilkan nama file

        # Meminta input pesan commit dari pengguna
        echo "Masukkan pesan commit (tekan ENTER untuk default 'auto'): "
        read message

        # Menggunakan pesan commit default jika tidak ada input
        message="${message:-auto}"

        # Melakukan commit
        git commit -m "$message"
        git push origin # Ganti 'main' dengan branch yang sesuai jika perlu
    else
        echo "Tidak ada perubahan yang terdeteksi"
    fi
}

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

vidcut() {
    if [[ $# -ne 3 ]]; then
        echo "Usage: vidcut <filename> <start_time> <end_time>"
        echo "Example: vidcut video.mp4 0030 0060"
        return 1
    fi

    input_file="$1"
    start_time="${2:0:2}:${2:2:2}" # Mengubah format waktu dari 0030 menjadi 00:30
    end_time="${3:0:2}:${3:2:2}"   # Mengubah format waktu dari 0060 menjadi 00:60
    output_file="output_${2}_${3}.mp4"

    if [[ ! -f $input_file ]]; then
        echo "File $input_file tidak ditemukan!"
        return 1
    fi

    ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" -c copy "$output_file"
    echo "Video berhasil dipotong: $output_file"
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

perbandingan_harga() {
    # Fungsi untuk menghitung harga per 1 gram/ml
    calculate_price_per_unit() {
        local price=$1
        local weight=$2
        echo "scale=2; $price / $weight" | bc
    }

    # Input harga, berat, dan nama produk A
    echo "Masukkan harga, berat, dan nama produk A (contoh: 100000 250 Produk A):"
    read price_a weight_a name_a
    if [ -z "$name_a" ]; then
        name_a="Produk A"  # Default label jika nama tidak diberikan
    fi

    # Input harga, berat, dan nama produk B
    echo "Masukkan harga, berat, dan nama produk B (contoh: 5500 500 Produk B):"
    read price_b weight_b name_b
    if [ -z "$name_b" ]; then
        name_b="Produk B"  # Default label jika nama tidak diberikan
    fi

    # Hitung harga per unit
    price_per_unit_a=$(calculate_price_per_unit $price_a $weight_a)
    price_per_unit_b=$(calculate_price_per_unit $price_b $weight_b)

    # Tampilkan hasil
    echo "Harga per gram/ml $name_a: Rp $price_per_unit_a"
    echo "Harga per gram/ml $name_b: Rp $price_per_unit_b"

    # Membandingkan kedua harga dan menghitung perbedaan persentase
    if (( $(echo "$price_per_unit_a < $price_per_unit_b" | bc -l) )); then
        difference=$(echo "scale=2; (($price_per_unit_b - $price_per_unit_a) / $price_per_unit_b) * 100" | bc)
        echo
        echo "$name_a lebih murah dari $name_b sebesar $difference%."
    elif (( $(echo "$price_per_unit_a > $price_per_unit_b" | bc -l) )); then
        difference=$(echo "scale=2; (($price_per_unit_a - $price_per_unit_b) / $price_per_unit_a) * 100" | bc)
        echo
        echo "$name_b lebih murah dari $name_a sebesar $difference%."
    else
        echo
        echo "Kedua produk memiliki harga yang sama per gram/ml."
    fi
}

tabungan() {
  while true; do
    # Meminta input per hari menabung dan nominal tabungan
    echo -n "Tabungan per hari (ketik tanpa ribuan): "
    read per_hari

    echo -n "Nominal yang akan ditabung (ketik tanpa ribuan): "
    read nominal

    # Mengkonversi input singkatan menjadi angka
    nominal=$(echo $nominal | sed 's/jt/*1000000/g' | sed 's/rb/*1000/g' | bc)
    
    # Menghitung jumlah hari yang diperlukan
    total_hari=$(echo "$nominal / $per_hari" | bc)

    # Menghitung durasi dalam tahun, bulan, dan hari
    tahun=$((total_hari / 365))
    sisa_hari=$((total_hari % 365))
    bulan=$((sisa_hari / 30))
    hari=$((sisa_hari % 30))

    # Menampilkan hasil
    hasil=""
    if (( tahun > 0 )); then
      hasil="${tahun} tahun "
    fi
    if (( bulan > 0 )); then
      hasil="${hasil}${bulan} bulan "
    fi
    if (( hari > 0 )); then
      hasil="${hasil}${hari} hari"
    fi

    echo "Hasil: ${hasil}"
    echo
    # Mengulang proses
    echo "Tekan Ctrl+C untuk keluar atau tekan Enter untuk melanjutkan."
    read
  done
}

perkiraan_pemakaian_battery() {
    # Input watt
    echo "Masukkan daya beban (Watt):"
    read watt
    
    # Input volt dan aH dalam satu baris
    echo "Masukkan voltase baterai dan kapasitas baterai (Volt aH):"
    read volt ah

    # Menghitung total kapasitas energi baterai dalam watt-hour (Wh)
    total_energy=$(echo "$volt * $ah" | bc)

    # Menghitung berapa lama baterai bisa bertahan (jam)
    usage_time=$(echo "scale=2; $total_energy / $watt" | bc)

    # Output hasil
    echo "Baterai akan bertahan selama: $usage_time jam."
}

hitung_kwh() {
  local waktu_penggunaan jam_penggunaan daya kwh biaya_per_kwh total_biaya total_kwh
  
  echo "Masukkan daya perangkat (dalam Watt): "
  read daya
  echo "Masukkan durasi penggunaan (dalam jam): "
  read jam_penggunaan
  
  # Menghitung penggunaan kWh
  kwh=$(echo "scale=2; $daya * $jam_penggunaan / 1000" | bc)  # Mengonversi Watt ke kWh, dengan 2 angka di belakang koma
  
  biaya_per_kwh=1400
  total_biaya=$(echo "scale=2; $kwh * $biaya_per_kwh" | bc)  # Menghitung total biaya dengan 2 angka di belakang koma
  
  printf "Total penggunaan kWh: %.2f kWh\n" "$kwh"
  printf "Total biaya: Rp %.2f\n" "$total_biaya"
}



neofetch
