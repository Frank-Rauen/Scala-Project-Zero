package example.models

import java.sql.ResultSet

case class Fighter(name : String) {

}

object Fighter {
  /**
    * Produces a Book from a record in a ResultSet.  Note that this method does *not* call next()!
    *
    * @param rs
    * @return
    */
  def fromResultSet(rs : ResultSet) : Fighter = {
    apply(
      rs.getString("name")
    )
  }
}