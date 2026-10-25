i=0
while [ "$i" -le 25 ]; do
  z=/sys/class/thermal/thermal_zone$i
  ty=$(cat "$z/type")
  te=$(cat "$z/temp")
  echo "zone$i $ty $te"
  i=$((i + 1))
done
