<# ----------- log data points ---------------- #>
function log_directory_state ( $path_to_log_file, $our_directory )
{
    write-debug "BEGIN:log_directory_state"
    $our_date           = (Get-Date)
    log_directory_state_summary          $path_to_log_file $our_directory $our_date 
    log_directory_state_individual_files $path_to_log_file $our_directory $our_date 
    write-debug "END:log_directory_state"
}

function log_directory_state_summary ( $path_to_log_file, $our_directory, $our_date )
{
    write-debug "BEGIN:log_directory_state.log_summary"
    $log_file_summary   = "$(log_file_data_points_summary $path_to_log_file)"    
    $directory_summary = "$($our_date), [$($our_directory.size_bytes)], [$($our_directory.size_bytes / 1KB)], [$($our_directory.size_bytes / 1MB)], [$($our_directory.size_bytes / 1GB)], $($our_directory.path)" 
    write-output $directory_summary >> $log_file_summary
    write-debug "END:log_directory_state.log_summary"
}

function log_directory_state_individual_files ( $path_to_log_file, $our_directory, $our_date )
{
    if ( $SCRIPT:record_file_sizes -eq $true )
    {
        $log_file_detailed  = "$(log_file_data_points_detailed $path_to_log_file $our_date)"
        foreach ($file in $our_directory.files)
        {
            $size_padded = ($file.Length).ToString().PadRight(20, ' ')
            write-output "$size_padded | $($file.FullName)" >> $log_file_detailed
        } 
    }
}






<# ----------- log SLOPE ---------------- #>
function log_slope ( $path_to_log_file, $our_slopes,  $our_current_slope )
{
    write-debug "BEGIN:log_slope"
    $our_date = (Get-Date)
    $null = ( log_slope.summary          $path_to_log_file $our_slopes $our_current_slope $our_date )
    $null = ( log_slope.individual_files $path_to_log_file $our_slopes $our_current_slope $our_date )
    write-debug "END:log_slope"
    return $null
}

function log_slope.summary ( $path_to_log_file, $our_slopes,  $our_current_slope, $our_date )
{
    write-debug "BEGIN:log_slope.summary"
    $log_file_summary   = "$(log_file_slope_summary $path_to_log_file)"
    $line = ( format_our_current_slope_for_log $our_date $our_current_slope )
    write-output $line >> $log_file_summary
    write-debug "END:log_slope.summary"
    return $null
}

function log_slope.individual_files ( $path_to_log_file, $our_slopes,  $our_current_slope, $our_date )
{
    write-debug "BEGIN:log_slope.individual_files"
    if ( $SCRIPT:record_file_sizes -eq $true )
    {
        $log_file_detailed  = "$(log_file_slope_detailed $path_to_log_file $our_date)"
        foreach ($slope in $our_slopes)
        {
            $line = ( format_our_current_slope_for_log $our_date $slope )
            write-output $line >> $log_file_detailed
        }
    }
    write-debug "END:log_slope.individual_files"    
    return $null
}

function format_our_current_slope_for_log ( $our_date , $our_current_slope )
{
    $rise = $our_current_slope.rise
    $label = $our_current_slope.my_label

    $from   = $our_current_slope.run_a
    $to     = $our_current_slope.run_b

    $rise_a = $our_current_slope.rise_a
    $rise_b = $our_current_slope.rise_b    

    $ssec   =   ( format_slope_for_log  $our_current_slope.slope_seconds    $rise      $our_current_slope.run_seconds )
    $smin   =   ( format_slope_for_log  $our_current_slope.slope_minutes    $rise      $our_current_slope.run_minutes )
    $shour  =   ( format_slope_for_log  $our_current_slope.slope_hours      $rise      $our_current_slope.run_hours )
    $sday   =   ( format_slope_for_log  $our_current_slope.slope_days       $rise      $our_current_slope.run_days )
    

    $slopes = "$($our_current_slope.slope_seconds) , $($our_current_slope.slope_minutes) , $($our_current_slope.slope_hours) , $($our_current_slope.slope_days)"

    $runs = "$($our_current_slope.run_seconds) , $($our_current_slope.run_minutes) , $($our_current_slope.run_hours) , $($our_current_slope.run_days)"

    $line = "$our_date| $rise | $($our_current_slope.run_seconds) | $slopes | $from | $to | $rise_a | $rise_b  | $runs | $label"

    return $line
}

