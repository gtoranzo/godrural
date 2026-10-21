# godrural
Plataforma de Gobernanza del Desarrollo Rural en Red

Botón Recientes no funciona
Para la base de datos orientada a la gestión de la gobernanza del desarrollo rural basada en redes comunitarias, las categorías deben permitir analizar actores, relaciones, recursos, procesos participativos, innovación social e impactos territoriales.
1. Identificación territorial
•	Código de comunidad
•	Nombre de la comunidad
•	Municipio
•	Consejo Popular
•	Asentamiento
•	Tipología rural
•	Coordenadas geográficas
•	Población total
2. Actores de la red comunitaria
•	ID del actor
•	Nombre
•	Tipo de actor: 
o	Comunidad
o	Cooperativa
o	Empresa
o	Gobierno local
o	Universidad
o	ONG
o	Proyecto de desarrollo
o	Productor individual
•	Rol en la red
•	Nivel de influencia
•	Nivel de participación
3. Capital social y relaciones
•	Tipo de vínculo
•	Intensidad de relación
•	Frecuencia de interacción
•	Confianza percibida
•	Mecanismos de cooperación
•	Redes formales e informales
•	Liderazgos comunitarios
4. Gobernanza territorial
•	Espacios de coordinación
•	Mecanismos de participación
•	Procesos de toma de decisiones
•	Inclusión de actores
•	Transparencia
•	Rendición de cuenta
•	Gestión de conflictos
5. Recursos territoriales
•	Recursos naturales
•	Recursos productivos
•	Recursos financieros
•	Infraestructura
•	Recursos culturales y patrimoniales
•	Recursos tecnológicos
•	Recursos humanos
6. Innovación social
•	Iniciativa innovadora
•	Problema abordado
•	Actores involucrados
•	Solución implementada
•	Nivel de participación comunitaria
•	Escalabilidad
•	Replicabilidad
•	Resultados alcanzados
7. Desarrollo económico local
•	Actividad productiva
•	Cadena de valor
•	Empleo generado
•	Ingresos
•	Emprendimientos locales
•	Diversificación productiva
•	Encadenamientos productivos
8. Sostenibilidad
Ambiental
•	Uso de recursos naturales
•	Gestión de residuos
•	Adaptación climática
Social
•	Equidad
•	Inclusión de género
•	Participación juvenil
Económica
•	Viabilidad financiera
•	Acceso a mercados
9. Capacidades y aprendizaje colectivo
•	Programas de formación
•	Capacidades desarrolladas
•	Intercambio de conocimientos
•	Aprendizaje entre pares
•	Gestión del conocimiento
10. Comunicación para el desarrollo
•	Canales de comunicación
•	Medios comunitarios
•	Estrategias de comunicación
•	Alcance de la información
•	Participación digital
11. Indicadores de impacto
•	Mejora de ingresos
•	Fortalecimiento organizativo
•	Incremento de la participación
•	Innovaciones implementadas
•	Calidad de vida
•	Resiliencia comunitaria
•	Sostenibilidad de las redes
Propuesta de variables estratégicas para un modelo de gobernanza en red
Las variables centrales pueden agruparse en cuatro dimensiones:
1.	Estructura de la red
o	Densidad
o	Centralidad
o	Diversidad de actores
o	Conectividad
2.	Gobernanza colaborativa
o	Participación
o	Confianza
o	Coordinación
o	Corresponsabilidad
3.	Innovación social comunitaria
o	Co-creación
o	Aprendizaje colectivo
o	Gestión comunitaria
o	Apropiación social
4.	Transformación territorial
o	Desarrollo económico local
o	Inclusión social
o	Sostenibilidad ambiental
o	Fortalecimiento institucional
Esta estructura nos servirá como base para una plataforma virtual interactiva de gobernanza rural, que articula actores, redes, proyectos, indicadores y procesos de innovación social en los 10 asentamientos rurales seleccionados, que pueden ser 13. 
Orden: Basado en la información anterior analizar para desarrollar una Base de datos en postgres y devolverme la información en sql con las tablas y relaciones propuestas para poder importar
Base de Datos PostgreSQL para Gobernanza del Desarrollo Rural en Red
A continuación te presento el diseño completo de la base de datos, con tablas normalizadas, relaciones, claves foráneas, tipos de datos e índices. Está estructurado para soportar los 10–13 asentamientos rurales y todas las dimensiones analíticas que planteaste.

