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

router.post('/crear_tarea', (req, res) => {
    const { id_sala, nombre, descripcion, asignado_a, estado } = req.body;
    controller.crearTarea(id_sala, nombre, descripcion, asignado_a, estado)
    .then((result) => {
        response.success(req, res, result, 201);
    })
    .catch((error) => {
        response.error(req, res, 'Error creando tarea', 500, error);
    });
});

router.get('/get_salas_by_teacher/:teacher_id', (req, res) => {
    const teacher_id = req.params.teacher_id;
    controller.getSalas(teacher_id)
    .then((result) => {
        response.success(req, res, result, 200);
    });
});

router.get('/asignar_sala_aleatorio/:id_curso', (req, res) => {
    const id_curso = req.params.id_curso;
    controller.asignarSalaAleatorio(id_curso)
    .then((result) => {
        response.success(req, res, result, 200);
    });
});

module.exports = router;