const db = require('../../db/mysql');

const TABLA = 'cursos';

function getAll() {
    return db.all(TABLA);
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
function getCoursesByTeacher(id) {
    var query = `
        SELECT 
            c.id AS id_curso, 
            c.nombre AS nombre_curso, 
            c.descripcion, 
            c.img, 
            c.id_profesor, 
            p.nombre AS nombre_profesor, 
            p.email AS email_profesor
        FROM cursos as c
        JOIN profesores as p ON c.id_profesor = p.id
        WHERE p.id = ?;
        `;
    return db.query(query, [id]);
}


module.exports = {
    getAll,
    getId,
    remove,
    create,
    getCoursesByTeacher
}