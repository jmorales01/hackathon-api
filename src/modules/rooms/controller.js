const db = require('../../db/mysql');

const TABLA = 'rooms';
function getAll() {
    var query = `select * from salas`;
    return db.query(query);
}

function get_salas_by_teacher(id) {
    console.log('id',id)
    var query = `SELECT 
            s.id AS sala_id,
            s.nombre AS sala_nombre,
            s.max_participantes,
            COUNT(ps.id_estudiante) AS numero_participantes
        FROM salas s
        LEFT JOIN participacion_salas ps ON s.id = ps.id_sala
        WHERE s.id_curso = 2
        GROUP BY s.id, s.nombre, s.max_participantes`;
    console.log('query',query);
    return db.query(query);
}

module.exports = {
    getAll,
    get_salas_by_teacher
}