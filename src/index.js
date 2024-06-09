const app = require('./app');


app.listen(app.get('port'), () => {
    console.log('Executing on port ' + app.get('port'));
})