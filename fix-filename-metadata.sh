#!/bin/bash

# Gunakan direktori saat ini sebagai default
DIRECTORY=$(pwd)

# Fungsi untuk mengubah string menjadi Title Case
to_title_case() {
    echo "$1" | awk '{
        # Mengubah semua kata menjadi kapital di awal
        for (i=1; i<=NF; i++) {
            $i = toupper(substr($i,1,1)) tolower(substr($i,2))
        }
        print
    }' | sed 's/\ba\|an\|the\|and\|but\|or\|for\|nor\|so\|to\|on\|at\|by\|with\|as\|in\|of\|from\|up\|down\|between\|during\|after\|before\b/\L&/g'
}

# Fungsi untuk menghapus teks dalam tanda kurung, tanda kutip dan setelah tanda |
remove_extra_text() {
    # Hapus teks dalam tanda kurung, tanda kutip, dan setelah tanda |
    echo "$1" | sed 's/ ([^)]*)//g' | sed 's/["“”]//g' | sed 's/|.*//g'
}

# Cek apakah direktori ada
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Direktori tidak ditemukan: $DIRECTORY"
    exit 1
fi

# Warna untuk output
GREEN='\033[0;32m'    # Hijau
RED='\033[0;31m'      # Merah
YELLOW='\033[1;33m'   # Kuning
NC='\033[0m'          # Tidak ada warna (reset)

# Proses semua file di direktori
for INPUT_FILE in "$DIRECTORY"/*.mp3; do
    # Pastikan file benar-benar ada
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo -e "${YELLOW}Tidak ada file MP3 di direktori: $DIRECTORY${NC}"
        exit 1
    fi

    # Ekstrak metadata
    ARTIST=$(ffprobe -v quiet -show_entries format_tags=artist -of csv=p=0 "$INPUT_FILE")
    TITLE=$(ffprobe -v quiet -show_entries format_tags=title -of csv=p=0 "$INPUT_FILE")

    # Pastikan metadata tidak kosong
    ARTIST=${ARTIST:-Unknown}
    TITLE=${TITLE:-Unknown}

    # Hapus tanda kurung, tanda kutip dan teks setelah tanda |
    TITLE=$(remove_extra_text "$TITLE")
    ARTIST=$(remove_extra_text "$ARTIST")

    # Ubah ke Title Case
    NEW_ARTIST=$(to_title_case "$ARTIST")
    NEW_TITLE=$(to_title_case "$TITLE")

    # Buat nama file baru berdasarkan metadata
    NEW_FILENAME="${DIRECTORY}/${NEW_ARTIST} - ${NEW_TITLE}.mp3"

    # Buat file sementara dengan ekstensi .mp3
    TEMP_FILE="${INPUT_FILE%.*}_temp.mp3"

    # Ganti metadata dengan ffmpeg dalam mode quiet jika metadata berbeda
    if [[ "$NEW_ARTIST" != "$ARTIST" || "$NEW_TITLE" != "$TITLE" ]]; then
        ffmpeg -v quiet -i "$INPUT_FILE" \
            -metadata artist="$NEW_ARTIST" \
            -metadata title="$NEW_TITLE" \
            -codec copy "$TEMP_FILE"

        # Cek jika file sementara berhasil dibuat
        if [[ -f "$TEMP_FILE" ]]; then
            # Gantikan file lama dengan file sementara
            mv "$TEMP_FILE" "$INPUT_FILE"

            # Ganti nama file jika nama file baru berbeda
            if [[ "$INPUT_FILE" != "$NEW_FILENAME" ]]; then
                mv "$INPUT_FILE" "$NEW_FILENAME"
                echo -e "${GREEN}File berhasil diubah menjadi: $NEW_FILENAME${NC}"
            else
                echo -e "${YELLOW}Nama file tetap: $INPUT_FILE${NC}"
            fi

            echo -e "${GREEN}Metadata berhasil diubah:${NC}"
            echo -e "${GREEN}Artis: $NEW_ARTIST${NC}"
            echo -e "${GREEN}Judul: $NEW_TITLE${NC}"
        else
            echo -e "${RED}Gagal memproses file: $INPUT_FILE${NC}"
        fi
    else
        echo -e "${YELLOW}Metadata tidak dirubah, sudah sesuai:${NC}"
        echo -e "${YELLOW}Artis: $ARTIST${NC}"
        echo -e "${YELLOW}Judul: $TITLE${NC}"
    fi
done
