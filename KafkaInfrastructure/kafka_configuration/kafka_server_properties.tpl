broker.id=${broker_id}

num.network.threads=3
num.io.threads=8
advertised.listeners=PLAINTEXT://${kafka_public_ip}:${kafka_port}

socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600

log.dirs=/tmp/kafka-logs
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000

num.partitions=1
num.recovery.threads.per.data.dir=1

offsets.topic.replication.factor=1

transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1

zookeeper.connect=${zookeeper_connection_url}
zookeeper.connection.timeout.ms=6000

group.initial.rebalance.delay.ms=0
