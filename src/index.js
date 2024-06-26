const app = require('./app');
const express = require('express');
const server = express();

server.use(app);

server.get('/', (req, res) => {
    const iconoSaludo = `
    <div align="center">
        <div class="tenor-gif-embed" data-postid="282704938762721238" data-share-method="host"
            data-aspect-ratio="1" data-width="20%"><a
                href="https://tenor.com/view/ai-bot-chatgpt-artificial-chat-gpt-gif-282704938762721238">Ai Bot Sticker</a>from
            <a href="https://tenor.com/search/ai-stickers">Ai Stickers</a></>
        <script type="text/javascript" async src="https://tenor.com/embed.js"></script>
        </div>
    </div>
    `;
    const mensajeBienvenida = '<div align="center"><h1>¡Bienvenido a mi API!</h1></div>';
    const enlaceDocumentacion = `
    <div align="center">
        <button align="center"><a href="https://github.com/jmorales01/hackathon-api/blob/master/doc.md">Ir a la documentación</a></button>
    </div>
    `;
    const contenidoHTML = `${iconoSaludo}${mensajeBienvenida}${enlaceDocumentacion}`;
    
    res.send(contenidoHTML);
});

const port = app.get('port');
server.listen(port, () => {
    console.log('Executing on port ' + port);
});
