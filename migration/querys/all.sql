
-- Procedimiento para traer todos los datos de las salas que están asignadas a cada curso.
SELECT 
    s.id AS sala_id,
    s.nombre AS sala_nombre,
    s.max_participantes,
    COUNT(ps.id_estudiante) AS numero_participantes
FROM salas s
LEFT JOIN participacion_salas ps ON s.id = ps.id_sala
WHERE s.id_curso = 1
GROUP BY s.id, s.nombre, s.max_participantes;


