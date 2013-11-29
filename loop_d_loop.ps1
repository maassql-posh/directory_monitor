function pause_loop ($seconds_to_pause)
{
    write-host ""
    write-host ""
    write-host ""
    write-host ""
    write-host "waiting $seconds_to_pause seconds......."
    start-sleep -Seconds:$seconds_to_pause
}

<#
.EXAMPLE
    $sb = {write-host "blah on $(get-date)"}
    loop_your_code -hours_to_run:24 -seconds_to_pause:10 -code_block_to_invoke:$sb
#>
function loop_your_code ($hours_to_run=24, $seconds_to_pause = 120, $code_block_to_invoke)
{
    Set-StrictMode -Version:Latest
    $GLOBAL:ErrorActionPreference               = "Stop"

    $started = (Get-Date)
    $stop_at = $started.AddHours($hours_to_run)
    loop_status $started $stop_at
    while ( (get-date) -le $stop_at ){
        write-debug "loop_your_code : top of while loop"
        Invoke-Command -ScriptBlock:$code_block_to_invoke
        loop_status $started $stop_at
        pause_loop $seconds_to_pause
    }
}

function loop_status ($started, $stop_at)
{
    $tspan=New-TimeSpan $started  (Get-Date);
    $diff_hours=($tspan).hours;
    write-host "Been running $(($tspan).days) days $($diff_hours) hours $(($tspan).minutes) minutes $(($tspan).seconds) seconds. $(Get-Date).  We plan on stopping at $stop_at."   
}


