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