1. Modelo relacional (resumen)
text
territorio (comunidad)
   ├── actor_comunitario ─── rol_actor / tipo_actor
   │        └── relacion_red (actor_origen ↔ actor_destino)
   │        └── participacion_espacio
   │        └── actor_iniciativa
   ├── espacio_gobernanza ─── mecanismo_participacion
   ├── recurso_territorial
   ├── iniciativa_innovacion ─── actor_iniciativa
   ├── actividad_economica
   ├── practica_sostenible
   ├── programa_formacion
   ├── canal_comunicacion
   └── indicador_impacto
2. Script SQL completo
sql
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
3. Notas de uso e importación
Orden de creación respetado por las FK: territorio → actor_comunitario → relacion_red, etc. Puedes ejecutar el script directamente en psql, DBeaver o pgAdmin.

Carga masiva: usa \copy o COPY desde CSV por cada tabla, empezando por las catálogos (tipo_actor, tipo_vinculo, categoria_recurso, dimension_estrategica, variable_estrategica) y luego las tablas transaccionales.

Escalabilidad a 13 asentamientos: la tabla territorio ya lo soporta; solo inserta las 13 filas con sus códigos únicos.

Modelo de red: relacion_red está diseñada como grafo dirigido (origen → destino), lo que te permite calcular densidad, centralidad y otras métricas del análisis de redes sociales (SNA).

Variables estratégicas: la tabla valor_variable_territorio permite medir las 16 variables (4 dimensiones × 4 variables) por territorio y fecha, habilitando series temporales para la plataforma interactiva.

Índices añadidos en las FK más consultadas (territorio, actores, relaciones) para buen rendimiento en las vistas analíticas.

¿Quieres que te agregue también funciones PL/pgSQL para recalcular indicadores automáticamente, o scripts de carga CSV de ejemplo con los 13 asentamientos?

Puedes escribirme las indicaciones anteriores  en modo de readme.md para usarlas de guía y agrega despues de las indicaciones de postgres,  paso a paso indicaciones para desarrollar la plataforma virtual las interfaces que debe contener y las mejotes alternativas que propones cómo Frontend React, vue-quasar o otra que consideres y android-flutter y backend en API python-fast o rest-prisma-bisness
Found 15 web pages
README.md — Plataforma de Gobernanza del Desarrollo Rural en Red
Este documento sirve como guía completa para el diseño, implementación y despliegue de la base de datos PostgreSQL y la plataforma virtual interactiva de gobernanza rural basada en redes comunitarias. Está estructurado en dos grandes bloques: (1) el esquema de base de datos con sus relaciones, y (2) los pasos para desarrollar la plataforma web y móvil, incluyendo las interfaces requeridas y las alternativas tecnológicas recomendadas.

Parte 1 — Base de Datos PostgreSQL
1.1 Resumen del modelo relacional
text
territorio (comunidad)
   ├── actor_comunitario ─── tipo_actor
   │        └── relacion_red (actor_origen ↔ actor_destino)
   │        └── participacion_actor (→ espacio_gobernanza)
   │        └── actor_iniciativa (→ iniciativa_innovacion)
   ├── espacio_gobernanza ─── mecanismo_participacion
   ├── recurso_territorial ─── categoria_recurso
   ├── iniciativa_innovacion
   ├── actividad_economica
   ├── practica_sostenible
   ├── programa_formacion
   ├── canal_comunicacion
   ├── indicador_impacto
   └── valor_variable_territorio ─── variable_estrategica ─── dimension_estrategica
