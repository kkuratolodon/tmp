const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.status(200).send('Hello World!');
});

module.exports = app;

if (require.main === module) {
    const port = 3000;
    app.listen(port, () => {
        console.log(`Server is running at http://localhost:${port}`);
    });
}
