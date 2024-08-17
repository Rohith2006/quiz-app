package main

import (
    "context"
    "log"

    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

// MongoDB connection string
const connStr = "mongodb+srv://thribhuvan09:rohith205@cluster0.2x4rd.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

// ConnectDB establishes a connection to the MongoDB database
func ConnectDB() (*mongo.Database, error) {
    clientOptions := options.Client().ApplyURI(connStr)
    client, err := mongo.Connect(context.TODO(), clientOptions)
    if err != nil {
        return nil, err
    }

    // Check the connection
    err = client.Ping(context.TODO(), nil)
    if err != nil {
        return nil, err
    }

    log.Println("Successfully connected to MongoDB!")
    return client.Database("railway"), nil
}
