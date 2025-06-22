import express from 'express';

const app = express();
const PORT = process.env.PORT || 8001;

app.get('/', (_, res) => {
    res.send('Hello World from Express!');
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});

