# Project One

## Project Description

This project is a collection of HiveQL querying instructions for traversing over public wikipedia data. This includes the popularity of individual pages 

## Technologies Used

* Scala - version 2.12
* Hadoop - version 3.2.1
* Hive - version 2.0

## Features

* Provides Hive queries that answer information regarding downloaded wikipedia data
* Answers questions about individuals popularity on their Wikipedia pages
* Used to compare current and prior levels of popularity of subjects

To-do list:
* Refine queries that are multi-step into single step Hive Queries

## Getting Started
   
1. git clone https://github.com/Frank-Rauen/Scala-Project-Zero/tree/master/Project-1/projectone
2. Change the following environment settings in the following folders
    - cd hadoop/3.2.1/libexec/etc/hadoop (check your version and replace 3.2.1 with your version of hadoop)
    - nano hadoop-env.sh 
    - add your java_home export (you can find this with the following terminal command "/usr/libexec/java_home")
    - change export HADOOP_OPTS=”-Djava.net.preferIPv4Stack=true”
      to export HADOOP_OPTS = ”-Djava.net.preferIPv4Stack=true -Djava.security.krb5.realm= -Djava.security.krb5.kdc=”
3. nano core-site.xml and add this code 
"<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>"

4. nano hdfs-site.xml and add this code
  "<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
</configuration>"

5. nano mapred-site.xml and add this code
  "<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  <property>
    <name>mapreduce.application.classpath</name>   <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
  </property>
</configuration>"

6. nano yarn-site.xml and add this code
  "<configuration>
<property>
<name>yarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>
<property>
<name>yarn.nodemanager.env-whitelist</name>
<value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
</property>
</configuration>"

7. Run "ssh localhost" on your terminal and if it DOES NOT return a login time run the following terminal commands

  "$ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
   $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   $ chmod 0600 ~/.ssh/authorized_keys

8. cd hadoop/3.2.1/libexec/bin (keep your hadoop versioning in mind when changing directory)

9. hdfs namenode -format (this will set your namenode to access Hadoop

10. Start HDFS and Yarn with the following terminal commands:
    $ cd /hadoop/3.2.1/libexec/sbin
    $ ./start-all.sh
    
11. Type jps into the terminal to confirm nodes and resource managers are running. The output should look similar to something like this:
    "66896 ResourceManager
     66692 SecondaryNameNode
     66535 DataNode
     67350 Jps
     66422 NameNode67005 NodeManager"
     
12. Check your Hadoop cluster is running on http://localhost:9870 for version 3 (http://localhost:50070) for version 2 and older
     
13. Type "hiveserver2" into the terminal to connect your Hadoop cluser to Hive and connect on your choice of Database managing software such as Dbeaver

## Usage

This project is a collection of HiveQl queries for drawing information from wikipedia. To collect the data to your local system, you will wget from the terminal the provided URL addresses. This will download the zipped file to whatever directory you are in while calling wget. You can use the gunzip command to unzip those files. Once those files are unzipped locally, you will use the provide LOAD DATA LOCAL INPATH command to load the data into your Hive Sql database and tables. You can then use the provided Queries to filter and show all the downloaded data in Hive. 
