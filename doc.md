# Documentación de la API Hackathon 📝

"¡Bienvenido a la documentación de la API Hackathon! Esta API proporciona acceso a diversas funcionalidades para administrar salas y cursos en una plataforma educativa."


## Estructura de los archivos que esta devolviendo

```
{
    "error": false,
    "status": 200,
    "body": []
}

```

## Endpoints Disponibles

### GET [/salas](http://localhost:3001/api/rooms/)

"Este endpoint devuelve todas las salas disponibles en la base de datos."

#### Parámetros de consulta

"Ninguno"

#### Respuestas

- 200 OK: "Devuelve un arreglo JSON con todas las salas."

#### Ejemplo de Solicitud

```
http://localhost:3001/api/rooms/

```


### GET /salas/:id

"Este endpoint devuelve los detalles de una sala específica según su ID."

#### Parámetros de ruta

- `id`: "ID de la sala que se desea obtener."

#### Respuestas

- 200 OK: "Devuelve un objeto JSON con los detalles de la sala."
- 404 Not Found: "Si la sala con el ID especificado no se encuentra."
- 500 Internal Server Error: "Si ocurre un error al procesar la solicitud."

#### Ejemplo de Solicitud

```GET /salas/123```

### PUT /salas

"Este endpoint permite eliminar una sala de la base de datos."

#### Parámetros de cuerpo

- `id`: "ID de la sala que se desea eliminar."

#### Respuestas

- 200 OK: "Si la sala se elimina correctamente."
- 500 Internal Server Error: "Si ocurre un error al procesar la solicitud."

#### Ejemplo de Solicitud

```PUT /salas
Content-Type: application/json

```
    "id": 123
```
```

### POST /salas

"Este endpoint permite crear una nueva sala en la base de datos."

#### Parámetros de cuerpo

- `nombre`: "Nombre de la sala."
- `capacidad`: "Capacidad máxima de la sala."

#### Respuestas

- 201 Created: "Si la sala se crea correctamente."
- 500 Internal Server Error: "Si ocurre un error al procesar la solicitud."

#### Ejemplo de Solicitud

```POST /salas
Content-Type: application/json

```
    "nombre": "Sala de Conferencias",
    "capacidad": 50
```
```

### POST /salas/crear_salas

"Este endpoint permite crear múltiples salas de forma simultánea en la base de datos."

#### Parámetros de cuerpo

- `curso_id`: "ID del curso al que pertenecen las salas."
- `cantidad_salas`: "Cantidad de salas que se desean crear."
- `cantidad_alumnos_por_sala`: "Cantidad máxima de alumnos por sala."

#### Respuestas

- 201 Created: "Si las salas se crean correctamente."
- 500 Internal Server Error: "Si ocurre un error al procesar la solicitud."

#### Ejemplo de Solicitud

```POST /salas/crear_salas
Content-Type: application/json

```
    "curso_id": 456,
    "cantidad_salas": 3,
    "cantidad_alumnos_por_sala": 30
```
```

### GET /salas/get_salas_by_teacher/:teacher_id

"Este endpoint devuelve todas las salas asociadas a un profesor específico."

#### Parámetros de ruta

- `teacher_id`: "ID del profesor del que se desean obtener las salas."

#### Respuestas

- 200 OK: "Devuelve un arreglo JSON con todas las salas asociadas al profesor."
- 404 Not Found: "Si no se encuentran salas asociadas al profesor."
- 500 Internal Server Error: "Si ocurre un error al procesar la solicitud."

#### Ejemplo de Solicitud

```GET /salas/get_salas_by_teacher/789```

### GET /salas/asignar_sala_aleatorio/:id_curso

"Este endpoint asigna aleatoriamente a cada estudiante de un curso a una sala disponible."

#### Parámetros de ruta

- `id_curso`: "ID del curso para el que se desea asignar las salas."

#### Respuestas

- 200 OK: "Si se asignan correctamente las salas a los estudiantes."
- 500 Internal Server Error: "Si ocurre un error al procesar la solicitud."

#### Ejemplo de Solicitud

```GET /salas/asignar_sala_aleatorio/123```

## Enlace a la Documentación Completa

"Para obtener más detalles sobre cada endpoint y su funcionamiento, consulta la documentación completa [aquí](https://example.com)."



