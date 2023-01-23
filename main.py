#!/usr/bin/env python3
import requests
import json

with open("/var/lib/hypixel-tracker/settings.txt", "r") as file:
  lines = file.readlines()
  webhook_url = lines[0].rstrip()
  hypixel_key = lines[1].rstrip()
  target_uuid = lines[2].rstrip()
  username = lines[3].rstrip()

try:
  open("/tmp/stalker", "r").close()
except:
  open("/tmp/stalker", "x").close()

with open("/tmp/stalker", "r") as file:
  try:
    previous = json.loads(file.read())
  except:
    previous = {}

  response = requests.get(f"https://api.hypixel.net/status?key={hypixel_key}&uuid={target_uuid}")
  current = json.loads(response.text)

  status = current.get("session")
  online = status.get("online")
  game_mode = status.get("gameType")

  if online != previous.get("online", False) or game_mode != previous.get("game_mode"):
    if online and previous.get("game_mode") != game_mode:
      status_string = f"{username} just went online in {game_mode}"
    else:
      status_string = f"{username} just went offline"

    webhook_data = {
      "content": status_string,
      "username": "mental institution tracker"
    }

    requests.post(webhook_url, json=webhook_data)

  previous = {
    "online": online,
    "game_mode": game_mode,
  }

with open("/tmp/stalker", "w") as file:
  file.write(json.dumps(previous))
