const mysql = require('mysql2');
const config = require('../config');

const dbConfig = {
    host: config.mysql.host,
    user: config.mysql.user,
    password: config.mysql.password,
    database: config.mysql.database
}


let connection;

function connect() {
    connection = mysql.createConnection(dbConfig);

    connection.connect((err) => {
        if (err) {
            console.log(err);
            setTimeout(connect, 2000);
        }else{
            console.log('DB connected');
        }
    });

    connection.on('error', (err) => {
        console.log(err);
        if (err.code === 'PROTOCOL_CONNECTION_LOST') {
            connect();
        } else {
            throw err;
        }
    });
}
function disconnect(connection) {
    connection.end();
}

connect();

function all(tabla){
    return new Promise((resolve, reject) => {
        connection.query('SELECT * FROM ' + tabla + '', (err, rows) => {
            if (err) {
                reject(err);
            } else {   
                resolve(rows);  
            }
        });
    });
}
function get(tabla,id){
    return new Promise((resolve, reject) => {
        connection.query(`SELECT * FROM ${tabla} WHERE id = ${id}`, (err, rows) => {
            if (err) {
                reject(err);
            } else {   
                resolve(rows);  
            }
        });
    })
}
function remove(tabla,id){
    return new Promise((resolve, reject) => {
        connection.query(`DELETE FROM ${tabla} WHERE id = ?`, [id], (err, rows) => {
            if (err) {
                reject(err);
            } else {   
                resolve(rows);  
            }
        });
    })
}
function update(tabla, data) {
    return new Promise((resolve, reject) => {
        connection.query(`UPDATE ${tabla} SET ? WHERE id = ?`, [data, data.id], (err, rows) => {
            if (err) {
                reject(err);
            } else {   
                resolve(rows);  
            }
        });
    });
}
function insert(tabla, data) {
    return new Promise((resolve, reject) => {
        connection.query('INSERT INTO ' + tabla + ' SET ?', [data], (err, rows) => {
            if (err) {
                reject(err);
            } else {   
                resolve(rows);  
            }
        });
    });
}

function create(tabla, data) {
    if(data.id){
        return update(tabla, data);
    }else{
        return insert(tabla, data);
    }
}

function query(sql, params) {
    return new Promise((resolve, reject) => {
        connection.query(sql, params, (err, rows) => {
            if (err) {
                reject(err);
            } else {   
                resolve(rows);  
            }
        });
    });
}

module.exports = {
    all,
    get,
    remove,
    disconnect,
    query,
    create,
    insert,
    update
}