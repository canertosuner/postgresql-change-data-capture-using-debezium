# postgresql-change-data-capture-using-debezium
PostgreSQL Change Data Capture (CDC) Using Debezium
![](http://www.canertosuner.com/image.axd?picture=/2020/dbzum_imgs_1.png)

1) Create containers
```
docker-compose up
```

2) Get-into postgresql container to create database & table
```
CREATE DATABASE payment;
\c payment
CREATE TABLE transaction(id SERIAL PRIMARY KEY, amount int, customerId varchar(36));
```

3) Define a postgres-connector 
```
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
```

4) Get-into kafka container to list the topic that you have created.
```
kafka-topics --zookeeper zookeeper:2181 --list
```

5) Create a consumer to consume db tracking messages
```
kafka-console-consumer --bootstrap-server kafka:9092 --from-beginning --topic dbserver1.public.transaction --property print.key=true --property key.separator="-"
```

6) Insert into transaction than update it
```
insert into transaction(id, amount,customerId) values(85, 87,'37b920fd-ecdd-7172-693a-d7be6db9792c');
update transaction set amount=77 where id=85
```



**You will see the messages consumed by consumer as blow;**

**Insert message-payload with "op" : "c"**
```
{
   "payload":{
      "before":null,
      "after":{
         "id":85,
         "amount":87,
         "customerid":"37b920fd-ecdd-7172-693a-d7be6db9792c"
      },
      "source":{
         "version":"1.0.2.Final",
         "connector":"postgresql",
         "name":"dbserver1",
         "ts_ms":1583931003883,
         "snapshot":"false",
         "db":"payment",
         "schema":"public",
         "table":"transaction",
         "txId":568,
         "lsn":23936360,
         "xmin":null
      },
      "op":"c",
      "ts_ms":1583931003889
   }
}
```


**Update message-payload with "op" : "u"**
```
{
   "payload":{
      "before":null,
      "after":{
         "id":85,
         "amount":77,
         "customerid":"37b920fd-ecdd-7172-693a-d7be6db9792c"
      },
      "source":{
         "version":"1.0.2.Final",
         "connector":"postgresql",
         "name":"dbserver1",
         "ts_ms":1583931065480,
         "snapshot":"false",
         "db":"payment",
         "schema":"public",
         "table":"transaction",
         "txId":569,
         "lsn":23936888,
         "xmin":null
      },
      "op":"u",
      "ts_ms":1583931065486
   }
}
```
