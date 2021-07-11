import Logging
using LoggingExtras, Dates

"""
    initialise_logging(true, "/logs/", 1000, dev)

Initialise logging object.

# Examples
```julia-repl
julia> initialise_logging()
julia> @warn("It is bad")
┌ Warning: 2021-06-21 11:47:44 It is bad
└ @ Main REPL[166]:1

julia> @info("normal stuff")
[ Info: 2021-06-21 11:47:44 normal stuff

julia> @error("THE WORSE THING")
┌ Error: 2021-06-21 11:47:44 THE WORSE THING
└ @ Main REPL[168]:1

julia> @debug("it is chill")
┌ Debug: 2021-06-21 11:47:46 it is chill
└ @ Main REPL[169]:1
```
"""
function initialise_logging(log_to_file::Bool, log_path::String, log_level::Int32, app_env::String)
    date_format = "yyyy-mm-dd HH:MM:SS"
    log_level = log_level |> Logging.LogLevel

    logger =  if log_to_file
                isdir(log_path) || mkpath(log_path)
                LoggingExtras.TeeLogger(
                    LoggingExtras.FileLogger(joinpath(log_path, "$(app_env)-$(Dates.today()).log"), always_flush = true, append = true),
                    Logging.ConsoleLogger(stdout, log_level)
                )
                else
                Logging.ConsoleLogger(stdout, log_level)
                end

    timestamp_logger(logger) = LoggingExtras.TransformerLogger(logger) do log
        merge(log, (; message = "$(Dates.format(Dates.now(), date_format)) $(log.message)"))
    end

    LoggingExtras.TeeLogger(LoggingExtras.MinLevelLogger(logger, log_level)) |> timestamp_logger |> global_logger

    nothing
end