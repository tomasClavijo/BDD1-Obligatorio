-- Estudiantes
-- Clavijo, Tomas (235426)
-- Daneri, Franco (260284)
-- Nuccio, Marco (264844)


-- Ejercicio 1) 
--Obtener el nombre y localidad de aquellos vacunatorios que tuvieron solicitudes agendadas o finalizadas, pero no ambos estados, en julio de 2021

SELECT V.NOMBREVACUNATORIO, L.LOCALIDAD
FROM LOCALIDAD L, VACUNATORIO V, SOLICITUD S
WHERE L.CODLOC = V.CODLOC
AND S.IDVACUNATORIO = V.IDVACUNATORIO
AND S.FECHA >= TO_DATE('01/07/2021', 'DD/MM/YYYY')
AND S.FECHA <= TO_DATE('31/07/2021', 'DD/MM/YYYY')
AND S.ESTADOSOL = 'Agendada'
AND V.NOMBREVACUNATORIO NOT IN (SELECT DISTINCT V.NOMBREVACUNATORIO
                                FROM LOCALIDAD L, VACUNATORIO V, SOLICITUD S
                                WHERE L.CODLOC = V.CODLOC
                                AND S.IDVACUNATORIO = V.IDVACUNATORIO
                                AND S.FECHA >= TO_DATE('01/07/2021', 'DD/MM/YYYY')
                                AND S.FECHA <= TO_DATE('31/07/2021', 'DD/MM/YYYY')
                                AND S.ESTADOSOL = 'Finalizada')
UNION
SELECT V.NOMBREVACUNATORIO, L.LOCALIDAD
FROM LOCALIDAD L, VACUNATORIO V, SOLICITUD S
WHERE L.CODLOC = V.CODLOC
AND S.IDVACUNATORIO = V.IDVACUNATORIO
AND S.FECHA >= TO_DATE('01/07/2021', 'DD/MM/YYYY')
AND S.FECHA <= TO_DATE('31/07/2021', 'DD/MM/YYYY')
AND S.ESTADOSOL = 'Finalizada'
AND V.NOMBREVACUNATORIO NOT IN (SELECT DISTINCT V.NOMBREVACUNATORIO
                                FROM LOCALIDAD L, VACUNATORIO V, SOLICITUD S
                                WHERE L.CODLOC = V.CODLOC
                                AND S.IDVACUNATORIO = V.IDVACUNATORIO
                                AND S.FECHA >= TO_DATE('01/07/2021', 'DD/MM/YYYY')
                                AND S.FECHA <= TO_DATE('31/07/2021', 'DD/MM/YYYY')
                                AND S.ESTADOSOL = 'Agendada');

-- Ejercicio 2)
-- Obtener el nombre de los vacunatorios donde solamente se haya vacunado con Pfizer y que dichos vacunatorios no tengan solicitudes canceladas durante mayo de 2021.

SELECT DISTINCT V.NOMBREVACUNATORIO
FROM VACUNATORIO V, SOLICITUD S
WHERE V.IDVACUNATORIO = S.IDVACUNATORIO
AND V.NOMBREVACUNATORIO NOT IN (SELECT DISTINCT V.NOMBREVACUNATORIO
                                FROM VACUNATORIO V, SOLICITUD S
                                WHERE V.IDVACUNATORIO = S.IDVACUNATORIO
                                AND S.FECHAAGENDA >= TO_DATE('01/05/2021', 'DD/MM/YYYY')
                                AND S.FECHAAGENDA <= TO_DATE('31/05/2021', 'DD/MM/YYYY')
                                AND S.ESTADOSOL = 'Cancelada')
INTERSECT
SELECT DISTINCT V.NOMBREVACUNATORIO
FROM VACUNATORIO V, SOLICITUD S, TIPOVACUNA T
WHERE V.IDVACUNATORIO = S.IDVACUNATORIO
AND S.IDVACUNA = T.IDVACUNA
AND T.CODIGO = 'PFZ'
AND V.NOMBREVACUNATORIO NOT IN (SELECT DISTINCT V.NOMBREVACUNATORIO
                                FROM VACUNATORIO V, SOLICITUD S, TIPOVACUNA T
                                WHERE V.IDVACUNATORIO = S.IDVACUNATORIO
                                AND S.IDVACUNA = T.IDVACUNA
                                AND T.CODIGO <> 'PFZ');