function format_slope_for_log ( $slope, $rise, $run )
{
    $slope  = "$slope".PadRight(10, ' ');
    $run    = "$run".PadRight(10, ' ');
    return "$slope, $run"
}








<# ----------- log files ---------------- #>
function log_file_data_points_summary($path_to_log_file)
{
    $ret_name = "$($path_to_log_file)_size_directory_$(get_sortable_date_hour).log"
    setup_log_directory_state $ret_name $null 
    return $ret_name
}

function log_file_data_points_detailed($path_to_log_file, $our_date)
{
    $ret_name = "$($path_to_log_file)_size_files$(get_sortable_date_hour $our_date)\$(get_sortable_dttm $our_date).log"
    setup_log_directory_state $null $ret_name
    return $ret_name
}

function log_file_slope_summary($path_to_log_file)
{
    $ret_name = "$($path_to_log_file)_size_slope_directory_$(get_sortable_date_hour).log"
    setup_log_slope $ret_name $null
    return $ret_name
}

function log_file_slope_detailed($path_to_log_file, $our_date)
{
    $ret_name = "$($path_to_log_file)_size_slope_files_$(get_sortable_date_hour $our_date)\$(get_sortable_dttm $our_date).log"
    setup_log_slope $null $ret_name
    return $ret_name
}

Function get_sortable_date_hour
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$False)][datetime]$to_format = (Get-Date)
    )
    [string]$ret_dt_formatted = ""
    $ret_dt_formatted = $to_format.ToUniversalTime().ToString("yyyyMMddzzHH")
    return($ret_dt_formatted)
}

Function get_sortable_dttm
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$False)][datetime]$to_format = (Get-Date)
    )
    [string]$ret_dt_formatted = ""
    $ret_dt_formatted = $to_format.ToUniversalTime().ToString("yyyyMMddzzHHmmssfffffff")
    return($ret_dt_formatted)
}


function setup_log_directory_state ( $log_file_summary,  $log_file_detailed )
{
    if ( $SCRIPT:setup_log_directory_state_done -eq $false )
        {
            if (( $log_file_detailed -ne $null  ) -and (${SCRIPT:setup_log_directory_state_done.summary} -eq $false   ) ) { "BYTES | FULL_NAME"                           >> $log_file_detailed ; ${SCRIPT:setup_log_directory_state_done.summary}  = $true;}
            if (( $log_file_summary -ne $null   ) -and (${SCRIPT:setup_log_directory_state_done.detailed} -eq $false  ) ) { "DATE, BYTES, KBYTES, MBYTES, GBYTES, PATH"   >> $log_file_summary  ; ${SCRIPT:setup_log_directory_state_done.detailed} = $true;}
            if ( ( ${SCRIPT:setup_log_directory_state_done.summary} -eq $true ) -and ( ${SCRIPT:setup_log_directory_state_done.detailed} -eq $true ) )
            {
              $SCRIPT:setup_log_directory_state_done = $true
            }             
        }
}

function setup_log_slope ( $log_file_summary,  $log_file_detailed )
{
    if ( $SCRIPT:setup_log_slope_done -eq $false )
        {
            $ssec = ( format_slope_for_log "sec_slope" "sec_rise" "sec_run"  )
            $smin = ( format_slope_for_log "min_slope" "min_rise" "min_run"  )
            $shour = ( format_slope_for_log "hour_slope" "hour_rise" "hour_run"  )
            $sday = ( format_slope_for_log "day_slope" "day_rise" "day_run"  )

            $line = "DATE | bytes_since_begun | seconds_since_begun | slope_sec , slope_min , slope_hour , slope_day | FROM | TO | SIZE_A | SIZE_B | SIZE_DELTA | run_sec , run_min , run_hour , run_day | LABEL"
            if ( ( $log_file_summary -ne $null )  -and (${SCRIPT:setup_log_slope_done.summary}  -eq $false) ) { $line >> $log_file_summary  ; ${SCRIPT:setup_log_slope_done.summary}  = $true; }
            if ( ( $log_file_detailed -ne $null ) -and (${SCRIPT:setup_log_slope_done.detailed} -eq $false) ) { $line >> $log_file_detailed ; ${SCRIPT:setup_log_slope_done.detailed} = $true; }
            
            if ( ( ${SCRIPT:setup_log_slope_done.summary} -eq $true ) -and ( ${SCRIPT:setup_log_slope_done.detailed} -eq $true ) )
            {
              $SCRIPT:setup_log_slope_done = $true 
            } 
        }
} 