1.2 Script SQL de creación
El script completo se encuentra en el anexo schema_gobernanza_rural.sql. Incluye:

Creación de la base de datos con codificación UTF-8 y configuración regional para español.

13 tablas principales más tablas catálogo (tipo_actor, tipo_vinculo, categoria_recurso, dimension_estrategica, variable_estrategica).

Claves foráneas con políticas ON DELETE CASCADE donde corresponde.

Índices en las columnas de mayor consulta (territorio, actores, relaciones).

Restricciones CHECK para validar rangos (niveles de 1 a 5, valores no negativos).

5 vistas analíticas predefinidas:

vw_densidad_red: densidad de red por territorio.

vw_centralidad_actor: grado de entrada/salida por actor.

vw_gobernanza_colaborativa: promedios de transparencia, rendición de cuentas y participación.

vw_innovacion_social: métricas agregadas de iniciativas.

vw_transformacion_territorial: indicadores de impacto y actividades económicas.

1.3 Orden de importación recomendado
Ejecutar el script de creación de tablas.

Cargar las tablas catálogo (tipo_actor, tipo_vinculo, categoria_recurso, dimension_estrategica, variable_estrategica) con los INSERT incluidos en el script.

Cargar territorio con los 10–13 asentamientos rurales (código único, nombre, municipio, consejo popular, asentamiento, tipología, coordenadas, población).

Cargar actor_comunitario referenciando id_territorio e id_tipo_actor.

Cargar relacion_red, espacio_gobernanza, mecanismo_participacion, participacion_actor.

Cargar el resto de tablas transaccionales en cualquier orden (dependen solo de territorio).

1.4 Notas de uso
Carga masiva: usar COPY o \copy desde CSV para cada tabla, respetando el orden de dependencias.

Escalabilidad: el diseño soporta los 13 asentamientos sin cambios estructurales; solo se insertan más filas en territorio.

Análisis de redes: relacion_red es un grafo dirigido (origen → destino), lo que permite calcular densidad, centralidad de grado y otras métricas de Análisis de Redes Sociales (SNA) directamente con SQL o exportando a herramientas especializadas.

Series temporales: valor_variable_territorio incluye fecha_medicion en su clave única, permitiendo múltiples mediciones por territorio y variable a lo largo del tiempo.

Parte 2 — Desarrollo de la Plataforma Virtual
2.1 Arquitectura general propuesta
text
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Frontend Web  │────▶│   API Backend   │────▶│   PostgreSQL    │
│  (React / Vue)  │     │   (FastAPI)     │     │   (gobernanza)  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│  App Móvil      │     │  Documentación  │
│  (Flutter)      │     │  OpenAPI / JWT  │
└─────────────────┘     └─────────────────┘
La arquitectura es de tres capas: frontend web (React o Vue), aplicación móvil (Flutter) y backend API REST (FastAPI + SQLAlchemy). El backend expone endpoints documentados automáticamente vía OpenAPI/Swagger, lo que facilita la integración tanto con la web como con la app móvil .

2.2 Elección del stack tecnológico
Frontend web: React vs Vue/Quasar
Criterio	React 19	Vue 3.5 / Quasar
Ecosistema y librerías	Enorme (shadcn/ui, MUI, Recharts, TanStack)	Moderado (Vuetify, PrimeVue, Quasar)
Curva de aprendizaje	Media-alta (JSX, hooks, estado)	Baja-media (plantillas HTML, reactividad automática)
Documentación oficial	Buena	Excelente
Rendimiento en dashboards	Muy bueno con React Compiler	Muy bueno con Vapor Mode
Soporte para móvil	React Native (compartir lógica)	Quasar (mismo código para web y móvil)
Demanda en mercado laboral	Muy alta	Moderada
Recomendación para este proyecto: React + Vite + TypeScript + shadcn/ui + TanStack Query + Recharts. La plataforma requiere dashboards con gráficos de red, tablas de actores, formularios de captura y mapas de indicadores. El ecosistema de React ofrece librerías maduras para cada uno de estos componentes, y la integración con FastAPI está bien documentada . Si el equipo tiene perfil más orientado a HTML/CSS y se busca rapidez de desarrollo, Vue 3 + Quasar es una alternativa sólida que además permite reutilizar componentes en una PWA móvil .

