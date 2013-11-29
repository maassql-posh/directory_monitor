$error.clear();
Set-StrictMode -Version:Latest
$GLOBAL:ErrorActionPreference               = "Stop"

$SCRIPT:here =  ( Split-Path $MyInvocation.MyCommand.Definition )
$SCRIPT:log_directory = "$($SCRIPT:here)\logs\"

. "$($SCRIPT:here)\log_size_changes.ps1"
. "$($SCRIPT:here)\loop_d_loop.ps1"
. "$($SCRIPT:here)\my_directory.AddType.ps1"
. "$($SCRIPT:here)\my_directory.helpers.ps1"
. "$($SCRIPT:here)\my_slope.Addtype.ps1"
. "$($SCRIPT:here)\observe_new_and_deleted_files.ps1"
. "$($SCRIPT:here)\record_directory_status.ps1"
. "$($SCRIPT:here)\slope.ps1"
. "$($SCRIPT:here)\tell_our_user_what_settings_we_are_using.ps1"

<#
.EXAMPLE
    import-module -Force ..\..\pratom\pratom.atom.psm1
    Import-Module -force .\directory_space.psm1
    monitor_directory_for_size_changes -path_to_analyze:"C:\projects\github\maassql_learning_powershell\directory_space\" -seconds_to_pause:5
.EXAMPLE
    # --- Monitor an entire drive 
    Import-Module -force .\directory_space.psm1
    monitor_directory_for_size_changes -path_to_analyze:"F:\" -seconds_to_pause:60

.EXAMPLE
    import-module -Force ..\..\pratom\pratom.atom.psm1
    Import-Module -force .\directory_space.psm1
    monitor_directory_for_size_changes -path_to_analyze:"C:\projects\github\maassql_learning_powershell\directory_space\" -seconds_to_pause:5  -record_file_sizes
    RESULT --> in the script's directory, logs, there will be files about individual files in the directory being monitored  
#>
function monitor_directory_for_size_changes 
{
    [CmdletBinding(DefaultParametersetName="2")] 
    param(
        [Parameter(Position=0, Mandatory = $true)]        [string]    $path_to_analyze
        , [Parameter(Position=1, Mandatory = $false)]     [string]    $log_file_name
        , [Parameter(Position=2, Mandatory = $false)]     [int]       $hours_to_run         
        , [Parameter(Position=3, Mandatory = $false)]     [int]       $seconds_to_pause     
        , [Parameter(Position=4, Mandatory = $false)]     [switch]    $record_file_sizes
        , [Parameter(Position=4, Mandatory = $false)]     [switch]    $record_slope        
        )

    if ( $log_file_name -eq $null -or $log_file_name -eq "" )       { $log_file_name = "log_directory_space" }
    if ( $hours_to_run -eq $null -or $hours_to_run -le 0 )          { $hours_to_run = 26 }
    if ( $seconds_to_pause -eq $null -or $hours_to_run -le 0 )      { $seconds_to_pause = 120 }
    if ( $record_file_sizes -eq $null )                             { $record_file_sizes = $false }
    if ( $record_slope -eq $null )                                  { $record_slope = $false }

    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"

    #------------settings----------
    $SCRIPT:path_to_analyze = $path_to_analyze    
    $SCRIPT:path_to_log_file = "$SCRIPT:log_directory\$log_file_name"
    $SCRIPT:record_file_sizes = $record_file_sizes
    $SCRIPT:record_slope = $record_slope
    $SCRIPT:hours_to_run = $hours_to_run  
    $SCRIPT:seconds_to_pause = $seconds_to_pause

    tell_our_user_what_settings_we_are_using

    #------------initialize runtime variables----------
    $SCRIPT:looping_our_dir_now         = $null
    $SCRIPT:looping_our_dir_first       = $null

    $SCRIPT:setup_log_directory_state_done = $false
    ${SCRIPT:setup_log_directory_state_done.detailed} = $false
    ${SCRIPT:setup_log_directory_state_done.summary} = $false

    $SCRIPT:setup_log_slope_done = $false
    ${SCRIPT:setup_log_slope_done.detailed} = $false
    ${SCRIPT:setup_log_slope_done.summary} = $false

    $SCRIPT:our_dir_new_files_since_start = New-Object my_directory $path_to_analyze
    $SCRIPT:our_dir_deleted_files_since_start = New-Object my_directory $path_to_analyze

    $SCRIPT:loop_counter = 0;


    #-----------monitoring loop----------
    $sb = { record_directory_status }
    loop_your_code -hours_to_run:$hours_to_run -seconds_to_pause:$seconds_to_pause -code_block_to_invoke:$sb
}




