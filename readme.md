# Hackathon Devs 404 API 🚀

¡Bienvenidos al repositorio de Hackathon Devs 404 API! Este proyecto ha sido desarrollado durante la Hackathon organizada por el equipo de EXPEDITION. Nuestro objetivo es crear soluciones innovadoras y de alto impacto que resuelvan problemas reales utilizando tecnología de vanguardia. ¡Esperamos que disfruten explorando nuestro trabajo

## Estadísticas del Repositorio 📊

![Estado del Proyecto](https://img.shields.io/badge/estado-en%20desarrollo-brightgreen)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![GitHub stars](https://img.shields.io/github/stars/jmorales01/hackaton-devs-404)
![GitHub PRs](https://img.shields.io/github/issues-pr/jmorales01/hackaton-devs-404)
![GitHub forks](https://img.shields.io/github/forks/jmorales01/hackaton-devs-404)
![GitHub issues](https://img.shields.io/github/issues/jmorales01/hackaton-devs-404)


## Estructura del Proyecto 🗂️

📁 Proyecto
├── 📁 src
│   ├── 📄 server.js
│   ├── 📁 routes
│   │   ├── 📄 index.js
│   │   └── 📄 otherRoute.js
│   ├── 📁 controllers
│   │   ├── 📄 mainController.js
│   │   └── 📄 otherController.js
│   └── 📁 models
│       ├── 📄 userModel.js
│       └── 📄 otherModel.js
└── 📁 assets
    ├── 🖼️ image1.jpg
    ├── 🖼️ image2.png
    └── 📄 styles.css



## Tecnologías Utilizadas 💻

- **MySQL** (v8.0.27) [![MySQL](https://img.icons8.com/color/48/000000/mysql.png)](https://www.mysql.com/)
- **Node.js** (v14.17.5) [![Node.js](https://img.icons8.com/color/48/000000/nodejs.png)](https://nodejs.org/)
- **npm** (v7.24.0) [![npm](https://img.icons8.com/color/48/000000/npm.png)](https://www.npmjs.com/)
- **Express** (v4.17.1) [![Express](https://img.icons8.com/color/48/000000/express.png)](https://expressjs.com/)
- **Docker** (v20.10.8) [![Docker](https://img.icons8.com/color/48/000000/docker.png)](https://www.docker.com/)



## Instalación y Configuración 🛠️

Siga los siguientes pasos para configurar el proyecto localmente:


1. **Instalar Node.js y npm**: Si aún no tienes Node.js y npm instalados en tu máquina, puedes descargarlos e instalarlos desde [nodejs.org](https://nodejs.org/).
2. Clone el repositorio:
   ```bash
   https://github.com/jmorales01/hackathon-api.git
   ```
3. Navegue al directorio del proyecto:
   ```bash
   cd hackathon-api
   ```
4. Abre en tu editor favorito:
   ```bash
   code .
   ```
5. Ejecute el siguiente comando en la raíz del proyecto para levantar los contenedores:
   ```bash
   docker-compose up -d phpmyadmin db
   ```
6. Instale las dependencias del proyecto:
   ```bash
   npm install
   ```
7. Ejecute el proyecto:
   ```bash
   npm start
   ```
8. Acceda a la api en su navegador en http://localhost:3001/.
9. Acceda a phpMyAdmin en su navegador en http://localhost:8000.

¡Ahora deberías tener el proyecto en funcionamiento en tu máquina local! 🚀


### Posibles Soluciones a Problemas 🔧

- **Error de conexión a la base de datos:**
  - Asegúrese de que el contenedor de la base de datos está en ejecución.
  - Verifique los detalles de conexión (nombre de usuario, contraseña, nombre de la base de datos) en el archivo `docker-compose.yml`.

- **Problemas de permisos con volúmenes:**
  - Asegúrese de que los directorios locales `./dump` y `./conf` tienen los permisos adecuados.
  - Verifique que el usuario de Docker tiene los permisos necesarios para acceder a los volúmenes.

- **Contenedores no se inician correctamente:**
  - Ejecute `docker-compose logs` para ver los registros de los contenedores y diagnosticar el problema.
  - Asegúrese de que no hay conflictos de puertos con otros servicios en su máquina.


## Documentación 📝

1. Ir a la documentación de la API [DOC](https://github.com/jmorales01/hackathon-api/blob/master/doc.md).


## Contribución 🤝

¡Las contribuciones son bienvenidas! Por favor, siga estos pasos para contribuir al proyecto:

1. Fork el repositorio
2. Cree una nueva rama (`git checkout -b feature/nueva-funcionalidad`)
3. Realice los cambios necesarios y haga commit (`git commit -m 'Agrega nueva funcionalidad'`)
4. Envíe los cambios a su fork (`git push origin feature/nueva-funcionalidad`)
5. Cree una solicitud de pull

### Contribuyentes ✨

- [![Usuario1](https://avatars.githubusercontent.com/u/usuario1?v=3&s=48)](https://github.com/usuario1) [Usuario1](https://github.com/usuario1)

## Licencia 📄

Este proyecto está bajo la licencia MIT. Consulte el archivo [LICENSE](LICENSE) para más detalles.

---

##¡Gracias por visitar nuestro repositorio Devs 404! 🌟🧑‍💻


---
<div align="center">
  <img src="./public/images/devs 404.jpg">
</div>
