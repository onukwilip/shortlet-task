import express from "express";
import cors from "cors";

const app = express();
const PORT = 5000;

app.use(cors());

// * Returns the current date
app.get("/", (req, res) => res.json(new Date()));

app.listen(PORT, () => console.log(`App listening on port ${PORT}!`));
