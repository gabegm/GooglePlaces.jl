using HTTP

function callapi(
    url::String,
    initial_delay::Int64=3,
    delay::Int64=3
)
    sleep(initial_delay)
    try
        response = HTTP.request("GET", url; verbose=1, retries=4)
        if response.status != 200
            sleep(delay)
            error("GoogleApiInvalidRequestError")
        else
            @info "response status: $(response.status)"

            return response
        end
    catch e
        @debug "response status: $(response.status)"
    end
    error("Failed to call $url")
end