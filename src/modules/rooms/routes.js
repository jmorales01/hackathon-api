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

router.post('/crear_salas', (req, res) => {
    const { curso_id, cantidad_salas, cantidad_alumnos_por_sala } = req.body;
    controller.crearSalas(curso_id, cantidad_salas, cantidad_alumnos_por_sala)
    .then((result) => {
        response.success(req, res, result, 201);
    })
    .catch((error) => {
        response.error(req, res, 'Error creando salas', 500, error);
    });
});

router.get('/get_salas_by_courses/:course_id', (req, res) => {
    const course_id = req.params.course_id;
    controller.getSalasByCourses(course_id)
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

router.post('/unir_sala', (req, res) => {
    const { id_estudiante, id_curso, id_sala } = req.body;
    controller.unirSala(id_estudiante, id_curso, id_sala)
    .then((result) => {
        response.success(req, res, result, 200);
    }); 
});

module.exports = router;

