function populate_my_directory($path)  
{
    write-debug "BEGIN:populate_my_directory"
    $parent = (get-item $path)
    write-debug "`$parent=[$($parent.FullName)]"
    $directory_now = New-Object my_directory $path
    
    $kids = $null

    try {
        $kids = (Get-ChildItem -LiteralPath:$parent.fullname -recurse -force)  
    }
    catch [Exception] {
        if ( $_.Exception.Message -Like "Access to the path '*' is denied." )
        {
            write-warning "Access to the path is denied.  We are going to try accessing the path without looking at hidden items.  path=[$path]."
            $kids = (Get-ChildItem -LiteralPath:$parent.fullname -recurse ) 
        }
    }
    
    if ( $kids -eq $null )
    {
        write-warning "We found no items in the path=[$path]."
    }

    ForEach ( $child in $kids )
        { 
            if ( $child.PsIsContainer -eq $false )
            {
                $directory_now.add_file($child)
            }
            else 
            {
                write-debug "`$child.FullName=[$($child.FullName)]";  
            }
        }

    write-debug "END:populate_my_directory"
    return $directory_now 
}


function get_file_from_our_dir ( $our_dir, $full_file_name_to_find )
{
    write-debug "BEGIN:get_file_from_our_dir.  Looking for the file=[$full_file_name_to_find]."
    if ( $our_dir -ne $null )
        {
            if ( ( $our_dir.file_full_names -contains ($full_file_name_to_find) ) -eq $true )
            {
                write-debug "get_file_from_our_dir : $($our_dir.path) contains $full_file_name_to_find."
                foreach($file in $our_dir.files)
                    {
                        if ( $file.FullName -eq $full_file_name_to_find ) 
                        {
                            write-debug "get_file_from_our_dir : found the file, about to return it."
                            return $file
                        }  
                    }
            }
        }
    write-debug "END:get_file_from_our_dir"
    return $null
}


function files_not_in_other_list ( $dir_a, $dir_b )
{
    write-debug "BEGIN:files_not_in_other_list"
    $files_not_in_list_b = @()
    if ( $dir_a -ne $null )
    {
        if ( $dir_b -ne $null )
        {
            foreach ($file in $dir_a.files)
            {
                $exists_in_list_b = ( $dir_b.file_full_names -contains ($file.FullName) ) 
                if ($exists_in_list_b -eq $false)
                {
                    $files_not_in_list_b += $file
                }
            }
        }
        else
        {
          $files_not_in_list_b = $dir_a
        }
    }
    write-debug "END:files_not_in_other_list"
    return $files_not_in_list_b
}

