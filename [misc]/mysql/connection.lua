function connect()
    DBConnection = dbConnect( "mysql", "dbname=;host=;charset=utf8;port=3380", "", "" )
    if (not DBConnection) then
        outputDebugString("Error: Failed to establish connection to the MySQL database server")
    else
        outputDebugString("Success: Connected to the MySQL database server")
    end
end
addEventHandler("onResourceStart", resourceRoot, connect)