#!/bin/bash
merah='\e[91m'
cyan='\e[96m'
kuning='\e[93m'
oren='\033[0;33m' 
margenta='\e[95m'
biru='\e[94m'
ijo="\e[92m"
putih="\e[97m"
normal='\033[0m'
bold='\e[1m'
labelmerah='\e[41m'
labelijo='\e[42m'
labelkuning='\e[43m'
progress(){
	gET=$(curl -skL --connect-timeout 20 --max-time 20 'https://mate07.y2mate.com/en24/analyze/ajax' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0' \
	-H 'Accept: */*' \
	-H 'Accept-Language: id,en-US;q=0.7,en;q=0.3' \
	-H 'Origin: https://www.y2mate.com' \
	-H 'Connection: keep-alive' \
	-H 'Referer: https://www.y2mate.com/en24' \
	--data "url=$1&q_auto=0&ajax=1" -L)	
	data_id=$(echo $gET | grep -Po "(?<=_id: ')[^',]*" | head -1)
	data_vid=$(echo $gET | grep -Po "(?<=v_id: ')[^']*" )
	
}
GETtitle(){
	gET=$(curl -skL --connect-timeout 20 --max-time 20 "https://www.youtube.com/watch?v=$data_vid" \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
	-H 'Accept-Language: id,en-US;q=0.7,en;q=0.3' \
	-H 'Connection: keep-alive' \
	-H 'Upgrade-Insecure-Requests: 1' \
	-H 'TE: Trailers')
	Title=$(echo $gET | grep -Po '(?<=<meta property="og:title" content=")[^">]*')
}
downloader(){
	progress $1 && GETtitle $1
	gET=$(curl -skL --connect-timeout 20 --max-time 20 'https://mate07.y2mate.com/en24/convert' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0' \
	-H 'Accept: */*' -H 'Accept-Language: id,en-US;q=0.7,en;q=0.3' \
	-H 'Origin: https://www.y2mate.com' \
	-H 'Connection: keep-alive' \
	-H 'Referer: https://www.y2mate.com/youtube/NCMPyOCuDM4' \
	-H 'TE: Trailers' \
	--data "type=youtube&_id=$data_id&v_id=$data_vid&ajax=1&ftype=mp4&fquality=$resolution")
	delete=$(echo $gET | tr -d '\\')
	geturl=$(echo $delete | grep -Po '(?<=<a href=")[^"]*')
	if [[ $geturl == '' ]]; then
		printf "Resolution $resolution Tidak Tersedia\n"
	else
		printf "${labelijo}-- Downloading --${normal} ${bold}($Title)\n"
		curl -s $geturl -o "$Title.mp4"
	fi
}
cat << "EOF"
                      .".
                     /  |
                    /  /
                   / ,"
       .-------.--- /
      "._ __.-/ o. o\
         "   (    Y  )
              )     /
             /     (
            /       Y
        .-"         |
       /  _     \    \
      /    `. ". ) /' )
     Y       )( / /(,/
    ,|      /     )
   ( |     /     /
    " \_  (__   (__        [Youtube Video Downloader - By Jasmine]
        "-._,)--._,)       [Thanks To Archie Rythm]
EOF
echo ""
read -p "List URL Youtube : " listna;
echo "Resution List : "
echo "360 - 480 - 720P - 1080"
echo -e "${merah}! Khusus 720P Silahkan Input 720P & yang Lainnya Tidak Usah Menggunakan (P)${normal}"
read -p "Resolution : " resolution;

IFS=$'\r\n' GLOBIGNORE='*' command eval 'bacot=($(cat $listna))'
waktumulai=$(date +%s)
for (( i = 0; i <"${#bacot[@]}"; i++ )); do
	WOW="${bacot[$i]}"
	IFS='' read -r -a array <<< "$WOW"
	ipx=${array[0]}
	((cthread=cthread%5)); ((cthread++==0)) && wait
	downloader ${ipx} ${resolution} &
done
wait
printf "${labelijo}-- DONE --${normal}"
