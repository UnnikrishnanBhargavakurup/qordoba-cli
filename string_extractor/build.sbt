name := "string_extractor"

version := "1.0"

scalaVersion := "2.11.8"

libraryDependencies ++= Seq(
  "org.antlr" % "antlr4-runtime" % "4.7",
  "com.opencsv" % "opencsv" % "3.10",
  "com.typesafe.scala-logging" %% "scala-logging-slf4j" % "2.1.2",
  "ch.qos.logback" % "logback-classic" % "1.2.3"
)
