using LinearAlgebra
import JSON3

function flatten_json(d, prefix_delim = ".")
    new_d = empty(d)
    for (key, value) in d
        if isa(value, JSON3.Object)
            flattened_value = flatten_json(value, prefix_delim)
            for (ikey, ivalue) in flattened_value
                new_d[Symbol(Symbol(key,".",ikey))] = ivalue
            end
        else
            new_d[key] = value
        end
    end
    return new_d
end

"""
p1 = (48.0929414, 11.5355774)
p2 = (48.0428369, 11.5109936)

# 51.5, 0, 38.8, -77.1
p1 = (51.5, 0)
p2 = (38.8, -77.1)
distance(p1, p2) # 5918.185064088764

p1 = (0,0)
p2 = (0,0)

distanceInKmBetweenEarthCoordinates(51.5, 0, 38.8, -77.1)

lat1, lon1, lat2, lon2 = 51.5, 0, 38.8, -77.1
"""
function distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2)
    earthRadiusKm = 6371

    dLat = deg2rad(lat2-lat1) # -0.2216568150032799
    dLon = deg2rad(lon2-lon1) # -1.345648853287628

    rlat1 = deg2rad(lat1) # 0.8988445647770797
    rlat2 = deg2rad(lat2) # 0.6771877497737998

    a = sin(dLat/2) * sin(dLat/2) + # 0.012232728027071711
        sin(dLon/2) * sin(dLon/2) * # 0.3883749419945243
        cos(rlat1) * cos(rlat2) # 0.48514929005721846
        # 0.20065255541172858

    c = 2 * atan(sqrt(a), sqrt(1-a)) # 0.928925610436158

    return earthRadiusKm * c # 5918.185064088762
end

function distance(p1::Tuple, p2::Tuple; earthRadiusKm=6371)
    pdist = deg2rad.(p2 .- p1) # (-0.2216568150032799, -1.345648853287628)
    rlat = deg2rad.((p1[1], p2[1])) # (0.8988445647770797, 0.6771877497737998)

    # halfLapsAroundGlobe
    a = sum(sin.(pdist ./ 2) .^ 2) * dot(cos.(rlat)...)

    return (2 * atan(sqrt(a), sqrt(1 - a))) * earthRadiusKm
end