package handler

import (
    "context"
    "encoding/json"
    "fmt"
    "io/ioutil"
    "log"
    "net/http"
    "strconv"

    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
)

// MongoDB connection string
const connStr = "mongodb+srv://thribhuvan09:rohith205@cluster0.2x4rd.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

// Question represents a question in the MongoDB database
type Question struct {
    ID             string `json:"id,omitempty" bson:"_id,omitempty"`
    Question       string `json:"question" bson:"question"`
    OptionA        string `json:"option_a" bson:"option_a"`
    OptionB        string `json:"option_b" bson:"option_b"`
    OptionC        string `json:"option_c" bson:"option_c"`
    OptionD        string `json:"option_d" bson:"option_d"`
    CorrectAnswer  string `json:"correct_answer" bson:"correct_answer"`
    Difficulty     string `json:"difficulty" bson:"difficulty"`
    Hint           string `json:"hint" bson:"hint"`
}

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

// postQuestionHandler handles POST requests to add questions to the database
func postQuestionHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodPost {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    body, err := ioutil.ReadAll(r.Body)
    if err != nil {
        http.Error(w, "Error reading request body", http.StatusBadRequest)
        return
    }

    var questions []Question
    if err := json.Unmarshal(body, &questions); err != nil {
        http.Error(w, "Error parsing request body", http.StatusBadRequest)
        return
    }

    db, err := ConnectDB()
    if err != nil {
        http.Error(w, "Database connection error", http.StatusInternalServerError)
        return
    }

    collection := db.Collection("questions")

    var docs []interface{}
    for _, question := range questions {
        docs = append(docs, question)
    }

    _, err = collection.InsertMany(context.TODO(), docs)
    if err != nil {
        http.Error(w, "Error inserting questions into database", http.StatusInternalServerError)
        return
    }

    w.WriteHeader(http.StatusCreated)
    fmt.Fprintln(w, "Questions added successfully")
}

// getQuestionsHandler handles GET requests to retrieve all questions
func getQuestionsHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    db, err := ConnectDB()
    if err != nil {
        http.Error(w, "Database connection error", http.StatusInternalServerError)
        return
    }

    collection := db.Collection("questions")

    cursor, err := collection.Find(context.TODO(), bson.M{})
    if err != nil {
        http.Error(w, "Error querying database", http.StatusInternalServerError)
        return
    }
    defer cursor.Close(context.TODO())

    var questions []Question
    if err = cursor.All(context.TODO(), &questions); err != nil {
        http.Error(w, "Error scanning rows", http.StatusInternalServerError)
        return
    }

    response, err := json.Marshal(questions)
    if err != nil {
        http.Error(w, "Error marshalling JSON", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    w.Write(response)
}

// getRandomQuestionsHandler handles GET requests to retrieve a random set of questions
func getRandomQuestionsHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    difficulty := r.URL.Query().Get("difficulty")
    numQuestionsStr := r.URL.Query().Get("num")
    
    numQuestions, err := strconv.Atoi(numQuestionsStr)
    if err != nil || numQuestions <= 0 {
        http.Error(w, "Invalid number of questions", http.StatusBadRequest)
        return
    }

    db, err := ConnectDB()
    if err != nil {
        http.Error(w, "Database connection error", http.StatusInternalServerError)
        return
    }

    collection := db.Collection("questions")

    pipeline := mongo.Pipeline{
        {{"$match", bson.D{{"difficulty", difficulty}}}},
        {{"$sample", bson.D{{"size", numQuestions}}}},
    }

    cursor, err := collection.Aggregate(context.TODO(), pipeline)
    if err != nil {
        http.Error(w, "Error querying database", http.StatusInternalServerError)
        return
    }
    defer cursor.Close(context.TODO())

    var questions []Question
    if err = cursor.All(context.TODO(), &questions); err != nil {
        http.Error(w, "Error scanning rows", http.StatusInternalServerError)
        return
    }

    response, err := json.Marshal(questions)
    if err != nil {
        http.Error(w, "Error marshalling JSON", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    w.Write(response)
}

func Handler(w http.ResponseWriter, r *http.Request) {
    switch r.URL.Path {
    case "/post-questions":
        postQuestionHandler(w, r)
    case "/get-questions":
        getQuestionsHandler(w, r)
    case "/get-random-questions":
        getRandomQuestionsHandler(w, r)
    default:
        w.Write([]byte("Server working!"))
    }
}

func main() {
    
    http.HandleFunc("/", Handler)

    port := ":8080"
    log.Printf("Server starting on %s...", port)
    log.Fatal(http.ListenAndServe(port, nil))
}