const db = require('../../db/mysql');

const TABLA = 'clients';
function getAll() {
    return db.query('SELECT * FROM profesores where id = 1');
}

function get(id) {
    return db.get(TABLA, id);
}

module.exports = {
    getAll
}