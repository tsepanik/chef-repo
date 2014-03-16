db_password = ""

set_unless[:mysql][:server_root_password] = db_password
set_unless[:mysql][:bind_address]         = ipaddress