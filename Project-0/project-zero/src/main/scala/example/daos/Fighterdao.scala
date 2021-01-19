package example.daos

import example.models.Fighter
import example.utils.ConnectionUtil
import scala.util.Using
import scala.collection.mutable.ArrayBuffer
import java.sql.Connection
import java.sql.DriverManager
import scala.io.StdIn


/** A Book Data Access Object.  BookDao has CRUD methods for Books
  *
  * It allows us to keep all of our database access logic in this file,
  * while still allowing the rest of our application to use Books
  * retrieved from the database.
  */
object FighterDao {

  /** Retrieves all Books from the book table in the db
    *
    * @return
    */
  def getAll(): Unit = {
    val conn = ConnectionUtil.getConnection();
    Using.Manager { use =>
      val stmt = use(conn.prepareStatement("SELECT * FROM fighter"))
      stmt.execute()
      val rs = use(stmt.getResultSet())
      // lets use an ArrayBuffer, we're adding one element at a time
      val allFighters: ArrayBuffer[Fighter] = ArrayBuffer()
      while (rs.next()) {
        allFighters.addOne(Fighter.fromResultSet(rs))
        println("Fighter name is: " + rs.getObject(1))
      }
      allFighters.toList
    }.get
    // the .get retrieves the value from inside the Try[Seq[Book]] returned by Using.Manager { ...
    // it may be better to not call .get and instead return the Try[Seq[Book]]
    // that would let the calling method unpack the Try and take action in case of failure
  }

  // def get(name: String): Seq[Fighter] = {
  //   val conn = ConnectionUtil.getConnection()
  //   Using.Manager { use =>
  //     val stmt = use(conn.prepareStatement("SELECT * FROM fighter WHERE name = ?"))
  //     stmt.setString(1, name)
  //     stmt.execute()
  //     val rs = use(stmt.getResultSet())
  //     val fighterWithName : ArrayBuffer[Fighter] = ArrayBuffer()
  //     while (rs.next()) {
  //       fighterWithName.addOne(Fighter.fromResultSet(rs))
  //     }
  //     fighterWithName.toList
  //   }.get
  // }

  def saveNew(name: String): Unit = {
    val conn = ConnectionUtil.getConnection()
    try {
      // if we have a that author in our DB already, we can us it's author_id. Otherwise we create a new author
          var insertStatement = conn.prepareStatement(
            "INSERT INTO fighter VALUES (?);"
          )
          insertStatement.setString(1, name)
          insertStatement.execute()
    } catch {
      case e: Exception => {
        println("SQL error:")
        e.printStackTrace()
      }
    } finally {
      conn.close()
    }
  }

  def updateNew(newName: String, name: String): Unit = {
    val conn = ConnectionUtil.getConnection()
    
    
    try {
      // if we have a that author in our DB already, we can us it's author_id. Otherwise we create a new author
          var updateStatement = conn.prepareStatement(
            "UPDATE fighter SET name = ? WHERE name = ?;"
          )
          updateStatement.setString(1, newName)
          updateStatement.setString(2, name)
          updateStatement.execute()
    } catch {
      case e: Exception => {
        println("SQL error:")
        e.printStackTrace()
      }
    } finally {
      conn.close()
    }
  }

  def deleteFighter(name: String): Unit = {
    val conn = ConnectionUtil.getConnection()
    try {
      var stmt = conn.prepareStatement(
        ("DELETE from fighter where name = ?")
      )
      stmt.setString(1, name)
      stmt.execute()
      if (stmt.getUpdateCount() > 0)
        println("successfully deleted fighter")
      else println("fighter not recognized")
    } catch {
      case e: Exception => {
        println("SQL error:")
        e.printStackTrace()
      }
    } finally {
      conn.close()
    }
  }

}