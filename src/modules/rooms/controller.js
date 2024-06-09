const db = require('../../db/mysql');

const TABLA = 'salas';
function getAll() {
    var query = `select * from salas`;
    return db.query(query);
}
function getId(id) {
    return db.get(TABLA, id);
}
function remove(body) {
    const { id } = body
    return db.remove(TABLA, id);
}
function create(body) {
    return db.create(TABLA, body);
}
function crearSalas(curso_id, cantidad_salas, cantidad_alumnos_por_sala) {
    const query = `CALL crear_salas(?, ?, ?)`;
    return db.query(query, [curso_id, cantidad_salas, cantidad_alumnos_por_sala]);
}

function getSalas(id) {
    var query = `SELECT 
            s.id AS sala_id,
            s.nombre AS sala_nombre,
            s.max_participantes,
            COUNT(ps.id_estudiante) AS numero_participantes
        FROM salas s
        LEFT JOIN participacion_salas ps ON s.id = ps.id_sala
        WHERE s.id_curso = ?
        GROUP BY s.id, s.nombre, s.max_participantes`;

    return db.query(query, [id]);
}

function asignarSalaAleatorio(id_curso) {
    const query = `CALL asignar_estudiantes_a_salas_aleatorio(?)`;
    return db.query(query, [id_curso]);
}

module.exports = {
    getAll,
    getId,
    remove,
    create,
    crearSalas,
    getSalas,
    asignarSalaAleatorio
}