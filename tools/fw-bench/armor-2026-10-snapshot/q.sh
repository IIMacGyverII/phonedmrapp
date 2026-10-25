#!/system/bin/sh
echo '--- channels ---'
sqlite3 /data/data/com.macdmr.radio/databases/radio.db "SELECT number,name,type,rxFreq,txFreq,active,power FROM channels WHERE number=36 OR active=1;"
echo '--- zones ---'
sqlite3 /data/data/com.macdmr.radio/databases/radio.db "SELECT _id,name,numbers FROM zones;"
echo '--- prefs ---'
grep -E 'zone|issRepeat|iss' /data/data/com.macdmr.radio/shared_prefs/radio.xml
echo '--- history ---'
sqlite3 /data/data/com.macdmr.radio/databases/radio.db "SELECT ts,kind,text FROM history ORDER BY ts DESC LIMIT 8;"
