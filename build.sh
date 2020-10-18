# Written by Charlie on 10/17/2020
# Builds the index page for the monster drop guide

OIFS=${IFS}
IFS=$'\n'

MONSTERCSV="monsterdrops.csv"
CSV_CONTENT=`cat ${MONSTERCSV}`
HTMLFILE="index.html"

TABLE_HEADER="<tr><th>Common</th><th>Uncommon</th><th>Rare</th></tr>"
HTMLCONTENT="
<html prefiix\"og: https://ogp.me/ns#\">
<head>
<title>Trick'cord Treat 2020 Guide</title>
<link rel=\"stylesheet\" href=\"styles.css\">
<link rel=\"icon\" type=\"image/x-icon\" href=\"favicon.ico\">
<meta propety=\"og:title\" content=\"Trick'cord Treat 2020 Guide\">
<meta propety=\"og:type\" content=\"image/png\">
<meta propety=\"og:url\" content=\"https://charlierosec.github.io/trickcordtreat_guide/\">
<meta propety=\"og:image\" content=\"indexscreenshot.png\">

</head>
<body>
<h1>Trick'cord Treat 2020 Monster Drop Guide</h1>
<p>
	Hello my name is <a href=\"https://charlierose.dev\">Charlie</a> and I've
	built this site as a guide for the monster drops for the 
	<a href=\"https://blog.discord.com/discord-saves-halloween-7816b934c0b1\">
	Discord Trick'cord Treat 2020 Event</a>. I am in no way affiliated with
	Discord and all images are owned by them.
</p>
<hr>
<h2>Quick Nav</h2>
"
MONSTERCONTENT=" "

NAV_TABLE="<table>"
NAV_WIDTH=4
CURR_TD=1

echo "Building ${HTMLFILE} from ${MONSTERCSV}"

HEADING=0
for LINE in ${CSV_CONTENT}
do
	# Skip the header line in the csv file
	if [ ${HEADING} = 0 ]
	then
		HEADING=1
		continue
	fi

	MONSTER_NAME=`echo "${LINE}" | awk -F , '{print $1}'`
	COMMON_ITEM=`echo "${LINE}" | awk -F , '{print $2}'`
	UNCOMMON_ITEM=`echo "${LINE}" | awk -F , '{print $3}'`
	RARE_ITEM=`echo "${LINE}" | awk -F , '{print $4}'`
	MONSTER_NAMEEDIT=`echo "${MONSTER_NAME}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]'`
	MONSTER_IMGFILE="imgs/${MONSTER_NAMEEDIT}.png"

	MONSTER_HEADER="<h2 id=\"${MONSTER_NAMEEDIT}\">${MONSTER_NAME}</h2>"
	MONSTER_IMG="<a href=\"${MONSTER_IMGFILE}\"><img src=\"${MONSTER_IMGFILE}\" alt=\"${MONSTER_NAME} Image\"></a>"
	MONSTER_TABLE="<table>${TABLE_HEADER}<tr><td>${COMMON_ITEM}</td><td>${UNCOMMON_ITEM}</td><td>${RARE_ITEM}</td></tr></table>"

	MONSTERCONTENT="${MONSTERCONTENT}${MONSTER_HEADER}${MONSTER_IMG}${MONSTER_TABLE}<hr>"

	MONSTER_LINK="<td><a href=\"#${MONSTER_NAMEEDIT}\">${MONSTER_NAME}</a></td>"
	NAV_TABLE="${NAV_TABLE}${MONSTER_LINK}"

	if [ ${CURR_TD} -lt ${NAV_WIDTH} ]
	then
		CURR_TD=$(( CURR_TD + 1 ))
	else
		CURR_TD=1
		NAV_TABLE="${NAV_TABLE}</tr><tr>"
	fi

done

IFS=${OIFS}


NAV_TABLE="${NAV_TABLE}</tr></table>"
HTMLCONTENT="${HTMLCONTENT}${NAV_TABLE}<hr>${MONSTERCONTENT}</body></html>"


echo "Done"

echo "${HTMLCONTENT}" > index.html