-- Se puede evitar el "Intersect" colocando todo en un mismo Select, pero el tiempo de duración es considerablemte mayor.

-- Ejercicio 3)
-- Obtener el nombre, fecha de nacimiento y localidad de las personas que se anotaron con mayor antelación dentro de las solicitudes realizadas mediante agenda web. 
-- Considerar solo solicitudes no canceladas de personas a las que les corresponde la vacuna Sinovac.

SELECT P.NOMBRE, P.FECHANAC, L.LOCALIDAD
FROM LOCALIDAD L, PERSONA P, SOLICITUD S, TIPOVACUNA T
WHERE L.CODLOC = P.CODLOC
AND P.CI = S.CI 
AND S.IDVACUNA = T.IDVACUNA
AND S.ESTADOSOL <> 'Cancelada'
AND T.CODIGO = 'SVC'
AND S.FECHA IN (SELECT MIN(S.FECHA)
                FROM SOLICITUD S
                WHERE S.VIASOLICITUD = 'Web'); 
                
-- Ejercicio 4
-- Obtener el nombre de los vacunatorios para los cuales existen solicitudes canceladas y que dichas solicitudes hayan sido realizadas por más de una vía de agenda. Considerar los
--vacunatorios de Montevideo y las cancelaciones durante la primera quincena de mayo de 2021.

SELECT DISTINCT V.NOMBREVACUNATORIO
FROM VACUNATORIO V, SOLICITUD S, LOCALIDAD L
WHERE V.CODLOC = L.CODLOC
AND V.IDVACUNATORIO = S.IDVACUNATORIO
AND S.ESTADOSOL = 'Cancelada'
AND S.FECHAAGENDA >= TO_DATE('01/05/2021', 'DD/MM/YYYY')
AND S.FECHAAGENDA <= TO_DATE('15/05/2021', 'DD/MM/YYYY')
AND L.LOCALIDAD = 'Montevideo'
AND S.VIASOLICITUD = 'Web'
AND V.NOMBREVACUNATORIO IN (SELECT V.NOMBREVACUNATORIO
                            FROM VACUNATORIO V, SOLICITUD S, LOCALIDAD L
                            WHERE V.CODLOC = L.CODLOC
                            AND V.IDVACUNATORIO = S.IDVACUNATORIO
                            AND S.ESTADOSOL = 'Cancelada'
                            AND S.FECHAAGENDA >= TO_DATE('01/05/2021', 'DD/MM/YYYY')
                            AND S.FECHAAGENDA <= TO_DATE('15/05/2021', 'DD/MM/YYYY')
                            AND L.LOCALIDAD = 'Montevideo'
                            AND S.VIASOLICITUD <> 'Web')
UNION
SELECT DISTINCT V.NOMBREVACUNATORIO
FROM VACUNATORIO V, SOLICITUD S, LOCALIDAD L
WHERE V.CODLOC = L.CODLOC
AND V.IDVACUNATORIO = S.IDVACUNATORIO
AND S.ESTADOSOL = 'Cancelada'
AND S.FECHAAGENDA >= TO_DATE('01/05/2021', 'DD/MM/YYYY')
AND S.FECHAAGENDA <= TO_DATE('15/05/2021', 'DD/MM/YYYY')
AND L.LOCALIDAD = 'Montevideo'
AND S.VIASOLICITUD = 'Whatsapp'
AND V.NOMBREVACUNATORIO IN (SELECT V.NOMBREVACUNATORIO
                            FROM VACUNATORIO V, SOLICITUD S, LOCALIDAD L
                            WHERE V.CODLOC = L.CODLOC
                            AND V.IDVACUNATORIO = S.IDVACUNATORIO
                            AND S.ESTADOSOL = 'Cancelada'
                            AND S.FECHAAGENDA >= TO_DATE('01/05/2021', 'DD/MM/YYYY')
                            AND S.FECHAAGENDA <= TO_DATE('15/05/2021', 'DD/MM/YYYY')
                            AND L.LOCALIDAD = 'Montevideo'
                            AND S.VIASOLICITUD <> 'Whatsapp')
