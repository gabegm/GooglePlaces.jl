using GooglePlaces: callapi
using JSON3, Tables, DataFrames

function nearbysearch(
    ;
    key::String,
    location::Tuple,
    radius::Int64,
    rankby::String,
    language::String="en-GB",
    keyword::String="",
    name::String="",
    oftype::String="",
    pricerange::Tuple=(),
    pages::Int64=3
)
    @assert radius <= 50000 && radius >= 0 "accepted range for radius 0 => 50000"
    @assert rankby == "distance" || rankyby == "prominence" "accepted values for rankyby distance, promonence"
    @assert pages >= 1 && pages <= 3 "accepted values for pages 1 => 3"
    """
    if rankby == "distance"
        @assert !isempty(oftype) "value for oftype required when rankby==distance"
    end
    """

    urlbase = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    urllocation = "?location=$(join(repr.(location), ","))"
    urlradius = "&radius=$radius"
    urlrankby = "&rankBy=$rankby"
    urllanguage = "&language=$language"
    urlkeyword = "&keyword=$keyword"
    urlname = "&name=$name"
    urltype = "&type=$oftype"
    urlkey = "&key=$key"

    url = (
        urlbase
        * urllocation
        * urlradius
        * urlrankby
        * urlkey
    )

    if !isempty(keyword)
        url *= urlkeyword
    end

    if !isempty(oftype)
        url *= urltype
    end

    if !isempty(name)
        url *= urlname
    end

    json_flattened = transformresults(url, pages)

    table = Tables.dictrowtable(json_flattened) # treat a json object of arrays or array of objects as a "table"
    df = DataFrame(table) # turn table into DataFrame

    _url = replace(url, key => "")
    df[!, :url] = [_url for _ in 1:nrow(df)]

    return df
end

function transformresults(url::String, pages::Int64)
    pagecount = 0
    urlnextpagetoken = ""
    d = []

    while true
        response = String(callapi(url * urlnextpagetoken).body)
        json = JSON3.read(response) # read JSON string
        json_flattened = flatten_json.(json.results)
        append!(d, json_flattened)
        pagecount += 1

        "next_page_token" in keys(json) && pagecount < pages || break
        urlnextpagetoken = "&pagetoken=$(json["next_page_token"])"
    end
    return d
end