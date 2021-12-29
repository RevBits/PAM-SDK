/* ----------------------------------- */
/* Module and Environment dependencies */
/* ----------------------------------- */
const express = require('express');

const getSecret = require('../index')
/* ----------------------------------- */
/* Initializing Express App */
/* ----------------------------------- */
const app = express();

/* ----------------------------------- */
/* Starting http server with the port  */
/* ----------------------------------- */
const port = process.env.PORT || 5000;
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

app.get('/', async (req, res) => {
    const sec = await getSecret('https://enpast.com', 'secret', '36210901e431c3c9e35ebb6a5e197d4bff809b6d3f32590cfca2536d3496526bb0daa9f047213ecbfe61ea32bbb3044f3a11a1da63f8f3b5f67c96a30836c799')
    console.log(sec)
    res.send(sec)
})
