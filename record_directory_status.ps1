Function record_directory_status
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"    
    write-debug "BEGIN:record_directory_status"

    $SCRIPT:loop_counter += 1;

    write-host "Hi!... I am part of a set of scripts located at the path=[$SCRIPT:here]."
    if ( ( $SCRIPT:loop_counter % 10 ) -eq 0 )
    {
        tell_our_user_what_settings_we_are_using
    }

    write-host "Gathering the state of the path=[$SCRIPT:path_to_analyze]."
    $null = ( record_directory_status.gather_state )

    write-host "Writing log about the state of the path."
    $null = ( log_directory_state $SCRIPT:path_to_log_file $SCRIPT:looping_our_dir_now )
    
    if ( $SCRIPT:record_slope -eq $true )
    {
        write-host "Calculating the slope of size change of the path."
        $slope_of_directory     = ( slope_over_directory   $SCRIPT:looping_our_dir_first $SCRIPT:looping_our_dir_now )    
        if ( $SCRIPT:record_file_sizes -eq $true )
        {
            write-host "Calculating the slope of size change of each file in the path."
            $slope_per_file         = ( get_our_file_slopes    $SCRIPT:looping_our_dir_first $SCRIPT:looping_our_dir_now )    
        }
        else 
        {
           $slope_per_file         = $null 
        } 
        write-host "Recording the slope of size change."       
        $null = ( record_directory_status.record_slopes )
    }
    else 
    {
        write-debug "Not recording slope because `$SCRIPT:record_slope ne true"    
    }

    write-debug "END:record_directory_status"
    return $null
}


Function record_directory_status.gather_state
{
    write-debug "BEGIN:record_directory_status.gather_state"
    $SCRIPT:looping_our_dir_now = (populate_my_directory $SCRIPT:path_to_analyze)
    if ( $SCRIPT:looping_our_dir_first -eq $null ) 
        { 
            $SCRIPT:looping_our_dir_first = $SCRIPT:looping_our_dir_now 
        }  
    write-debug "END:record_directory_status.gather_state"    
    return $null  
}


Function record_directory_status.record_slopes
{
    write-debug "BEGIN:record_directory_status.record_slopes"

    $null = ( log_slope $SCRIPT:path_to_log_file $slope_per_file $slope_of_directory )
    write-debug "END:record_directory_status.record_slopes"
    return $null
}