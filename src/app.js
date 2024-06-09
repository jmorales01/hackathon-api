const express = require('express');
const morgan = require('morgan');
const config = require('./config');
const cors = require('cors');

const app = express();

app.use(cors({
    origin: 'http://localhost:5174'
}));

// Middlewares
app.set('port', config.app.port);
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(morgan('dev'));

// Routes
const rooms = require('./modules/rooms/routes');
const tasks = require('./modules/tasks/routes');
const chats = require('./modules/chats/routes');
const courses = require('./modules/courses/routes');
const students = require('./modules/students/routes');
const teachers = require('./modules/teachers/routes');

app.use('/api/rooms', rooms);
app.use('/api/tasks', tasks);
app.use('/api/chats', chats);
app.use('/api/courses', courses);
app.use('/api/students', students);
app.use('/api/teachers', teachers);

module.exports = app;