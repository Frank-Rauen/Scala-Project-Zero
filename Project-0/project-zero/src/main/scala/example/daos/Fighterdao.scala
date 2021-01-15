package example.daos

import example.models.Fighter
import example.utils.ConnectionUtil
import scala.util.Using
import scala.collection.mutable.ArrayBuffer

/** A Book Data Access Object.  BookDao has CRUD methods for Books
  *
  * It allows us to keep all of our database access logic in this file,
  * while still allowing the rest of our application to use Books
  * retrieved from the database.
  */
object BookDao {

  /** Retrieves all Books from the book table in the db
    *
    * @return
    */
  def getAll(): Seq[Fighter] = {
    val conn = ConnectionUtil.getConnection();
    Using.Manager { use =>
      val stmt = use(conn.prepareStatement("SELECT * FROM fighter;"))
      stmt.execute()
      val rs = use(stmt.getResultSet())
      // lets use an ArrayBuffer, we're adding one element at a time
      val allBooks: ArrayBuffer[Fighter] = ArrayBuffer()
      while (rs.next()) {
        allFighters.addOne(Fighter.fromResultSet(rs))
      }
      allBooks.toList
    }.get
    // the .get retrieves the value from inside the Try[Seq[Book]] returned by Using.Manager { ...
    // it may be better to not call .get and instead return the Try[Seq[Book]]
    // that would let the calling method unpack the Try and take action in case of failure
  }

  def get(title: String): Seq[Fighter] = {
    val conn = ConnectionUtil.getConnection()
    Using.Manager { use =>
      val stmt = use(conn.prepareStatement("SELECT * FROM fighter WHERE name = ?"))
      stmt.setString(1, name)
      stmt.execute()
      val rs = use(stmt.getResultSet())
      val fighterWithName : ArrayBuffer[Fighter] = ArrayBuffer()
      while (rs.next()) {
        fighterWithName.addOne(Fighter.fromResultSet(rs))
      }
      fighterWithName.toList
    }.get
  }

  def saveNew(fighter : Fighter) : Boolean = {
    val conn = ConnectionUtil.getConnection()
    Using.Manager { use =>
      val stmt = use(conn.prepareStatement("INSERT INTO fighter VALUES (DEFAULT, ?, ?);"))
      stmt.setString(1, fighter.name)
      stmt.execute()
      //check if rows were updated, return true is yes, false if no
      stmt.getUpdateCount() > 0
    }.getOrElse(false)
    // also returns false if a failure occurred
  }

}