const express = require('express');
const response = require('../../network/result');
const controller = require('./controller');

const router = express.Router();

router.get('/', (req, res) => {
    controller.getAll()
    .then((items) => {
        response.success(req, res, items, 200);
    });
});

module.exports = router;