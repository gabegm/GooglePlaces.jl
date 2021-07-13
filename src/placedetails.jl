using GooglePlaces
using Tables, JSON3, DataFrames

function placedetails(
    ;
    key::String,
    placeid::String,
    fields::Vector{String}
)
    urlbase = "https://maps.googleapis.com/maps/api/place/details/json"
    urlplaceid = "?place_id=$placeid"
    urlfields = "&fields=$(join(fields, ","))"
    urlkey = "&key=$key"

    url = (
        urlbase
        * urlplaceid
        * urlfields
        * urlkey
    )

    response = String(callapi(url).body)
    json = JSON3.read(response) # read JSON string
    json_flattened = flatten_json(json.result)

    table = Tables.dictrowtable(json_flattened) # treat a json object of arrays or array of objects as a "table"
    df = DataFrame(table) # turn table into DataFrame

    return df
end