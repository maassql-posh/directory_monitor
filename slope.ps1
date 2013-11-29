$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

function slope_over_directory ($our_dir_a, $our_dir_b)
{
  $our_slope = New-Object -TypeName:my_slope -ArgumentList:@($our_dir_a.path , $our_dir_a.size_bytes , $our_dir_b.size_bytes , $our_dir_a.observed_time , $our_dir_b.observed_time) 
  return $our_slope
}


function get_our_file_slopes ($our_dir_first, $our_dir_now)
{
    write-debug "BEGIN get_our_slope"

    if ($our_dir_first -eq $null ) {throw "`$our_dir_first must not be null."}
    if ($our_dir_now -eq $null ) {throw "`$our_dir_now must not be null."}


    $null = ( observe_new_files     $our_dir_first,  $our_dir_now )
    $null = ( observe_deleted_files $our_dir_first,  $our_dir_now )

    $slopes = @();
    $slopes =   ( get_a_slope_per_file  $our_dir_first $our_dir_now )

    # get the slope of files that were added AFTER we began monitoring.....
    $slopes +=  ( get_a_slope_per_file  $SCRIPT:our_dir_new_files_since_start $our_dir_now )

    write-debug "END get_our_slope"
    return $slopes
}

function get_a_slope_per_file ( $our_dir_a, $our_dir_b )
{
    write-debug "BEGIN:get_a_slope_per_file"
    $slopes = @();
    $observed_at_a = $our_dir_a.observed_time
    $observed_at_b = $our_dir_b.observed_time

    if ($our_dir_a -eq $null ) {throw "`$our_dir_a must not be null."}
    if ($our_dir_b -eq $null ) {throw "`$our_dir_b must not be null."}

    foreach($file_a in $our_dir_a.files)
    {
        write-debug "get_a_slope_per_file --> looking for [$($file_a.FullName)] in the another list."
        $file_b = (get_file_from_our_dir $our_dir_b $file_a.FullName)
        if ($file_b -ne $null)
            {
               $our_slope = New-Object -TypeName:my_slope -ArgumentList:@($file_a.FullName , $file_a.Length , $file_b.Length , $observed_at_a , $observed_at_b )
            }
        else 
            {
                # the file has been deleted
                $file_b = (get_file_from_our_dir $SCRIPT:our_dir_deleted_files_since_start $file_a.FullName)
                if ($file_b -ne $null)
                    {
                       $our_slope = New-Object -TypeName:my_slope -ArgumentList:@($file_a.FullName , $file_a.Length , $file_b.Length , $observed_at_a , $observed_at_b )
                    }
                else 
                    {
                        throw "`$file_b was not found `$file_a.FullName=[$($file_a.FullName)]."
                    }
            }
        $slopes += $our_slope
    }
    write-debug "END:get_a_slope_per_file"
    return $slopes
}


