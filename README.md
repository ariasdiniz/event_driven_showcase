# Event Driven Application Showcase in Ruby and Amazon SQS

I made this project with the objective of implement two applications with
low coupling. One app is responsible to generate events with
information received from a Post endpoint. The other application 
consumes the events via SQS and save them in a DynamoDB table. Also,
there is a Get endpoint in the consumer app to list the items in the table.

Post Request to generate events on the producer:
```shell
curl --location --request POST 'localhost:8081/create_new_user' \
--header 'Content-Type: application/json' \
--data-raw '{
    "primary_id": "test",
    "secondary_id": "test"
}'
```

Get request to get items from the database in the consumer:
```shell
curl --location --request GET 'localhost:8080/list'
```

For this project I used Amazon SQS for the queue, DynamoDB for the database
and Macaw Framework for the REST endpoints.
