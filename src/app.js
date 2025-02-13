const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.status(200).send('Hello World!');
});

module.exports = app;

if (require.main === module) {
    const port = 3000;
    const host = '0.0.0.0';

    app.listen(port, host, () => {
        console.log(`Server is running at http://${host}:${port}`);
    });
}
