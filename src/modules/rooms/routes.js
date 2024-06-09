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
router.get('/get_salas_by_teacher/:teacher_id', (req, res) => {
    const teacher_id = req.params.teacher_id
    controller.get_salas_by_teacher(teacher_id)
    .then((items) => {
        response.success(req, res, items, 200);
    });
});

module.exports = router;