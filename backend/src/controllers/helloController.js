const sayHello = (req, res) => {
    res.status(200).json({ message: 'Hello, World!' });
};

module.exports = { sayHello };
