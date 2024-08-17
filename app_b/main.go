package main

import (
    "log"
    "net/http"
)

func main() {
    // Set up routes
    http.HandleFunc("/post-questions", postQuestionHandler)          // Endpoint for posting questions
    http.HandleFunc("/get-questions", getQuestionsHandler)           // Endpoint for getting all questions
    http.HandleFunc("/get-random-questions", getRandomQuestionsHandler) // Endpoint for getting random questions

    // Start the server
    log.Println("Server starting on :8080...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
