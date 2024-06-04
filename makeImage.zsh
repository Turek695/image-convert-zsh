# makeImage.zsh
#
# konwersja z pliku 'wzorcowego' na na pożądane z zapisem nazwa_pliku-min_rozdzielczość-skalowanie-.rozszerzenie
# np:
#   in: zsh makeImages.zsh 1 1 all-files.png
#   out: all-filters-1-1x.webp all-filters-1-2x.webp all-filters-1-1x.png all-filters-1-2x.png
#
# uruchamianie:
# skopiować do folderu z plikami obrazów źródłowych
# dodać prawo wykonywania:
#   chmod +x makeImage.zsh
# wpisać komendę:
#   zsh makeImages.zsh <imgSizeType> <imgSize> <screenWidth> <files>
# gdzie:
#   imgSizeType ('h' lub 'w') - określa który wymiar docelowy jest podany
#   imgSize (liczba) - wyświetlana szerokość obrazu do jakiej przeskalować
#   screenWidth (liczba) - rozdzielczość od jakiej obraz ma być wyświetlany
#   files - (lista plików) można wpisać całą nazwę pliku źródłowego lub selektor np '*.png'

makeImages() {
    local imgSizeType=$1
    local imgSize=$2
    local screenWidth=$3
    shift 3 # usuń dwa pierwsze argumenty z $@

    for file in "$@"; do
        makeImage $file $imgSizeType $imgSize $screenWidth
    done
}

makeImage() {
  local file=$1
  local fileName=${file%.*}
  local fileExtension=${file##*.}
  local imgSizeType=$2
  local imgSize=$3
  local screenWidth=$4

  if [[ $imgSizeType == "w" ]]; then
    convert "${file}" -resize "${imgSize}x" "${fileName}-${screenWidth}-1x.${fileExtension}"
    convert "${file}" -resize "$((imgSize * 2))x" "${fileName}-${screenWidth}-2x.${fileExtension}"
    convert "${file}" -resize "${imgSize}x" "${fileName}-${screenWidth}-1x.webp"
    convert "${file}" -resize "$((imgSize * 2))x" "${fileName}-${screenWidth}-2x.webp"
  elif [[ $imgSizeType == "h" ]]; then
    convert "${file}" -resize "x${imgSize}" "${fileName}-${screenWidth}-1x.${fileExtension}"
    convert "${file}" -resize "x$((imgSize * 2))" "${fileName}-${screenWidth}-2x.${fileExtension}"
    convert "${file}" -resize "x${imgSize}" "${fileName}-${screenWidth}-1x.webp"
    convert "${file}" -resize "x$((imgSize * 2))" "${fileName}-${screenWidth}-2x.webp"
  else
    echo "nieprawidłowy parametr"
  fi
}

makeImages $@
