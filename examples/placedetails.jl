using GooglePlaces

import ConfParser: ConfParse, parse_conf!, retrieve

conf = ConfParse("configs/config.ini")
parse_conf!(conf)

# get and store config parameters
appname = retrieve(conf, "app", "name")
appenv = retrieve(conf, "app", "env")
logtofile = retrieve(conf, "log", "log_to_file", Bool)
loglevel = retrieve(conf, "log", "level", Int32)
logpath = retrieve(conf, "log", "path")
key = retrieve(conf, "googleAPI", "key")
radius = retrieve(conf, "googleAPI", "radius")
rankby = retrieve(conf, "googleAPI", "rankby")

fields = ["name","rating","formatted_phone_number","address_component","opening_hours","geometry"]
placeid = "ChIJMQOS9VovmEcRTPG4ZBnGOi0"

GooglePlaces.initialise_logging(logtofile, logpath, loglevel, appenv)

df = GooglePlaces.placedetails(key=key, placeid=placeid, fields=fields)