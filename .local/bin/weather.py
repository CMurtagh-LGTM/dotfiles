import json
import sys

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

print("\"today\": ", end="")
print(json.dumps(w.forecasts_daily()[0]), end="")
print("}")

sys.stdout.flush()
