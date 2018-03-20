# Anomaly Detection Service

This service provides a basis for performing anomaly detection on behaviours and objects detected within a video stream. It connects to Apache Kafka, and is then able to detect anomalies, publishing the results back to Apache Kafka. It makes use of Apache Spark to provide scalable detections.

Project built from template engine found: https://github.com/holdenk/sparkProjectTemplate.g8

## Environment 
- Linux Ubuntu 16.04.3 LTS environment required 

## Install Instructions
- Take base image and install: https://www.ubuntu.com/download/desktop

1. Update Environment 
    - sudo apt-get update 
    - sudo apt-get upgrade 
2. Java 8 Install 
    - sudo apt-get install default-jdk
3. Install SBT
    - echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list 
    - sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
    - sudo apt-get update
    - sudo apt-get install sbt
4. Install Apache Spark: 
    - https://www.apache.org/dyn/closer.lua/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz
5. tar -xzf spark-2.3.0-bin-hadoop2.7.tgz

## To Run
### Command Line
From within the activityanalysisservice folder run: 
- sbt clean run (command line arguments)

### IntelliJ
- Edit Configurations -> Add Configuration -> sbt Task 
- Then enter into Tasks: run

## Running in Spark Cluster
1. Make sure you have ssh installed
    - sudo apt-get install openssh-client openssh-server
2. Start the Spark Cluster
    - /spark-2.3.0-bin-hadoop2.7/sbin/start-all.sh
3. Build project into fat jar
    - sbt clean assembly (from within project folder)
4. Submit job to Spark: 
    - ./bin/spark-submit --class main.class.Name --master spark://clusterurl:port jar-file-path --command-line-arguments
5. To see job running visit: 
    - localhost:8080

#### Example call to submit a Spark Job to the CLuster
spark-2.3.0-bin-hadoop2.7/bin/spark-submit --class joehonour.newcastleuniversity.anomalydetectionservice.Main --master spark://34.242.118.196:7077 --executor-memory 500m ~/NewcastleUniversityDissertation/AnomalyDetectionService/anomalydetectionservice/target/scala-2.11/AnomalyDetectionService-assembly-0.1-SNAPSHOT.jar --master spark://34.242.118.196:7077 --spark_interval 10 --bootstrap_servers localhost:9092 --activity_analysis_topic activity_analysis  --anomaly_score_topic anomaly_score_output --activity_anomaly_k_amount 5
