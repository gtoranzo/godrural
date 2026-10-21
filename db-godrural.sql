-- =========================================================
-- BASE DE DATOS: gobernanza_rural
-- Motor: PostgreSQL 13+
-- =========================================================

CREATE DATABASE gobernanza_rural
    WITH ENCODING 'UTF8'
    LC_COLLATE='es_ES.UTF-8'
    LC_CTYPE='es_ES.UTF-8'
    TEMPLATE=template0;

\c gobernanza_rural;

-- =========================================================
-- 1. IDENTIFICACIÓN TERRITORIAL
-- =========================================================

CREATE TABLE territorio (
    id_territorio          SERIAL PRIMARY KEY,
    codigo_comunidad       VARCHAR(20) UNIQUE NOT NULL,
    nombre_comunidad       VARCHAR(150) NOT NULL,
    municipio              VARCHAR(100) NOT NULL,
    consejo_popular        VARCHAR(100),
    asentamiento           VARCHAR(150) NOT NULL,
    tipologia_rural        VARCHAR(50),          -- costero, montaña, llano, periurbano...
    latitud                NUMERIC(10,7),
    longitud               NUMERIC(10,7),
    poblacion_total        INTEGER CHECK (poblacion_total >= 0),
    fecha_registro         DATE DEFAULT CURRENT_DATE,
    activo                 BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_territorio_municipio ON territorio(municipio);
CREATE INDEX idx_territorio_asentamiento ON territorio(asentamiento);

-- =========================================================
-- 2. ACTORES DE LA RED COMUNITARIA
-- =========================================================

CREATE TABLE tipo_actor (
    id_tipo_actor          SERIAL PRIMARY KEY,
    nombre                 VARCHAR(50) UNIQUE NOT NULL
    -- Comunidad, Cooperativa, Empresa, Gobierno local,
    -- Universidad, ONG, Proyecto de desarrollo, Productor individual
);

INSERT INTO tipo_actor(nombre) VALUES
 ('Comunidad'),('Cooperativa'),('Empresa'),('Gobierno local'),
 ('Universidad'),('ONG'),('Proyecto de desarrollo'),('Productor individual');

CREATE TABLE actor_comunitario (
    id_actor               SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    id_tipo_actor          INTEGER NOT NULL REFERENCES tipo_actor(id_tipo_actor),
    nombre                 VARCHAR(150) NOT NULL,
    rol_en_red             VARCHAR(100),         -- líder, articulador, facilitador, beneficiario...
    nivel_influencia       SMALLINT CHECK (nivel_influencia BETWEEN 1 AND 5),
    nivel_participacion    SMALLINT CHECK (nivel_participacion BETWEEN 1 AND 5),
    contacto               VARCHAR(150),
    fecha_alta             DATE DEFAULT CURRENT_DATE,
    activo                 BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_actor_territorio ON actor_comunitario(id_territorio);
CREATE INDEX idx_actor_tipo ON actor_comunitario(id_tipo_actor);

-- =========================================================
-- 3. CAPITAL SOCIAL Y RELACIONES
-- =========================================================

CREATE TABLE tipo_vinculo (
    id_tipo_vinculo        SERIAL PRIMARY KEY,
    nombre                 VARCHAR(50) UNIQUE NOT NULL
    -- formal, informal, cooperación, conflicto, comercial, familiar...
);

INSERT INTO tipo_vinculo(nombre) VALUES
 ('Formal'),('Informal'),('Cooperación'),('Comercial'),('Conflicto'),('Familiar');

CREATE TABLE relacion_red (
    id_relacion            SERIAL PRIMARY KEY,
    id_actor_origen        INTEGER NOT NULL REFERENCES actor_comunitario(id_actor) ON DELETE CASCADE,
    id_actor_destino       INTEGER NOT NULL REFERENCES actor_comunitario(id_actor) ON DELETE CASCADE,
    id_tipo_vinculo        INTEGER REFERENCES tipo_vinculo(id_tipo_vinculo),
    intensidad_relacion    SMALLINT CHECK (intensidad_relacion BETWEEN 1 AND 5),
    frecuencia_interaccion VARCHAR(30),          -- diaria, semanal, mensual, esporádica
    confianza_percibida    SMALLINT CHECK (confianza_percibida BETWEEN 1 AND 5),
    mecanismo_cooperacion  TEXT,
    es_formal              BOOLEAN DEFAULT FALSE,
    liderazgo_comunitario  BOOLEAN DEFAULT FALSE,
    fecha_registro         DATE DEFAULT CURRENT_DATE,
    CONSTRAINT chk_actores_distintos CHECK (id_actor_origen <> id_actor_destino)
);

CREATE INDEX idx_relacion_origen ON relacion_red(id_actor_origen);
CREATE INDEX idx_relacion_destino ON relacion_red(id_actor_destino);

-- =========================================================
-- 4. GOBERNANZA TERRITORIAL
-- =========================================================

CREATE TABLE espacio_gobernanza (
    id_espacio             SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    nombre                 VARCHAR(150) NOT NULL,    -- Consejo, Asamblea, Grupo gestor...
    tipo                   VARCHAR(50),              -- formal / informal
    frecuencia_reunion     VARCHAR(30),
    nivel_transparencia    SMALLINT CHECK (nivel_transparencia BETWEEN 1 AND 5),
    nivel_rendicion_cuenta SMALLINT CHECK (nivel_rendicion_cuenta BETWEEN 1 AND 5),
    gestion_conflictos     TEXT,
    fecha_creacion         DATE
);

CREATE TABLE mecanismo_participacion (
    id_mecanismo           SERIAL PRIMARY KEY,
    id_espacio             INTEGER NOT NULL REFERENCES espacio_gobernanza(id_espacio) ON DELETE CASCADE,
    nombre                 VARCHAR(150) NOT NULL,    -- consulta, presupuesto participativo, asamblea...
    tipo_decision          VARCHAR(50),              -- consultiva, deliberativa, vinculante
    incluye_actores        TEXT,
    activo                 BOOLEAN DEFAULT TRUE
);

CREATE TABLE participacion_actor (
    id_participacion       SERIAL PRIMARY KEY,
    id_actor               INTEGER NOT NULL REFERENCES actor_comunitario(id_actor) ON DELETE CASCADE,
    id_espacio             INTEGER NOT NULL REFERENCES espacio_gobernanza(id_espacio) ON DELETE CASCADE,
    rol                    VARCHAR(80),
    frecuencia             VARCHAR(30),
    fecha_inicio           DATE,
    fecha_fin              DATE
);

-- =========================================================
-- 5. RECURSOS TERRITORIALES
-- =========================================================

CREATE TABLE categoria_recurso (
    id_categoria_recurso   SERIAL PRIMARY KEY,
    nombre                 VARCHAR(60) UNIQUE NOT NULL
    -- Natural, Productivo, Financiero, Infraestructura,
    -- Cultural/Patrimonial, Tecnológico, Humano
);

INSERT INTO categoria_recurso(nombre) VALUES
 ('Natural'),('Productivo'),('Financiero'),('Infraestructura'),
 ('Cultural y patrimonial'),('Tecnológico'),('Humano');

CREATE TABLE recurso_territorial (
    id_recurso             SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    id_categoria_recurso   INTEGER NOT NULL REFERENCES categoria_recurso(id_categoria_recurso),
    nombre                 VARCHAR(150) NOT NULL,
    descripcion            TEXT,
    cantidad               NUMERIC(14,2),
    unidad_medida          VARCHAR(40),
    estado                 VARCHAR(30),              -- disponible, en uso, degradado
    fecha_actualizacion    DATE DEFAULT CURRENT_DATE
);

-- =========================================================
-- 6. INNOVACIÓN SOCIAL
-- =========================================================

CREATE TABLE iniciativa_innovacion (
    id_iniciativa          SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    nombre                 VARCHAR(200) NOT NULL,
    problema_abordado      TEXT,
    solucion_implementada  TEXT,
    nivel_participacion    SMALLINT CHECK (nivel_participacion BETWEEN 1 AND 5),
    escalabilidad          SMALLINT CHECK (escalabilidad BETWEEN 1 AND 5),
    replicabilidad         SMALLINT CHECK (replicabilidad BETWEEN 1 AND 5),
    resultados_alcanzados  TEXT,
    fecha_inicio           DATE,
    fecha_fin              DATE,
    estado                 VARCHAR(30) DEFAULT 'en curso'
);

CREATE TABLE actor_iniciativa (
    id_actor               INTEGER NOT NULL REFERENCES actor_comunitario(id_actor) ON DELETE CASCADE,
    id_iniciativa          INTEGER NOT NULL REFERENCES iniciativa_innovacion(id_iniciativa) ON DELETE CASCADE,
    rol                    VARCHAR(80),
    PRIMARY KEY (id_actor, id_iniciativa)
);

-- =========================================================
-- 7. DESARROLLO ECONÓMICO LOCAL
-- =========================================================

CREATE TABLE actividad_economica (
    id_actividad           SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    nombre                 VARCHAR(150) NOT NULL,
    cadena_valor           VARCHAR(150),
    empleo_generado        INTEGER CHECK (empleo_generado >= 0),
    ingresos_promedio      NUMERIC(14,2),
    emprendimiento_local   BOOLEAN DEFAULT FALSE,
    diversificacion        TEXT,
    encadenamientos        TEXT,
    fecha_registro         DATE DEFAULT CURRENT_DATE
);

-- =========================================================
-- 8. SOSTENIBILIDAD
-- =========================================================

CREATE TABLE practica_sostenible (
    id_practica            SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    dimension              VARCHAR(20) NOT NULL CHECK (dimension IN ('ambiental','social','economica')),
    subcategoria           VARCHAR(80) NOT NULL,
       -- ambiental: uso recursos, gestión residuos, adaptación climática
       -- social: equidad, inclusión género, participación juvenil
       -- economica: viabilidad financiera, acceso a mercados
    descripcion            TEXT,
    indicador              VARCHAR(120),
    valor                  NUMERIC(14,2),
    fecha_medicion         DATE DEFAULT CURRENT_DATE
);

-- =========================================================
-- 9. CAPACIDADES Y APRENDIZAJE COLECTIVO
-- =========================================================

CREATE TABLE programa_formacion (
    id_programa            SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    nombre                 VARCHAR(200) NOT NULL,
    capacidades_desarrolladas TEXT,
    intercambio_conocimiento  TEXT,
    aprendizaje_pares      BOOLEAN DEFAULT FALSE,
    gestion_conocimiento   TEXT,
    fecha_inicio           DATE,
    fecha_fin              DATE,
    participantes          INTEGER CHECK (participantes >= 0)
);

-- =========================================================
-- 10. COMUNICACIÓN PARA EL DESARROLLO
-- =========================================================

CREATE TABLE canal_comunicacion (
    id_canal               SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    nombre                 VARCHAR(150) NOT NULL,
    tipo_medio             VARCHAR(50),              -- radio comunitaria, WhatsApp, mural, TV...
    estrategia             TEXT,
    alcance_informacion    VARCHAR(80),
    participacion_digital  SMALLINT CHECK (participacion_digital BETWEEN 1 AND 5),
    activo                 BOOLEAN DEFAULT TRUE
);

-- =========================================================
-- 11. INDICADORES DE IMPACTO
-- =========================================================

CREATE TABLE indicador_impacto (
    id_indicador           SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    nombre                 VARCHAR(150) NOT NULL,
       -- mejora ingresos, fortalecimiento organizativo, incremento participación,
       -- innovaciones implementadas, calidad de vida, resiliencia, sostenibilidad redes
    valor_inicial          NUMERIC(14,2),
    valor_actual           NUMERIC(14,2),
    unidad_medida          VARCHAR(40),
    fecha_medicion         DATE DEFAULT CURRENT_DATE,
    fuente                 VARCHAR(150)
);

-- =========================================================
-- 12. VARIABLES ESTRATÉGICAS DEL MODELO DE GOBERNANZA EN RED
-- =========================================================

CREATE TABLE dimension_estrategica (
    id_dimension           SERIAL PRIMARY KEY,
    nombre                 VARCHAR(80) UNIQUE NOT NULL
    -- Estructura de la red, Gobernanza colaborativa,
    -- Innovación social comunitaria, Transformación territorial
);

INSERT INTO dimension_estrategica(nombre) VALUES
 ('Estructura de la red'),
 ('Gobernanza colaborativa'),
 ('Innovación social comunitaria'),
 ('Transformación territorial');

CREATE TABLE variable_estrategica (
    id_variable            SERIAL PRIMARY KEY,
    id_dimension           INTEGER NOT NULL REFERENCES dimension_estrategica(id_dimension) ON DELETE CASCADE,
    nombre                 VARCHAR(100) NOT NULL,
    descripcion            TEXT,
    unidad_medida          VARCHAR(40)
);

INSERT INTO variable_estrategica(id_dimension,nombre) VALUES
 (1,'Densidad'),(1,'Centralidad'),(1,'Diversidad de actores'),(1,'Conectividad'),
 (2,'Participación'),(2,'Confianza'),(2,'Coordinación'),(2,'Corresponsabilidad'),
 (3,'Co-creación'),(3,'Aprendizaje colectivo'),(3,'Gestión comunitaria'),(3,'Apropiación social'),
 (4,'Desarrollo económico local'),(4,'Inclusión social'),
 (4,'Sostenibilidad ambiental'),(4,'Fortalecimiento institucional');

CREATE TABLE valor_variable_territorio (
    id_valor               SERIAL PRIMARY KEY,
    id_territorio          INTEGER NOT NULL REFERENCES territorio(id_territorio) ON DELETE CASCADE,
    id_variable            INTEGER NOT NULL REFERENCES variable_estrategica(id_variable) ON DELETE CASCADE,
    valor                  NUMERIC(10,4),
    fecha_medicion         DATE DEFAULT CURRENT_DATE,
    observacion            TEXT,
    UNIQUE (id_territorio, id_variable, fecha_medicion)
);

-- =========================================================
-- 13. VISTAS ANALÍTICAS ÚTILES
-- =========================================================

-- 13.1 Densidad de red por territorio
CREATE VIEW vw_densidad_red AS
SELECT t.id_territorio,
       t.nombre_comunidad,
       COUNT(DISTINCT a.id_actor) AS total_actores,
       COUNT(DISTINCT r.id_relacion) AS total_relaciones,
       CASE WHEN COUNT(DISTINCT a.id_actor) > 1
            THEN ROUND(
                 COUNT(DISTINCT r.id_relacion)::numeric /
                 (COUNT(DISTINCT a.id_actor) * (COUNT(DISTINCT a.id_actor)-1)),
                 4)
            ELSE 0 END AS densidad
FROM territorio t
LEFT JOIN actor_comunitario a ON a.id_territorio = t.id_territorio
LEFT JOIN relacion_red r ON r.id_actor_origen = a.id_actor
GROUP BY t.id_territorio, t.nombre_comunidad;

-- 13.2 Grado de centralidad de cada actor (grado entrada + salida)
CREATE VIEW vw_centralidad_actor AS
SELECT a.id_actor,
       a.nombre,
       a.id_territorio,
       COUNT(DISTINCT r.id_relacion) AS grado_total,
       COUNT(DISTINCT r.id_relacion) FILTER (WHERE r.id_actor_origen = a.id_actor)  AS grado_salida,
       COUNT(DISTINCT r.id_relacion) FILTER (WHERE r.id_actor_destino = a.id_actor) AS grado_entrada
FROM actor_comunitario a
LEFT JOIN relacion_red r
       ON r.id_actor_origen = a.id_actor OR r.id_actor_destino = a.id_actor
GROUP BY a.id_actor, a.nombre, a.id_territorio;

-- 13.3 Nivel de gobernanza colaborativa por territorio
CREATE VIEW vw_gobernanza_colaborativa AS
SELECT t.id_territorio,
       t.nombre_comunidad,
       COUNT(DISTINCT e.id_espacio)       AS espacios_gobernanza,
       COUNT(DISTINCT m.id_mecanismo)     AS mecanismos_participacion,
       AVG(e.nivel_transparencia)::numeric(5,2)    AS transparencia_prom,
       AVG(e.nivel_rendicion_cuenta)::numeric(5,2) AS rendicion_prom,
       AVG(a.nivel_participacion)::numeric(5,2)    AS participacion_prom
FROM territorio t
LEFT JOIN espacio_gobernanza e ON e.id_territorio = t.id_territorio
LEFT JOIN mecanismo_participacion m ON m.id_espacio = e.id_espacio
LEFT JOIN actor_comunitario a ON a.id_territorio = t.id_territorio
GROUP BY t.id_territorio, t.nombre_comunidad;

-- 13.4 Panel de innovación social
CREATE VIEW vw_innovacion_social AS
SELECT t.id_territorio,
       t.nombre_comunidad,
       COUNT(i.id_iniciativa) AS total_iniciativas,
       AVG(i.nivel_participacion)::numeric(5,2) AS participacion_prom,
       AVG(i.escalabilidad)::numeric(5,2)       AS escalabilidad_prom,
       AVG(i.replicabilidad)::numeric(5,2)      AS replicabilidad_prom
FROM territorio t
LEFT JOIN iniciativa_innovacion i ON i.id_territorio = t.id_territorio
GROUP BY t.id_territorio, t.nombre_comunidad;

-- 13.5 Panel de transformación territorial (indicadores clave)
CREATE VIEW vw_transformacion_territorial AS
SELECT t.id_territorio,
       t.nombre_comunidad,
       COUNT(DISTINCT ind.id_indicador)  AS num_indicadores,
       AVG(ind.valor_actual)::numeric(14,2) AS valor_prom_actual,
       COUNT(DISTINCT act.id_actividad)  AS actividades_economicas,
       COUNT(DISTINCT ps.id_practica)    AS practicas_sostenibles
FROM territorio t
LEFT JOIN indicador_impacto ind ON ind.id_territorio = t.id_territorio
LEFT JOIN actividad_economica act ON act.id_territorio = t.id_territorio
LEFT JOIN practica_sostenible ps ON ps.id_territorio = t.id_territorio
GROUP BY t.id_territorio, t.nombre_comunidad;