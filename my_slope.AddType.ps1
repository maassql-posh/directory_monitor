
Add-Type @'

public class my_slope
{
    private string                   _my_label = "";
    private System.Int64            _rise_a = 0;
    private System.Int64            _rise_b = 0;
    private System.DateTime         _run_a = System.DateTime.Now;
    private System.DateTime         _run_b = System.DateTime.Now;

    private System.Int64            _rise = 0;
    private System.TimeSpan         _run;

    private System.Double           _slope_seconds = 0;
    private System.Double           _slope_minutes = 0;
    private System.Double           _slope_hours = 0;    
    private System.Double           _slope_days = 0;

    public my_slope (string my_label, System.Int64 rise_a, System.Int64 rise_b, System.DateTime run_a, System.DateTime run_b)
    {
        _my_label = my_label ;
        _rise_a = rise_a  ;
        _rise_b = rise_b  ;
        _run_a = run_a    ;
        _run_b = run_b    ;

        _rise = rise_b - rise_a ;
        _run = ( _run_b - _run_a ) ;

        if ( run_seconds > 0 )
        {
            _slope_seconds = ( _rise / run_seconds ) ;
        }

        if ( run_minutes > 0 )
        {
            _slope_minutes = ( _rise / run_minutes ) ;
        }
        if ( run_hours > 0 )
        {
            _slope_hours = ( _rise / run_hours ) ;
        }
        if ( run_days > 0 )
        {
            _slope_days = ( _rise / run_days ) ;
        }
    }

    public string my_label     
    {
        get
        {
            return _my_label;
        }
    }

    public System.Int64 rise_a     
    {
        get
        {
            return _rise_a;
        }
    }
    public System.Int64 rise_b     
    {
        get
        {
            return _rise_b;
        }
    }
    public System.DateTime run_a     
    {
        get
        {
            return _run_a;
        }
    }
    public System.DateTime run_b     
    {
        get
        {
            return _run_b;
        }
    }

    public System.Int64 rise
    {
        get
        {
            return _rise;
        }
    }

    public System.Double run_seconds
    {
        get
        {
            return _run.TotalSeconds;
        }
    }  

    public System.Double run_minutes
    {
        get
        {
            return _run.TotalMinutes;
        }
    }    

    public System.Double run_hours
    {
        get
        {
            return _run.TotalHours;
        }
    }    

    public System.Double run_days
    {
        get
        {
            return _run.TotalDays;
        }
    }   

    public System.Double slope_seconds
    {
        get
        {
            return _slope_seconds;
        } 
    }    
    public System.Double slope_minutes
    {
        get
        {
            return _slope_minutes;
        } 
    }     
    public System.Double slope_hours
    {
        get
        {
            return _slope_hours;
        } 
    }   
    public System.Double slope_days
    {
        get
        {
            return _slope_days;
        } 
    }          

}
'@