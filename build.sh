# Written by Charlie on 10/17/2020
# Builds the index page for the monster drop guide

OIFS=${IFS}
IFS=$'\n'

MONSTERCSV="monsterdrops.csv"
CSV_CONTENT=`cat ${MONSTERCSV}`
HTMLFILE="index.html"

TABLE_HEADER="<tr><th>Common</th><th>Uncommon</th><th>Rare</th></tr>"
HTMLCONTENT="
<html>
<head>
<title>Trick'cord Treat 2020 Guide</title>
<link rel=\"stylesheet\" href=\"styles.css\">
</head>
<body>
<p>
	Hello my name is <a href=\"https://charlierose.dev\">Charlie</a> and I've
	built this site as a guide for the monster drops for the 
	<a href=\"https://blog.discord.com/discord-saves-halloween-7816b934c0b1\">
	Discord Trick'cord Treat 2020 Event</a>. I am in no way affiliated with
	Discord and all images are owned by them.
</p>
<hr>
"

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
	MONSTER_IMGFILE=`echo "imgs/${MONSTER_NAME}.png" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]'`

	MONSTER_HEADER="<h3>${MONSTER_NAME}</h3>"
	MONSTER_IMG="<a href=\"${MONSTER_IMGFILE}\"><img src=\"${MONSTER_IMGFILE}\" alt=\"${MONSTER_NAME} Image\"></a>"
	MONSTER_TABLE="<table>${TABLE_HEADER}<tr><td>${COMMON_ITEM}</td><td>${UNCOMMON_ITEM}</td><td>${RARE_ITEM}</td></tr></table>"

	HTMLCONTENT="${HTMLCONTENT}${MONSTER_HEADER}${MONSTER_IMG}${MONSTER_TABLE}<br>"
done

IFS=${OIFS}

HTMLCONTENT="${HTMLCONTENT}</body></html>"


echo "Done"

echo "${HTMLCONTENT}" > index.html
