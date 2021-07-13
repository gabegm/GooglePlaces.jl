import Pkg

Pkg.activate(".")
Pkg.instantiate()

using GooglePlaces
using DataFrames
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
radius = retrieve(conf, "googleAPI", "radius", Int64)
rankby = retrieve(conf, "googleAPI", "rankby")

location = (48.137073, 11.575734)

GooglePlaces.initialise_logging(logtofile, logpath, loglevel, appenv)

df = GooglePlaces.nearbysearch(
    ;
    key=key,
    location=location,
    radius=radius,
    rankby=rankby,
    language="en-GB",
    pages=3
)