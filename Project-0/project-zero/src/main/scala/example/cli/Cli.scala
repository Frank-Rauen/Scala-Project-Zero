package example.cli

import scala.io.StdIn
import scala.util.matching.Regex
import java.io.FileNotFoundException

import example.daos.FighterDao
import example.models.Fighter
import example.utils.FileUtil
import example.utils.ConnectionUtil
import scala.util.Using
import scala.collection.mutable.ArrayBuffer
/** A CLI that allows the user to interact with our application
  *
  * This Cli is a class because in the future we might provide customization options
  * that can be set when creating a new Cli instance.
  *
  * This Cli class will contain all our logic involving interacting with the user
  * we don't want all of our classes to be able to receive input from the command line
  * or write to the command line.  Instead, we'll have (almost) all that happen here.
  */
class Cli {

  /** commandArgPattern is a regular expression (regex) that will help us
    * extract the command and argument from user input on the command line
    *
    * Regex is a tool used for pattern matching strings.  Lots of languages and other tools
    * support regex.  It's good to learn at least the basic, but you can also just use this
    * code for your project if you like.
    */
  val commandArgPattern: Regex = "(\\w+)\\s*(.*)".r
  /** Prints a greeting to the user
    */
  def printWelcome(): Unit = {
    println("Welcome to Project Zero!")
  }

  /** Prints the commands available to the user
    */
  def printOptions(): Unit = {
    println("Commands available:")
    // println(
    //   "Get one fighter by first and last name with the getOne command"
    // )
    println("Get all fighters on the database with the getAll command")
    println("Add one fighter with the insert command")
    println("Update a fighters name with the update command")
    println("Delete a fighter with the delete command")
    println("Parse through a json document with the json command")
    println("exit : exits project zero CLI")
  }
    
    

  /** This runs the menu, this is the entrypoint to the Cli class.
    *
    * The menu will interact with the user on a loop and call other methods/classes
    * in order to achieve the result of the user's commands
    */
  def menu(): Unit = {
    printWelcome()
    var continueMenuLoop = true
    while (continueMenuLoop) {
      printOptions()
      // take user input using StdIn.readLine
      // readLine is *blocking* which means that it pauses program execution while it waits for input
      // this is fine for us, but we do want to take note.
      val input = StdIn.readLine()
      // Here's an example using our regex above, feel free to just follow along with similar commands and args
      input match {
        case commandArgPattern(cmd, arg)
          if cmd.equalsIgnoreCase("getAll") => {
          getAllFighters()
        }
        case commandArgPattern(cmd, arg) 
          if cmd.equalsIgnoreCase("exit") => {
          continueMenuLoop = false
        }
        case commandArgPattern(cmd, arg) 
          if cmd.equalsIgnoreCase("insert") => {
          insertFighter(arg)
        }
        case commandArgPattern(cmd, arg)
          if cmd.equalsIgnoreCase("update") => {
          updateFighter()
        }
        case commandArgPattern(cmd, arg)
          if cmd.equalsIgnoreCase("delete") => {
          deleteFighter()  
        }
        case _ => {
          println("Failed to parse any input")
        }
      }
    }
    println("Thank you for using Project zero CL, goodbye!")
  }

  def getAllFighters(): Unit = {
    FighterDao.getAll()
  }

  // def getOne(name: String): Unit = {
  //   FighterDao.get(name)
  // }

  def insertFighter(name: String): Unit = {
    // var fighter = Fighter
    FighterDao.saveNew(name)
  }

  def updateFighter(): Unit = {
    println("Updating name to?")
    var newName = StdIn.readLine()
    println("Updating name from?")
    var name = StdIn.readLine()
    FighterDao.updateNew(newName, name)
  }

  def deleteFighter(): Unit = {
    println("delete fighter")
          println("name?")
          var name = StdIn
            .readLine()
          FighterDao.deleteFighter(name)
        }
  } 

