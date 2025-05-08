# wrote this because my laptop keeps dying on me everytime. You should poll this script with sth like waybar.

USERNAME="atlantis"
LOW=15
CRITICAL=7

WARN_FILE=/tmp/.batt-warn-sent
BATT_STATUS=$(cat /sys/class/power_supply/BAT1/status)
BATT_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)

if [ "$BATT_STATUS" = "Discharging" ]; then
  if [ "$BATT_LEVEL" -le "$CRITICAL" ]; then
    if [ ! -f "$WARN_FILE" ]; then
      notify-send "System" "Battery critical.Suspending in 5 seconds" -i /home/"$USERNAME"/.local/share/assets/icons/nix.png -u normal
      sleep 5
      systemctl suspend
      touch "$WARN_FILE"
    fi
  elif [ "$BATT_LEVEL" -le "$LOW" ]; then
    if [ ! -f "$WARN_FILE" ]; then
      notify-send "System" "Battery low.Please plug me in kudasai" -i /home/"$USERNAME"/.local/share/assets/icons/nix.png -u normal
      touch "$WARN_FILE"
    fi
  else
    :
  fi
elif [ "$BATT_STATUS" = "Charging" ]; then
  rm -f "$WARN_FILE"
elif [ "$BATT_STATUS" = "Full" ]; then
  notify-send "System" "Battery full.Please unplug me" -i /home/"$USERNAME"/.local/share/assets/icons/nix.png -u normal
  rm -f "$WARN_FILE"
else
  :
fi
