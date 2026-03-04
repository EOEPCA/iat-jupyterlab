import os
c = get_config()
c.NotebookApp.allow_origin = '*'
c.NotebookApp.tornado_settings = {
    'headers': { 'Content-Security-Policy': "frame-ancestors *;" }
}
os.system('/usr/local/bin/nc-sync')