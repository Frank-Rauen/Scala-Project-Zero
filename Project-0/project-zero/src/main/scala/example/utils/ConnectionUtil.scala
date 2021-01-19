package example.utils

import java.sql.Connection
import java.sql.DriverManager
// import java.postgresql.Driver

object  ConnectionUtil {

  var conn: Connection = null;

  def getConnection(): Connection = {

    // if conn is null or closed, initialize it
    if (conn == null || conn.isClosed()) {
      classOf[org.postgresql.Driver].newInstance() // manually load the Driver

    conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", 
                                "home", 
                                "password1!")

    }
        conn
    }
}