UNION
SELECT DISTINCT V.NOMBREVACUNATORIO
FROM VACUNATORIO V, SOLICITUD S, LOCALIDAD L
WHERE V.CODLOC = L.CODLOC
AND V.IDVACUNATORIO = S.IDVACUNATORIO
AND S.ESTADOSOL = 'Cancelada'
AND S.FECHAAGENDA >= TO_DATE('01/05/2021', 'DD/MM/YYYY')
AND S.FECHAAGENDA <= TO_DATE('15/05/2021', 'DD/MM/YYYY')
AND L.LOCALIDAD = 'Montevideo'
AND S.VIASOLICITUD = 'Teléfono'
AND V.NOMBREVACUNATORIO IN (SELECT V.NOMBREVACUNATORIO
                            FROM VACUNATORIO V, SOLICITUD S, LOCALIDAD L
                            WHERE V.CODLOC = L.CODLOC
                            AND V.IDVACUNATORIO = S.IDVACUNATORIO
                            AND S.ESTADOSOL = 'Cancelada'
                            AND S.FECHAAGENDA >= TO_DATE('01/05/2021', 'DD/MM/YYYY')
                            AND S.FECHAAGENDA <= TO_DATE('15/05/2021', 'DD/MM/YYYY')
                            AND L.LOCALIDAD = 'Montevideo'
                            AND S.VIASOLICITUD <> 'Teléfono');
                            
-- Ejercicio 5
-- Obtener las localidades que tengan a todos los ciudadanos que hayan solicitado vacunarse y cuya fecha de nacimiento sea entre el 01/01/1991 y el 31/12/1996 con estado de solicitud finalizada.
                     
(
SELECT distinct L.CODLOC, L.LOCALIDAD
FROM LOCALIDAD L, PERSONA P, SOLICITUD S
WHERE L.CODLOC = P.CODLOC
AND S.CI = P.CI
AND P.FECHANAC >= TO_DATE('01/01/1991', 'DD/MM/YYYY')
AND P.FECHANAC <= TO_DATE('31/12/1996', 'DD/MM/YYYY')
AND S.ESTADOSOL = 'Finalizada'
)
MINUS
(
SELECT distinct L.CODLOC, L.LOCALIDAD
                     FROM LOCALIDAD L, PERSONA P, SOLICITUD S
                     WHERE L.CODLOC = P.CODLOC
                     AND S.CI = P.CI
                     AND S.ESTADOSOL <> 'Finalizada'
)
MINUS
(
SELECT distinct L.CODLOC, L.LOCALIDAD
                     FROM PERSONA P, LOCALIDAD L, SOLICITUD S
                     WHERE L.CODLOC = P.CODLOC
                     AND S.CI = P.CI
                     AND S.ESTADOSOL = 'Finalizada'
                     AND (P.FECHANAC < TO_DATE('01/01/1991', 'DD/MM/YYYY')
                     OR P.FECHANAC > TO_DATE('31/12/1996', 'DD/MM/YYYY'))
);


-- Ejercicio 6
-- Mostrar los datos de las personas y el estado de sus solicitudes. Además, para las solicitudes en estado Agendada o Finalizada, mostrar la fecha de agenda. 
-- Para aquellas solicitudes pendientes mostrar el texto “Pendiente de agenda”. No incluir aquellas solicitudes que han sido canceladas.

SELECT P.*, S.ESTADOSOL, NVL(CAST(S.FECHAAGENDA AS VARCHAR(10)), 'Pendiente de agenda') AS FECHAAGENDA
FROM PERSONA P, SOLICITUD S
WHERE S.CI = P.CI
AND S.ESTADOSOL <> 'Cancelada';

-- Ejercicio 7
-- Obtener para cada localidad la cantidad de solicitudes por cada vía de solicitud. Tener en cuenta solo las localidades que tienen la menor cantidad de tipos de vacunas diferentes. 
-- Ordenar el resultado alfabéticamente por nombre de localidad y por cantidad de solicitudes ascendente.

