curl -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '
{
 "name": "payment-connector",
 "config": {
 "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
 "tasks.max": "1",
 "database.hostname": "postgres",
 "database.port": "5432",
 "database.user": "appuser",
 "database.password": "qwerty",
 "database.dbname" : "payment",
 "database.server.name": "dbserver1",
 "database.whitelist": "payment",
 "database.history.kafka.bootstrap.servers": "kafka:9092",
 "database.history.kafka.topic": "schema-changes.payment"
 }
}'