Backend: FastAPI vs alternativas
Framework	Ventajas	Limitaciones
FastAPI (Python)	Documentación OpenAPI automática, validación con Pydantic, async nativo, alto rendimiento para APIs, ideal para integración con SQLAlchemy y PostgreSQL	No incluye panel de administración ni autenticación por defecto; requiere ensamblar piezas
Django REST Framework	Admin panel incluido, autenticación completa, ORM integrado	Más pesado, menor rendimiento en APIs puras
Express + Prisma (Node)	Ecosistema JS unificado, Prisma ORM moderno	Validación y documentación requieren configuración adicional
Recomendación: FastAPI + SQLAlchemy (async) + Pydantic + JWT (python-jose) + Alembic para migraciones. FastAPI genera documentación interactiva automática, lo que acelera la integración con el frontend y Flutter. Su rendimiento para APIs con base de datos es adecuado para la escala del proyecto (10–13 territorios, decenas de actores) .

Nota sobre "rest-prisma-bisness": Si el equipo prefiere TypeScript en todo el stack, Express/Fastify + Prisma + Zod es una alternativa válida. Prisma ofrece un esquema declarativo y migraciones automatizadas, pero requeriría definir el esquema en Prisma Schema en lugar de SQL puro. Para este proyecto, SQL puro con FastAPI/SQLAlchemy es más directo porque el esquema ya está definido y validado.

App móvil: Flutter
Flutter es la opción recomendada para la aplicación Android (y iOS si se requiere). Permite compartir lógica de negocio con la web si se usa un enfoque de capas (servicios API en Dart), y su integración con APIs REST es directa mediante el paquete http o dio . La arquitectura recomendada es MVVM: Model (llamadas HTTP y parsing JSON), ViewModel (gestión de estado), View (widgets) .

2.3 Interfaces de la plataforma
La plataforma debe contener las siguientes interfaces, organizadas por módulo funcional:

Módulo 1 — Dashboard territorial
Vista general: tarjetas con métricas clave por territorio (población, número de actores, densidad de red, indicadores de impacto).

Selector de territorio: filtro por municipio, consejo popular o asentamiento.

Gráfico de red: visualización de la red de actores (nodos y aristas) con filtros por tipo de vínculo e intensidad.

Indicadores de gobernanza: gráficos de barras o radar con transparencia, participación, rendición de cuentas.

Módulo 2 — Gestión de actores
Listado de actores: tabla con filtros por tipo, nivel de influencia, nivel de participación.

Formulario de alta/edición: campos de nombre, tipo, rol, niveles (1–5), contacto.

Detalle de actor: relaciones entrantes/salientes, participación en espacios de gobernanza e iniciativas.

Módulo 3 — Redes y capital social
Matriz de relaciones: visualización de vínculos entre actores (origen → destino) con intensidad y confianza.

Editor de relaciones: formulario para registrar/editar vínculos (tipo, intensidad, frecuencia, confianza).

Análisis de centralidad: ranking de actores por grado de entrada/salida, usando la vista vw_centralidad_actor.

Módulo 4 — Gobernanza territorial
Espacios de gobernanza: listado y detalle de espacios (consejos, asambleas, grupos gestores).

Mecanismos de participación: asociados a cada espacio, con tipo de decisión (consultiva/deliberativa/vinculante).

