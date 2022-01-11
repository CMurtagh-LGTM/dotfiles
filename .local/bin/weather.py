import json
import sys

import dateutil.parser

from weather_api import WeatherApi

loc = 'newcastle+nsw'
w = WeatherApi(search=loc, debug=0)

location = w.location()

# check if the search produced a result (other methods will also return None if the search fails).
if location is None:
    sys.exit('Search failed for location ' + loc)

print("{\"acknowedgment\":", end="")
print("\"", w.acknowedgment, "\"", sep="", end="")
print(", ", end="")

print("\"location\": ", end="")
print(json.dumps(location), end="")
print(", ", end="")

# for warn in w.warnings():
#    print(f"Warning short title:  {warn['short_title']}")
#    warning = w.warning(id=warn['id'])
#    print(f"Warning title:        {warning['title']}")

print("\"now\": ", end="")
print(json.dumps(w.observations()), end="")
print(", ", end="")

forecast = w.forecasts_daily()[0]
if forecast["uv"]["start_time"] is not None and forecast["uv"]["end_time"] is not None:
    forecast["uv"]["start_time"] = dateutil.parser.isoparse(forecast["uv"]["start_time"]).astimezone().strftime("%I:%M%p")
    forecast["uv"]["end_time"] = dateutil.parser.isoparse(forecast["uv"]["end_time"]).astimezone().strftime("%I:%M%p")

print("\"today\": ", end="")
print(json.dumps(forecast), end="")
print("}")

sys.stdout.flush()
