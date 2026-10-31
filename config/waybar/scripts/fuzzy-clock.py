#!/usr/bin/env python3

from datetime import datetime, timedelta
import json

now = datetime.now()
remainder = now.minute % 5
if remainder < 3:
    rounded = now - timedelta(minutes=remainder)
else:
    rounded = now + timedelta(minutes=(5 - remainder))

rounded = rounded.replace(second=0, microsecond=0)

print(json.dumps({
    "text": rounded.strftime("%H:%M"),
    "tooltip": now.strftime("%H:%M:%S")
}))