SELECT L.LOCALIDAD, S.VIASOLICITUD, COUNT(S.VIASOLICITUD)
FROM SOLICITUD S, LOCALIDAD L, VACUNATORIO V
WHERE S.IDVACUNATORIO = V.IDVACUNATORIO
AND V.CODLOC = L.CODLOC 
AND V.IDVACUNATORIO IN (SELECT V.IDVACUNATORIO
                        FROM VACUNATORIO V, VACUNATORIOVACUNA W, LOCALIDAD L
                        WHERE V.IDVACUNATORIO = W.IDVACUNATORIO 
                        AND V.CODLOC = L.CODLOC
                        GROUP BY V.NOMBREVACUNATORIO, V.IDVACUNATORIO
                        ORDER BY COUNT (W.IDVACUNA)
                        FETCH NEXT 1 ROWS WITH TIES)
GROUP BY L.LOCALIDAD, S.VIASOLICITUD
ORDER BY L.LOCALIDAD;

-- Ejercicio 8
-- Obtener las localidades que tengan la mayor cantidad de personas vacunadas. Se entiende que las personas que recibieron la dosis son aquellas cuya solicitud está finalizada. 
-- Considerar solo las localidades que tienen más de 10.000 habitantes

SELECT V.LOCALIDAD
FROM SOLICITUD S, VACUNATORIO V, LOCALIDAD L
WHERE S.IDVACUNATORIO = V.IDVACUNATORIO
AND L.CODLOC = V.CODLOC
AND V.CODLOC IN (SELECT CODLOC
                 FROM PERSONA
                 GROUP BY CODLOC
                 HAVING COUNT(*) >= 10000)
GROUP BY V.CODLOC
ORDER BY COUNT(*) DESC
FETCH NEXT 1 ROWS WITH TIES;

-- Ejercicio 9
-- Obtener el nombre de los vacunatorios donde se vacune con la menor cantidad de tipos de vacuna y que dichos vacunatorios hayan tenido la mayor cantidad de solicitudes de agenda en junio de 2021.

(SELECT V.NOMBREVACUNATORIO
FROM VACUNATORIO V, VACUNATORIOVACUNA W
WHERE V.IDVACUNATORIO = W.IDVACUNATORIO
GROUP BY V.NOMBREVACUNATORIO, V.IDVACUNATORIO
ORDER BY COUNT (W.IDVACUNA)
FETCH NEXT 1 ROWS WITH TIES)
INTERSECT
(SELECT V.NOMBREVACUNATORIO
FROM SOLICITUD S, VACUNATORIO V
WHERE S.IDVACUNATORIO = V.IDVACUNATORIO
AND S.FECHA >= TO_DATE('01/06/2021', 'DD/MM/YYYY')
AND S.FECHA <= TO_DATE('30/06/2021', 'DD/MM/YYYY')
GROUP BY V.NOMBREVACUNATORIO, V.IDVACUNATORIO
ORDER BY COUNT (*)
FETCH NEXT 1 ROWS WITH TIES);


-- Ejercicio 10
-- Obtener para cada tipo de vacuna la cantidad total de solicitudes por vía de solicitud. Obtener el porcentaje que representan estas cantidades sobre el total general de solicitudes. 
-- Además, obtener el nombre del vacunatorio donde se realizaron la mayor cantidad de solicitudes del tipo de vacuna asociado.

select tv.codigo, s.viasolicitud, count(*) CantSol, round(100*(count(*) / sum(count(*)) over ()), 1) || '%' PrcSol, v.nombrevacunatorio from Solicitud s
join Tipovacuna tv on tv.idvacuna = s.idvacuna
join Vacunatorio v on v.idvacunatorio = s.idvacunatorio
join Vacunatoriovacuna vv on vv.idvacunatorio = s.idvacunatorio
where v.nombrevacunatorio in (select v1.nombrevacunatorio from Vacunatorio v1
                                join Solicitud s1 on v1.idvacunatorio = s1.idvacunatorio
                                where s1.idvacuna = s.idvacuna
                                group by v1.nombrevacunatorio
                                having count(*) = (select max(count(*)) from Vacunatorio v2
                                                    join Solicitud s2 on v2.idvacunatorio = s2.idvacunatorio
                                                    where s2.idvacuna = s.idvacuna
                                                    group by v2.nombrevacunatorio))
group by tv.codigo, s.viasolicitud, v.nombrevacunatorio
order by tv.codigo, s.viasolicitud, v.nombrevacunatorio;

