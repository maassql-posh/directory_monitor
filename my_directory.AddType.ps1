
Add-Type @'

public class my_directory
{
    private System.Int64                                            _length_bytes = 0;
    private System.Collections.Generic.List<System.IO.FileInfo>     _files  = new System.Collections.Generic.List<System.IO.FileInfo>();
    private string                                                  _my_path;
    private System.Collections.Generic.List<string>                 _file_full_names  = new System.Collections.Generic.List<string>() ;
    private System.DateTime                                         _observed_time ;

    public my_directory (string path)
    {
        _my_path = path ;
        _observed_time = System.DateTime.Now ;
    }

    public void add_file(System.IO.FileInfo file) {
        _length_bytes += file.Length;
        _files.Add(file);
        _file_full_names.Add(file.FullName) ;
    }

    public string path 
    {
        get
        {
            return _my_path ;
        }
    }

    public System.Collections.Generic.List<System.IO.FileInfo> files 
    {
        get
        {
            return _files;
        }
    }

    public System.Int64 size_bytes
    {
        get
        {
            return _length_bytes;
        }
    }

    
    public System.Collections.Generic.List<string> file_full_names
    {
        get
        {
            return _file_full_names;
        }
    }

    public System.DateTime observed_time
    {
        get
        {
            return _observed_time;
        }
    }

}
'@
