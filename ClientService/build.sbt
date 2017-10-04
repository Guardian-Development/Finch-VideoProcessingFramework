name := """ClientService"""

version := "1-0-snapshot"

lazy val root = (project in file(".")).enablePlugins(sbtdocker.DockerPlugin, PlayScala)

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
  jdbc,
  cache,
  ws,
  "org.scalatestplus.play" %% "scalatestplus-play" % "1.5.1" % Test
)

dockerfile in docker := {
  val appDir = stage.value
  val targetDir = "/app"

  new Dockerfile {
    from("java")
    entryPoint(s"$targetDir/bin/${executableScriptName.value}")
    copy(appDir, targetDir)
  }
}

buildOptions in docker := BuildOptions(cache = false)

fork in run := true