function observe_deleted_files ( $our_dir_first,  $our_dir_now)
{
    $deleted_files  = ( files_not_in_other_list -list_a:$our_dir_first -list_b:$our_dir_now)
    if ( $deleted_files -ne $null )
    {
        $deleted_files_not_already_observed = ( files_not_in_other_list -list_a:$deleted_files -list_b:$SCRIPT:our_dir_deleted_files_since_start )
        foreach ($file in $deleted_files_not_already_observed) 
        {
            $SCRIPT:our_dir_deleted_files_since_start.add_file( ( New-Object [System.IO.FileInfo] $file ) ) 
        }  
    }
    return $null 
}

function observe_new_files ($our_dir_first,  $our_dir_now)
{
    $new_files                        = ( files_not_in_other_list -list_a:$our_dir_now  -list_b:$our_dir_first )
    if ( $new_files -ne $null )
    {
        $new_files_not_already_observed   = ( files_not_in_other_list -list_a:$new_files    -list_b:$SCRIPT:our_dir_new_files_since_start )
        foreach ($file in $new_files_not_already_observed) 
            {
                $SCRIPT:our_dir_new_files_since_start.add_file( ( New-Object [System.IO.FileInfo] $file ) ) 
            }
    }

    return $null 
}