Participación de actores: matriz actor × espacio con rol y frecuencia.

Módulo 5 — Recursos e innovación
Inventario de recursos: por categoría (natural, productivo, financiero, infraestructura, cultural, tecnológico, humano) y territorio.

Iniciativas de innovación: listado con problema abordado, solución, niveles de participación/escalabilidad/replicabilidad.

Vinculación actor–iniciativa: qué actores participan en cada iniciativa y con qué rol.

Módulo 6 — Desarrollo económico y sostenibilidad
Actividades económicas: cadena de valor, empleo generado, ingresos, encadenamientos.

Prácticas sostenibles: filtradas por dimensión (ambiental, social, económica) y subcategoría.

Módulo 7 — Capacidades y comunicación
Programas de formación: capacidades desarrolladas, intercambio de conocimiento, aprendizaje entre pares.

Canales de comunicación: tipo de medio, estrategia, alcance, participación digital.

Módulo 8 — Indicadores y variables estratégicas
Panel de impacto: indicadores por territorio (mejora de ingresos, fortalecimiento organizativo, resiliencia, etc.) con valores iniciales y actuales.

Variables estratégicas: visualización de las 16 variables (4 dimensiones × 4 variables) por territorio y fecha, usando valor_variable_territorio.

Módulo 9 — Administración (solo roles autorizados)
Gestión de usuarios: roles (administrador, técnico, consulta).

Carga masiva: importación CSV por tabla.

Exportación: descarga de datos en CSV/JSON.

2.4 Paso a paso para el desarrollo
Fase 0 — Preparación del entorno (1–2 días)
Verificar instalaciones: Python 3.10+, Node.js 18+, PostgreSQL 14+, Flutter SDK (para móvil).

Crear el repositorio con estructura de monorepo:

text
gobernanza-rural/
├── backend/          # FastAPI
├── frontend/         # React + Vite
├── mobile/           # Flutter
├── database/         # Scripts SQL y migraciones
└── docs/             # Documentación y este README
Configurar PostgreSQL local y ejecutar el script de creación de la base de datos.

Configurar variables de entorno (.env) para la conexión a base de datos y secretos JWT.

Fase 1 — Backend API (2–3 semanas)
Estructura del proyecto FastAPI:

text
backend/
├── app/
│   ├── main.py
│   ├── config.py
│   ├── database.py
│   ├── models.py          # SQLAlchemy ORM
│   ├── schemas.py         # Pydantic
│   ├── auth.py            # JWT
│   └── routes/
│       ├── territorios.py
│       ├── actores.py
│       ├── relaciones.py
│       ├── gobernanza.py
│       ├── recursos.py
│       ├── innovacion.py
│       ├── economia.py
│       ├── sostenibilidad.py
│       ├── formacion.py
│       ├── comunicacion.py
│       ├── indicadores.py
│       └── variables.py
├── alembic/               # Migraciones
└── requirements.txt
Definir modelos SQLAlchemy reflejando el esquema SQL (o usar automap_base para generarlos desde la base existente).

Implementar endpoints CRUD para cada entidad, con paginación y filtros.

Implementar autenticación JWT con roles (administrador, técnico, consulta).

Configurar CORS para permitir el frontend en desarrollo.

Verificar documentación automática en http://localhost:8000/docs.

Fase 2 — Frontend Web (3–4 semanas)
Estructura del proyecto React + Vite:

text
frontend/
├── src/
│   ├── components/        # Componentes reutilizables
│   ├── pages/            # Vistas por módulo
│   ├── hooks/            # Custom hooks (useTerritorios, useActores...)
│   ├── services/         # Llamadas API (axios o fetch)
│   ├── types/            # TypeScript interfaces
│   └── App.tsx
├── package.json
└── vite.config.ts
Configurar shadcn/ui y TailwindCSS para el sistema de diseño.

Implementar el layout principal (sidebar con módulos, header con selector de territorio y usuario).

