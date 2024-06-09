const express = require('express');
const response = require('../../network/result');
const controller = require('./controller');
const router = express.Router();

// Routes
router.get('/', all);


function all (req, res) {
    controller.getAll()
    .then((items) => {
        response.success(req, res, items, 200);
    });
};
router.get('/:id', (req, res) => {
    controller.getId(req.params.id)
    .then((items) => {
        response.success(req, res, items, 200);
    });
});
router.put('/', (req, res) => {
    controller.remove(req.body)
    .then((result) => {
        response.success(req, res, result, 200);
    });
});

router.post('/', (req, res) => {
    controller.create(req.body)
    .then((result) => {
        response.success(req, res, result, 201);
    });
});

module.exports = router;