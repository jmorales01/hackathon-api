const db = require('../../db/mysql');

const TABLA = 'chats';

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


module.exports = {
    getAll,
    getId,
    remove,
    create
}