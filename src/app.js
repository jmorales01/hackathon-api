const express = require('express');
const morgan = require('morgan');
const config = require('./config');

// Routes
const clients = require('./modules/clients/routes');
const activities = require('./modules/activities/routes');
const rooms = require('./modules/rooms/routes');

const app = express();

// Middlewares
app.set('port', config.app.port);
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(morgan('dev'));

// Routes
app.use('/api/clients', clients);
app.use('/api/activities', activities);
app.use('/api/rooms', rooms);


module.exports = app;