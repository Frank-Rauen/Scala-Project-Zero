package example

import java.sql.DriverManager
import java.sql.ResultSet
import example.utils.ConnectionUtil
import scala.util.Using
import java.sql.Connection

import example.models.Fighter
import example.daos.FighterDao
import example.cli.Cli



object Driver {
  def main(args: Array[String]): Unit = {
    val cli = new Cli();
    cli.menu()
  }
}