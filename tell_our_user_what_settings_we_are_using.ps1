function tell_our_user_what_settings_we_are_using
{
    write-host (declare_settings_string)
}

function declare_settings_string
{
    $declare_settings = "
Path being watched__________________________________=[$SCRIPT:path_to_analyze]
Logs - path and base filename_______________________=[$SCRIPT:path_to_log_file]
Should we record file sizes?________________________=[$SCRIPT:record_file_sizes]
Should we record slope of size change?______________=[$SCRIPT:record_slope]
How many hours should we run?_______________________=[$SCRIPT:hours_to_run]  
How many seconds should we wait between checks?_____=[$SCRIPT:seconds_to_pause] 
    "
    return $declare_settings
}