Desarrollar los módulos en orden de prioridad: Dashboard → Actores → Redes → Gobernanza → Innovación → Indicadores → Administración.

Integrar gráficos de red con react-force-graph o vis-network, y gráficos estadísticos con Recharts.

Implementar formularios con react-hook-form y validación con Zod.

Fase 3 — App Móvil Android (2–3 semanas, opcional según prioridad)
Crear proyecto Flutter con arquitectura MVVM:

text
mobile/
├── lib/
│   ├── models/           # Clases Dart (fromJson/toJson)
│   ├── services/         # Llamadas HTTP (dio)
│   ├── viewmodels/       # Gestión de estado (Provider o Riverpod)
│   ├── views/            # Pantallas
│   └── main.dart
└── pubspec.yaml
Implementar autenticación (login con JWT, almacenamiento seguro del token).

Desarrollar pantallas de consulta: dashboard resumido, listado de actores, detalle de territorio, indicadores.

Priorizar funcionalidades de consulta para la app móvil; la edición completa puede reservarse para la web.

Fase 4 — Integración y pruebas (1–2 semanas)
Pruebas de integración frontend–backend con datos reales de los 10–13 territorios.

Pruebas de carga básicas (por ejemplo, con locust o k6) para validar tiempos de respuesta.

Validación de la documentación OpenAPI contra los endpoints implementados.

Pruebas en dispositivos Android reales para la app Flutter.

Fase 5 — Despliegue (1 semana)
Backend: desplegar en un servicio como Railway, Render, Fly.io o un VPS con Docker. Configurar PostgreSQL gestionado.

Frontend: desplegar en Vercel, Netlify o Cloudflare Pages.

App móvil: generar APK/AAB y distribuir vía Google Play o instalación directa.

Configurar CI/CD básico (GitHub Actions) para build y despliegue automático.

2.5 Mejoras y alternativas propuestas
Área	Mejora / Alternativa	Justificación
Frontend web	Vue 3 + Quasar en lugar de React	Menor curva de aprendizaje, mismo código para PWA y app móvil, documentación excelente
Backend	Django REST Framework	Si se necesita panel de administración y autenticación listos para usar, DRF acelera el desarrollo inicial
Backend (TS)	Fastify + Prisma + Zod	Stack unificado en TypeScript si el equipo domina Node.js
Móvil	Flutter con Riverpod	Mejor gestión de estado que Provider para apps medianas; go_router para navegación declarativa
Visualización de red	Cytoscape.js o Sigma.js	Alternativas maduras a react-force-graph para grafos grandes con interactividad avanzada
Mapas	Leaflet + OpenStreetMap	Visualización de coordenadas de territorios sin depender de Google Maps API
Analítica	Metabase o Superset	Conectar directamente a PostgreSQL para dashboards exploratorios sin desarrollar cada vista
Exportación	Endpoint /export/csv en FastAPI	Permitir descarga de cualquier tabla o vista en CSV para análisis externo
2.6 Checklist de interfaces mínimas viables
□ Login con JWT y roles.
□ Dashboard con selector de territorio y métricas clave.
□ CRUD de actores comunitarios.
□ Editor de relaciones de red (origen → destino, tipo, intensidad).
□ Listado y detalle de espacios de gobernanza.
□ Listado de iniciativas de innovación.
□ Panel de indicadores de impacto.
□ Visualización de variables estratégicas por dimensión.
□ Exportación de datos en CSV.
Anexo — Archivo schema_gobernanza_rural.sql
El script SQL completo se entrega como archivo adjunto. Contiene todas las sentencias CREATE TABLE, INSERT de catálogos, CREATE INDEX y CREATE VIEW descritas en la Parte 1. Para ejecutarlo:

bash
psql -U postgres -f schema_gobernanza_rural.sql
Documento generado como guía de referencia para el equipo de desarrollo de la plataforma de gobernanza rural en red.