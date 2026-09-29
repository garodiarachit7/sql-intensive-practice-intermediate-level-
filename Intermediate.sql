/* ============================================================
   ORBITAL ARCHIVE
   SQL INTENSIVE PRACTICE DATABASE
   SQL Server
   ============================================================ */


/* ============================================================
   1. CREATE DATABASE
   ============================================================ */

IF DB_ID('ORBITAL_ARCHIVE') IS NULL
BEGIN
    CREATE DATABASE ORBITAL_ARCHIVE;
END;
GO

USE ORBITAL_ARCHIVE;
GO


/* ============================================================
   2. DROP TABLES IF THEY ALREADY EXIST
   ============================================================ */

DROP TABLE IF EXISTS signals;
DROP TABLE IF EXISTS observations;
DROP TABLE IF EXISTS expedition_crew;
DROP TABLE IF EXISTS expeditions;
DROP TABLE IF EXISTS anomalies;
DROP TABLE IF EXISTS stations;
DROP TABLE IF EXISTS planets;
DROP TABLE IF EXISTS researchers;
GO


/* ============================================================
   3. CREATE TABLE: RESEARCHERS
   ============================================================ */

CREATE TABLE researchers
(
    researcher_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    clearance_level INT NOT NULL,
    age INT NOT NULL,
    home_station VARCHAR(50),
    joined_date DATE,
    mentor_id INT,

    CONSTRAINT FK_researcher_mentor
        FOREIGN KEY (mentor_id)
        REFERENCES researchers(researcher_id)
);
GO


/* ============================================================
   4. CREATE TABLE: PLANETS
   ============================================================ */

CREATE TABLE planets
(
    planet_id INT PRIMARY KEY,
    planet_name VARCHAR(100) NOT NULL,
    galaxy VARCHAR(50) NOT NULL,
    planet_type VARCHAR(50) NOT NULL,
    distance_ly DECIMAL(10,2) NOT NULL,
    gravity DECIMAL(5,2) NOT NULL,
    discovered_year INT NOT NULL,
    atmosphere VARCHAR(50)
);
GO


/* ============================================================
   5. CREATE TABLE: STATIONS
   ============================================================ */

CREATE TABLE stations
(
    station_id INT PRIMARY KEY,
    station_name VARCHAR(100) NOT NULL,
    planet_id INT NOT NULL,
    station_type VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    established_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,

    CONSTRAINT FK_station_planet
        FOREIGN KEY (planet_id)
        REFERENCES planets(planet_id)
);
GO


/* ============================================================
   6. CREATE TABLE: ANOMALIES
   ============================================================ */

CREATE TABLE anomalies
(
    anomaly_id INT PRIMARY KEY,
    anomaly_name VARCHAR(100) NOT NULL,
    anomaly_type VARCHAR(50) NOT NULL,
    danger_level INT NOT NULL,
    first_detected DATE NOT NULL,
    stability_score DECIMAL(5,2),
    planet_id INT NOT NULL,

    CONSTRAINT FK_anomaly_planet
        FOREIGN KEY (planet_id)
        REFERENCES planets(planet_id)
);
GO


/* ============================================================
   7. CREATE TABLE: EXPEDITIONS
   ============================================================ */

CREATE TABLE expeditions
(
    expedition_id INT PRIMARY KEY,
    expedition_name VARCHAR(100) NOT NULL,
    launch_date DATE NOT NULL,
    return_date DATE,
    planet_id INT NOT NULL,
    lead_researcher_id INT NOT NULL,
    mission_type VARCHAR(50) NOT NULL,
    budget_million DECIMAL(10,2) NOT NULL,
    success_rating INT,

    CONSTRAINT FK_expedition_planet
        FOREIGN KEY (planet_id)
        REFERENCES planets(planet_id),

    CONSTRAINT FK_expedition_lead_researcher
        FOREIGN KEY (lead_researcher_id)
        REFERENCES researchers(researcher_id)
);
GO


/* ============================================================
   8. CREATE TABLE: EXPEDITION_CREW
   Many-to-many relationship
   Researchers <-> Expeditions
   ============================================================ */

CREATE TABLE expedition_crew
(
    expedition_id INT NOT NULL,
    researcher_id INT NOT NULL,
    role VARCHAR(100) NOT NULL,
    hours_contributed INT NOT NULL,

    PRIMARY KEY (expedition_id, researcher_id),

    CONSTRAINT FK_crew_expedition
        FOREIGN KEY (expedition_id)
        REFERENCES expeditions(expedition_id),

    CONSTRAINT FK_crew_researcher
        FOREIGN KEY (researcher_id)
        REFERENCES researchers(researcher_id)
);
GO


/* ============================================================
   9. CREATE TABLE: OBSERVATIONS
   ============================================================ */

CREATE TABLE observations
(
    observation_id INT PRIMARY KEY,
    station_id INT NOT NULL,
    researcher_id INT,
    anomaly_id INT,
    observation_date DATE NOT NULL,
    duration_minutes INT NOT NULL,
    radiation_level DECIMAL(7,2) NOT NULL,
    confidence_score INT,

    CONSTRAINT FK_observation_station
        FOREIGN KEY (station_id)
        REFERENCES stations(station_id),

    CONSTRAINT FK_observation_researcher
        FOREIGN KEY (researcher_id)
        REFERENCES researchers(researcher_id),

    CONSTRAINT FK_observation_anomaly
        FOREIGN KEY (anomaly_id)
        REFERENCES anomalies(anomaly_id)
);
GO


/* ============================================================
   10. CREATE TABLE: SIGNALS
   ============================================================ */

CREATE TABLE signals
(
    signal_id INT PRIMARY KEY,
    station_id INT NOT NULL,
    detected_at DATETIME NOT NULL,
    frequency_khz DECIMAL(10,2) NOT NULL,
    strength DECIMAL(5,2) NOT NULL,
    signal_type VARCHAR(50) NOT NULL,
    decoded VARCHAR(10) NOT NULL,
    researcher_id INT,

    CONSTRAINT FK_signal_station
        FOREIGN KEY (station_id)
        REFERENCES stations(station_id),

    CONSTRAINT FK_signal_researcher
        FOREIGN KEY (researcher_id)
        REFERENCES researchers(researcher_id)
);
GO


/* ============================================================
   11. INSERT RESEARCHERS
   ============================================================ */

INSERT INTO researchers
(
    researcher_id,
    name,
    specialization,
    clearance_level,
    age,
    home_station,
    joined_date,
    mentor_id
)
VALUES
(101, 'Arin Vale', 'Xenobiology', 4, 38, 'Aster-1', '2017-03-14', NULL),
(102, 'Mira Sol', 'Quantum Physics', 5, 45, 'Helios-3', '2012-08-21', NULL),
(103, 'Kael Orin', 'Astrobiology', 3, 31, 'Aster-1', '2020-01-11', 101),
(104, 'Nia Voss', 'Signal Analysis', 4, 29, 'Nova-7', '2021-06-19', 102),
(105, 'Taren Kye', 'Exoplanetology', 5, 52, 'Helios-3', '2009-11-02', NULL),
(106, 'Lira Sen', 'Xenobiology', 2, 27, 'Nova-7', '2023-04-08', 101),
(107, 'Ronan Quill', 'Cosmic Engineering', 4, 41, 'Aster-1', '2016-09-27', NULL),
(108, 'Sera Nox', 'Signal Analysis', 3, 34, 'Unknown', '2019-12-15', 104),
(109, 'Elian Frost', 'Quantum Physics', 5, 48, 'Helios-3', '2010-02-18', 102),
(110, 'Veya Rune', 'Astrobiology', 1, 25, 'Nova-7', '2024-01-30', 103),
(111, 'Daren Holt', 'Exoplanetology', 3, 36, 'Aster-1', '2020-07-05', 105),
(112, 'Ilya Wren', 'Cosmic Engineering', 4, 39, 'Helios-3', '2015-05-22', 107),
(113, 'Orin Pax', 'Xenobiology', 2, 44, NULL, '2018-10-09', 101),
(114, 'Cira Moon', 'Signal Analysis', 3, 30, 'Nova-7', NULL, 104),
(115, 'Zane Rook', 'Exoplanetology', 1, 23, 'Aster-1', '2025-02-12', 105);
GO


/* ============================================================
   12. INSERT PLANETS
   ============================================================ */

INSERT INTO planets
(
    planet_id,
    planet_name,
    galaxy,
    planet_type,
    distance_ly,
    gravity,
    discovered_year,
    atmosphere
)
VALUES
(201, 'Elysara', 'Andromeda', 'Oceanic', 214, 0.82, 2014, 'Dense'),
(202, 'Veyron', 'Milky Way', 'Rocky', 87, 1.13, 2008, 'Thin'),
(203, 'Nyx-9', 'Andromeda', 'Ice', 531, 0.44, 2021, 'None'),
(204, 'Caldris', 'Triangulum', 'Desert', 302, 0.91, 2017, 'Thin'),
(205, 'Orpheon', 'Milky Way', 'Gas Giant', 61, 2.41, 1999, 'Dense'),
(206, 'Luminara', 'Andromeda', 'Forest', 417, 0.76, 2023, 'Dense'),
(207, 'Thalos', 'Triangulum', 'Rocky', 189, 1.04, 2011, 'Moderate'),
(208, 'Zerith', 'Milky Way', 'Oceanic', 143, 0.93, 2019, 'Dense'),
(209, 'Kaelos', 'Andromeda', 'Desert', 628, 0.67, 2020, 'None'),
(210, 'Umbra', 'Triangulum', 'Ice', 355, 0.38, 2016, 'None'),
(211, 'Solara', 'Milky Way', 'Forest', 92, 0.88, 2005, 'Dense'),
(212, 'Arcton', 'Andromeda', 'Rocky', 744, 1.22, 2025, 'Thin');
GO


/* ============================================================
   13. INSERT STATIONS
   ============================================================ */

INSERT INTO stations
(
    station_id,
    station_name,
    planet_id,
    station_type,
    capacity,
    established_date,
    status
)
VALUES
(301, 'Aster-1', 202, 'Research', 80, '2007-04-12', 'Active'),
(302, 'Helios-3', 205, 'Research', 120, '1998-09-21', 'Active'),
(303, 'Nova-7', 201, 'Signal', 60, '2013-02-17', 'Active'),
(304, 'Eclipse-2', 203, 'Observation', 40, '2021-11-08', 'Active'),
(305, 'Meridian-5', 204, 'Research', 100, '2016-05-30', 'Maintenance'),
(306, 'Zenith-4', 207, 'Observation', 50, '2010-08-14', 'Active'),
(307, 'Aurora-8', 208, 'Signal', 75, '2018-12-02', 'Active'),
(308, 'Obsidian-6', 210, 'Observation', 35, '2015-03-19', 'Decommissioned'),
(309, 'Horizon-9', 211, 'Research', 90, '2004-06-11', 'Active'),
(310, 'Void-1', 209, 'Signal', 25, '2019-10-25', 'Active');
GO


/* ============================================================
   14. INSERT ANOMALIES
   ============================================================ */

INSERT INTO anomalies
(
    anomaly_id,
    anomaly_name,
    anomaly_type,
    danger_level,
    first_detected,
    stability_score,
    planet_id
)
VALUES
(401, 'Whispering Void', 'Spatial', 9, '2018-04-17', 21.5, 203),
(402, 'Glass Storm', 'Atmospheric', 6, '2016-09-12', 67.2, 204),
(403, 'Blue Pulse', 'Energy', 4, '2020-01-28', 81.4, 201),
(404, 'Silent Orbit', 'Gravitational', 8, '2015-11-03', 35.8, 205),
(405, 'Crimson Bloom', 'Biological', 7, '2022-07-19', 52.1, 206),
(406, 'Frozen Echo', 'Temporal', 10, '2023-02-01', 14.7, 203),
(407, 'Dark River', 'Spatial', 8, '2019-05-22', 28.4, 209),
(408, 'Singing Stone', 'Geological', 3, '2014-12-09', 91.8, 207),
(409, 'Mirror Field', 'Quantum', 9, '2021-08-30', 42.6, 210),
(410, 'Golden Thread', 'Energy', 5, '2017-03-14', 73.9, 208),
(411, 'Phantom Rain', 'Atmospheric', 6, '2019-10-11', 59.3, 211),
(412, 'Red Horizon', 'Spatial', 7, '2025-04-03', NULL, 212);
GO


/* ============================================================
   15. INSERT EXPEDITIONS
   ============================================================ */

INSERT INTO expeditions
(
    expedition_id,
    expedition_name,
    launch_date,
    return_date,
    planet_id,
    lead_researcher_id,
    mission_type,
    budget_million,
    success_rating
)
VALUES
(501, 'Project Dawn', '2018-02-10', '2018-08-22', 201, 101, 'Exploration', 42.5, 8),
(502, 'Deep Silence', '2019-04-15', '2020-01-03', 203, 102, 'Anomaly', 67.8, 9),
(503, 'Veyron Survey', '2017-06-02', '2017-09-18', 202, 105, 'Survey', 21.4, 7),
(504, 'Crimson Path', '2022-03-11', '2022-11-29', 206, 103, 'Biological', 55.2, 9),
(505, 'Frozen Clock', '2023-01-12', '2023-06-17', 203, 109, 'Temporal', 91.6, 10),
(506, 'Shadow Line', '2020-08-03', '2021-02-21', 209, 111, 'Exploration', 34.7, 6),
(507, 'Mirror Gate', '2021-05-14', '2021-12-30', 210, 104, 'Quantum', 76.3, 8),
(508, 'Golden Current', '2019-09-07', '2020-03-12', 208, 106, 'Energy', 48.9, 7),
(509, 'Silent Giant', '2016-02-19', '2016-10-01', 205, 112, 'Gravitational', 63.1, 9),
(510, 'Red Horizon', '2025-05-22', NULL, 212, 115, 'Exploration', 102.4, NULL);
GO


/* ============================================================
   16. INSERT EXPEDITION CREW
   ============================================================ */

INSERT INTO expedition_crew
(
    expedition_id,
    researcher_id,
    role,
    hours_contributed
)
VALUES
(501, 101, 'Lead Scientist', 480),
(501, 103, 'Biologist', 320),
(501, 107, 'Engineer', 290),

(502, 102, 'Lead Scientist', 610),
(502, 104, 'Signal Analyst', 430),
(502, 109, 'Quantum Specialist', 390),

(503, 105, 'Lead Scientist', 260),
(503, 111, 'Planetologist', 220),

(504, 103, 'Lead Scientist', 510),
(504, 106, 'Biologist', 450),
(504, 113, 'Research Assistant', 180),

(505, 109, 'Lead Scientist', 720),
(505, 102, 'Temporal Specialist', 510),
(505, 110, 'Junior Researcher', 240),

(506, 111, 'Lead Scientist', 410),
(506, 101, 'Xenobiologist', 300),

(507, 104, 'Lead Scientist', 540),
(507, 109, 'Quantum Specialist', 470),
(507, 108, 'Signal Analyst', 350),

(508, 106, 'Lead Scientist', 390),
(508, 104, 'Signal Analyst', 270),

(509, 112, 'Lead Scientist', 580),
(509, 107, 'Engineer', 430),

(510, 115, 'Lead Scientist', 90),
(510, 105, 'Senior Advisor', 40);
GO


/* ============================================================
   17. INSERT OBSERVATIONS
   ============================================================ */

INSERT INTO observations
(
    observation_id,
    station_id,
    researcher_id,
    anomaly_id,
    observation_date,
    duration_minutes,
    radiation_level,
    confidence_score
)
VALUES
(601, 301, 101, 403, '2020-02-14', 120, 42.5, 91),
(602, 303, 104, 401, '2019-06-22', 75, 88.2, 84),
(603, 302, 102, 404, '2018-11-09', 180, 71.4, 93),
(604, 304, 109, 406, '2023-03-11', 240, 96.8, 97),
(605, 305, 103, 405, '2022-08-02', 95, 55.3, 88),
(606, 306, 111, 408, '2020-04-19', 60, 21.7, 79),
(607, 307, 106, 410, '2020-01-17', 150, 63.5, 90),
(608, 308, 108, 409, '2021-09-03', 200, 91.1, 95),
(609, 309, 113, 411, '2020-01-12', 110, 47.2, 82),
(610, 310, 111, 407, '2020-02-25', 85, 79.8, 86),
(611, 301, 103, 403, '2020-03-18', 130, 39.4, 89),
(612, 303, 104, 401, '2019-08-12', 90, 92.7, 87),
(613, 302, 109, 404, '2019-01-22', 210, 68.9, 94),
(614, 304, 110, 406, '2023-04-05', 260, 101.2, 98),
(615, 305, NULL, 405, '2022-09-14', 80, 61.7, NULL),
(616, 306, 111, NULL, '2021-01-09', 45, 18.4, 72),
(617, 307, 106, 410, '2020-05-22', 170, 70.1, 92),
(618, 309, 113, 411, '2020-02-08', 100, 53.6, 81),
(619, 301, 101, 408, '2020-07-14', 55, 27.3, 77),
(620, 310, 108, 407, '2020-03-30', 105, 84.6, 88);
GO


/* ============================================================
   18. INSERT SIGNALS
   ============================================================ */

INSERT INTO signals
(
    signal_id,
    station_id,
    detected_at,
    frequency_khz,
    strength,
    signal_type,
    decoded,
    researcher_id
)
VALUES
(701, 303, '2019-06-21 14:32:00', 1420.5, 87.4, 'Radio', 'Yes', 104),
(702, 302, '2018-11-08 03:17:00', 980.2, 63.1, 'Gravitational', 'No', 102),
(703, 307, '2020-01-16 22:41:00', 1742.8, 91.7, 'Energy', 'Yes', 106),
(704, 310, '2020-02-24 19:05:00', 632.4, 72.5, 'Spatial', 'No', 111),
(705, 303, '2019-08-11 11:24:00', 1418.9, 83.2, 'Radio', 'Yes', 104),
(706, 304, '2023-03-10 06:52:00', 2201.7, 96.4, 'Temporal', 'Yes', 109),
(707, 307, '2020-05-21 17:39:00', 1760.3, 88.9, 'Energy', 'No', 106),
(708, 309, '2020-02-07 09:13:00', 1198.6, 54.7, 'Atmospheric', 'No', 113),
(709, 301, '2020-07-13 23:48:00', 808.3, 61.5, 'Geological', 'Yes', 101),
(710, 305, '2022-09-13 15:21:00', 1555.2, 77.8, 'Biological', 'No', NULL),
(711, 306, '2021-01-08 04:44:00', 904.6, 48.3, 'Geological', 'No', 111),
(712, 308, '2021-09-02 12:17:00', 2014.9, 93.6, 'Quantum', 'Yes', 108),
(713, 310, '2020-03-29 18:36:00', 647.1, 81.2, 'Spatial', 'Yes', 108),
(714, 303, '2019-10-22 21:11:00', 1399.4, 76.5, 'Radio', 'No', 114),
(715, 307, '2020-06-04 02:29:00', 1801.8, 69.7, 'Energy', 'Yes', NULL);
GO


/* ============================================================
   19. VERIFY TABLES
   ============================================================ */

SELECT 'researchers' AS table_name, COUNT(*) AS row_count
FROM researchers

UNION ALL

SELECT 'planets', COUNT(*)
FROM planets

UNION ALL

SELECT 'stations', COUNT(*)
FROM stations

UNION ALL

SELECT 'anomalies', COUNT(*)
FROM anomalies

UNION ALL

SELECT 'expeditions', COUNT(*)
FROM expeditions

UNION ALL

SELECT 'expedition_crew', COUNT(*)
FROM expedition_crew

UNION ALL

SELECT 'observations', COUNT(*)
FROM observations

UNION ALL

SELECT 'signals', COUNT(*)
FROM signals;
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * 
FROM researchers

SELECT * 
FROM expeditions


SELECT * 
FROM observations


SELECT * 
FROM planets


SELECT 
    expedition_id,
    expedition_name,
    budget_million,
    budget_million *  1000 AS  budget_thousand
FROM expeditions

    SELECT
        planet_name,
        distance_ly,
        gravity,
        distance_ly* 9.461 AS distance_km
    FROM planets


SELECT DISTINCT 
specialization,
clearance_level
FROM researchers

SELECT TOP 5
planet_id,
planet_name,
galaxy
FROM planets

SELECT 
    researcher_id,
    name,
    specialization,
    age, 
    clearance_level,
    clearance_level * age AS clearance_score,
    name + ' - ' + specialization AS researcher_label
FROM researchers


SELECT TOP 5 *
FROM planets
ORDER BY distance_ly DESC


SELECT DISTINCT 
planet_type
FROM planets
ORDER BY planet_type ASC

SELECT TOP 5
    observation_id,
    radiation_level,
    duration_minutes,
    radiation_level * duration_minutes AS potenial_exposure
FROM observations
ORDER BY potenial_exposure DESC


SELECT  TOP 5
    name,
    age,
    clearance_level
FROM researchers
ORDER BY clearance_level DESC, age DESC

SELECT      
    planet_name,
    galaxy,
    distance_ly,
    gravity,
    (CASE 
        WHEN gravity >= 1.5 THEN 'HIGH'
        WHEN gravity >= 1.0 THEN 'NORMAL'
        WHEN gravity < 1.0 THEN 'LOW'
END) AS gravity_class
FROM planets


SELECT DISTINCT
signal_type
FROM Signals
ORDER BY signal_type DESC


SELECT 
        expedition_name,
        launch_date,
        return_date,
        YEAR(return_date) AS YEARRRR
FROM expeditions

SELECT 
    researcher_id,
    name,
    specialization,
    LEFT(name , 3) +  LEFT(specialization , 3) AS researcher_code
FROM researchers


SELECT TOP 5
    planet_name,
    galaxy,
    distance_ly,
    gravity
FROM planets
WHERE gravity < 1.0
ORDER BY distance_ly DESC

CREATE TABLE research_logs(
log_id INT,
researcher_id INT,
log_date DATE,
log_title VARCHAR(100),
severity INT
CONSTRAINT pk_value PRIMARY KEY (log_id)
)

CREATE TABLE spacecraft(
spacecraft_id INT,
spacecraft_name VARCHAR(100) NOT NULL,
model VARCHAR(50) NOT NULL,
launch_year INT,
fuel_capacity DECIMAL(10,2),
status VARCHAR(30) NOT NULL,
CONSTRAINT pk_key PRIMARY KEY (spacecraft_id),
CONSTRAINT chk_fuel CHECK (fuel_capacity > 0)
)

CREATE TABLE artifact_storage(
artifact_id INT,
artifact_name VARCHAR(100) NOT NULL,
model VARCHAR(50) NOT NULL,
storage_zone VARCHAR(30) DEFAULT 'UNASSIGNED',
security_level INT DEFAULT 1,
CONSTRAINT pk_id PRIMARY KEY (artifact_id)

)


ALTER TABLE spacecraft 
ADD last_maintenance_date DATE

ALTER TABLE research_logs
ADD CONSTRAINT chk_severity
CHECK (severity BETWEEN 1 AND 10);

CREATE TABLE alien_artifacts
(
    artifact_id INT IDENTITY(1,1),
    artifact_code VARCHAR(30) NOT NULL,
    artifact_name VARCHAR(100) NOT NULL,
    planet_id INT NOT NULL,
    discovered_by INT,
    discovered_date DATE,
    containment_level INT,
    status VARCHAR(30) DEFAULT 'Contained',
    estimated_age_years INT,

    CONSTRAINT pk_at
        PRIMARY KEY (artifact_id),

    CONSTRAINT uk_code
        UNIQUE (artifact_code),

    CONSTRAINT fk_artifact_planet
        FOREIGN KEY (planet_id)
        REFERENCES planets(planet_id),

    CONSTRAINT fk_artifact_researcher
        FOREIGN KEY (discovered_by)
        REFERENCES researchers(researcher_id),

    CONSTRAINT chk_containment
        CHECK (containment_level BETWEEN 1 AND 5),

    CONSTRAINT chk_years
        CHECK (estimated_age_years >= 0)
);

INSERT INTO alien_artifacts (artifact_name,artifact_code, planet_id,discovered_by,discovered_date,containment_level,status,estimated_age_years)
VALUES ('Obsidian Sphere', 'ART-001',203,102,2024-02-15,4,'Contained', 12500)

SELECT 
    planet_name,
    distance_ly
FROM planets
WHERE distance_ly BETWEEN 100 AND 400

SELECT 
    name,
    home_station
FROM researchers
WHERE home_station NOT IN ('Aster-1' , 'Helios-3')

SELECT *
FROM researchers

SELECT *
FROM expedition_crew

SELECT *
FROM expeditions

SELECT 
    r.name,
    r.specialization,
    e.expedition_name,
    ec.role
FROM researchers AS r
INNER JOIN expedition_crew AS ec
ON r.researcher_id = ec.researcher_id
INNER JOIN expeditions AS e
ON ec.expedition_id = e.expedition_id

SELECT
    e.expedition_name,
    p.planet_name,
    e.mission_type,
    e.budget_million
FROM expeditions AS e
INNER JOIN planets AS p
ON e.planet_id = p.planet_id
WHERE e.budget_million > 100


SELECT 
    r.name,
    o.observation_id,
    o.observation_date
FROM researchers AS r
LEFT JOIN observations AS o
ON r.researcher_id = o.researcher_id

SELECT  
    o.observation_id,
    o.observation_date,
    r.name,
    a.anomaly_name
FROM observations AS o
JOIN anomalies AS a
ON a.anomaly_id = o.anomaly_id
JOIN researchers AS r
ON o.researcher_id = r.researcher_id


SELECT
    e.expedition_name,
    p.planet_name,
    r.name,
    e.mission_type,
    e.success_rating
FROM expeditions AS e
INNER JOIN planets AS p
    ON e.planet_id = p.planet_id
INNER JOIN researchers AS r
    ON e.lead_researcher_id = r.researcher_id;



SELECT 
    r.name,
    r.specialization,
    e.expedition_name,
    ec.role
FROM expeditions AS e
LEFT JOIN expedition_crew AS ec
ON e.expedition_id = ec.expedition_id
LEFT JOIN researchers AS r
ON ec.researcher_id = r.researcher_id
WHERE ec.role = 'Scientist'

SELECT p.planet_name,
s.station_name,
s.station_type
FROM planets AS p
LEFT JOIN stations AS s
ON p.planet_id = s.planet_id

SELECT p.planet_name,
a.anomaly_name,
a.danger_level,
a.stability_score
FROM planets AS p
LEFT JOIN anomalies AS a
ON p.planet_id = a.planet_id


SELECT *
from researchers

SELECT *
from expedition_crew

SELECT *
from expeditions

SELECT *
from stations

SELECT *
from planets

SELECT *
from anomalies

SELECT *
from observations

SELECT *
from signals

--2
SELECT 
    r.researcher_id,
    r.name,
    r.specialization
FROM researchers AS r
LEFT JOIN expedition_crew AS ec
ON r.researcher_id = ec.researcher_id
LEFT JOIN expeditions AS e
ON e.expedition_id = ec.expedition_id
WHERE e.expedition_id IS NULL

--3
SELECT p.planet_name,
p.planet_id,
p.galaxy,
p.planet_type
FROM planets AS p
LEFT JOIN stations AS s
ON p.planet_id = s.planet_id
WHERE s.station_id IS NULL 

SELECT
    r.name,
    p.planet_name
FROM researchers AS r
CROSS JOIN planets AS p
WHERE r.clearance_level >= 4
  AND p.distance_ly < 500;


select  
    r.researcher_id,
    r.name,
    r.specialization
FROM expedition_crew AS e
LEFT JOIN researchers AS r
ON e.researcher_id = r.researcher_id
LEFT JOIN observations AS o
ON r.researcher_id = o.researcher_id
WHERE o.observation_id  IS NULL

--7
SELECT 
    p.planet_name,
    COUNT(s.station_id) AS total_stations,
    COUNT(a.anomaly_id) AS total_anomolies
FROM planets AS p
LEFT JOIN anomalies AS a
ON p.planet_id = a.planet_id
LEFT JOIN stations AS s
ON s.planet_id = p.planet_id
GROUP BY p.planet_name
HAVING COUNT(s.station_id) >= 1 AND COUNT(a.anomaly_id) >= 1

--12
SELECT 
    r.researcher_id,
    r.name,
    COUNT(e.expedition_id) AS total_expeditions
FROM researchers AS r
INNER JOIN expedition_crew as e
ON r.researcher_id = e.researcher_id
GROUP BY r.researcher_id , r.name
HAVING COUNT(e.expedition_id) > 1

--13
SELECT 
    p.planet_name,
    a.anomaly_name,
    a.danger_level,
    s.station_name
FROM planets AS p
INNER JOIN anomalies AS a
ON p.planet_id = a.planet_id
INNER JOIN stations AS s
ON p.planet_id = s.planet_id
WHERE a.planet_id = s.planet_id


SELECT 
    r.name,
    SUM(e.hours_contributed) AS total_hours
FROM researchers AS r
JOIN expedition_crew AS e
    ON r.researcher_id = e.researcher_id
GROUP BY r.name
HAVING SUM(e.hours_contributed) > 100;

SELECT
    r.researcher_id,
    r.name,
    COUNT(s.station_id)
FROM researchers AS R


SELECT 
    r.name AS name
FROM researchers AS r

UNION 

SELECT 
    p.planet_name AS name
FROM planets AS p

SELECT  
    r.researcher_id 
FROM researchers AS r
INNER JOIN expedition_crew AS e
ON r.researcher_id = e.researcher_id

UNION 

SELECT  
    r.researcher_id 
FROM researchers AS r
INNER JOIN observations AS o
ON r.researcher_id = o.researcher_id


SELECT  
    r.researcher_id,
    r.name
FROM researchers AS r
INNER JOIN expedition_crew AS e
ON r.researcher_id = e.researcher_id

UNION 

SELECT  
    r.researcher_id,
    r.name
FROM researchers AS r
INNER JOIN observations AS o
ON r.researcher_id = o.researcher_id
WHERE o.observation_id IS NULL

--5
SELECT 
    planet_name AS entity_name
FROM planets

UNION 

SELECT 
   anomaly_name AS entity_name
FROM anomalies

UNION

SELECT 
    station_name AS entity_name
FROM stations

--6
SELECT 
    researcher_id
FROM expedition_crew

UNION ALL 

SELECT 
    researcher_id
FROM signals


--7
SELECT 
    researcher_id
FROM expedition_crew

INTERSECT 

SELECT 
    researcher_id
FROM signals

--8
SELECT 
    researcher_id
FROM expedition_crew

EXCEPT

SELECT 
    researcher_id
FROM signals

--9
SELECT
    name,
    'Researcher' AS source
FROM researchers
WHERE clearance_level >= 4

UNION

SELECT
    planet_name AS name,
    'Planet' AS source
FROM planets
WHERE planet_type = 'Terrestrial';

--10
SELECT
    r.researcher_id,
    r.name
FROM researchers AS r
WHERE r.researcher_id IN (
    SELECT researcher_id
    FROM expedition_crew

    INTERSECT

    SELECT researcher_id
    FROM observations
);


SELECT 
    planet_name,
    UPPER(planet_name),
    LOWER(galaxy)
from planets


SELECT 
    name + '-' + specialization
    
FROM researchers



SELECT 
    planet_name,
    distance_ly,
    ROUND(distance_ly , 2) AS rounded
FROM planets


SELECT 
    expedition_name,
    launch_date,
    YEAR(launch_date) AS years,
    MONTH(launch_date) AS months
FROM expeditions


SELECT 
    signal_id,
    strength,
    CASE
        WHEN strength >= 80 THEN 'STRONG'
        WHEN strength BETWEEN 50 AND 79 THEN 'MEDIUM'
        WHEN strength < 50 THEN ' WEAK'
    END AS strenght_category
FROM signals


SELECT 
    name,
    LEN(name),
    TRIM(name),
    LEN(TRIM(name)),
    LEN(name) - LEN(TRIM(name))
FROM researchers



SELECT *
from researchers


SELECT 
    anomaly_name,
    stability_score,
    stability_score - 50 AS DIFF
FROM anomalies



SELECT 
    expedition_name,
    budget_million,
    budget_million * 1.15 AS increased_budget
FROM expeditions



SELECT 
    signal_id,
    strength,
    CASE    
        WHEN strength % 2 = 0 THEN 'EVEN'
        WHEN strength % 2 != 0 THEN 'ODD'
    END AS parity
FROM signals

SELECT 
    name,
    joined_date,
    year(joined_date),
    day(joined_date)
FROM researchers

select 
DATENAME( MONTH, launch_Date)
from expeditions


SELECT *
FROM expeditions

SELECT 
    expedition_name,
    launch_date,
    return_date,
    DATEDIFF(day, return_date , launch_date)
FROM expeditions

SELECT 
    name,
    joined_date,
    DATEDIFF(YEAR, GETDATE(), joined_date) AS years
FROM researchers

SELECT 
    anomaly_name,
    first_detected,
    DATEADD(day , 30 , first_detected)
FROM anomalies

SELECT 
 signal_id,
 detected_at,
DATEPART(hour, detected_at)Hour_dp,
DATEPART(MINUTE, detected_at) minute_dp
FROM signals

select 
    expedition_name,
    launch_date,
    return_date,
    DATEDIFF(DAY, launch_date, return_date)
FROM expeditions


SELECT 
name, 
ISNULL(home_station, 'Unknown Station')
FROM researchers

SELECT
    observation_id,
    ISNULL(CAST(confidence_score AS VARCHAR(20)), 'Not Available') AS confidence_score
FROM observations;

SELECT 
signal_id,
ISNULL(CAST(researcher_id AS VARCHAR(20)), 'Unassigned')
FROM signals   

SELECT 
name,
ISNULL(CAST(mentor_id AS VARCHAR(20)), 'No Mentor') AS mentor_id
FROM researchers 


SELECT 
    observation_id,
    radiation_level,
    confidence_score,
    COALESCE(confidence_score , radiation_level) AS adjusted_Score
FROM observations

SELECT 
anomaly_name,
stability_score,
ISNULL(stability_score + 10 , 10)
FROM anomalies


SELECT 
    researcher_id,
    home_station,
    mentor_id
FROM researchers
WHERE mentor_id IS NULL


SELECT
    name,
    home_station,
    mentor_id,
    CASE
        WHEN home_station IS NULL AND mentor_id IS NULL THEN 'Incomplete'
        ELSE 'Complete'  
    END as PROFILE_STATUS
FROM researchers 


SELECT 
    r.name, 
    COUNT(o.observation_id) AS total_observations,
    ISNULL(AVG(o.confidence_score), 0) AS average_confidence_score
FROM researchers AS r
LEFT JOIN observations AS o
    ON r.researcher_id = o.researcher_id
GROUP BY r.name;


SELECT 
    clearance_level,
    AVG(age)
FROM researchers
GROUP BY clearance_level

SELECT 
    specialization,
    COUNT(researcher_id) AS Total_researchers
FROM researchers
GROUP BY specialization

SELECT 
    galaxy,
    MAX(gravity),
    MIN(gravity)
FROM planets
GROUP BY galaxy


SELECT 
    mission_type,
    SUM(budget_million) AS total_budget
FROM expeditions
GROUP BY mission_type


SELECT
    planet_name,
    COUNT(anomaly_id) AS total_anomalies
FROM planets AS p
LEFT JOIN anomalies AS a
ON p.planet_id = a.planet_id
GROUP BY planet_name


SELECT 
name,
SUM(hours_contributed) AS total_contribution
FROM researchers AS r
INNER JOIN expedition_crew AS e
ON r.researcher_id = e.researcher_id
GROUP BY r.name
HAVING SUM(hours_contributed) > 100


SELECT *
FROM expedition_crew

SELECT *
 from expeditions


SELECT
    e.expedition_name,
    COUNT(ec.researcher_id) AS crew_members,
    SUM(ec.hours_contributed) AS total_hours_contributed,
    AVG(ec.hours_contributed) AS average_hours_per_member
FROM expeditions AS e
LEFT JOIN expedition_crew AS ec
    ON e.expedition_id = ec.expedition_id
GROUP BY e.expedition_name;


SELECT
name,
specialization,
age,
AVG(age) OVER() as average_age
from researchers

SELECT
name,
specialization,
age,
AVG(age) OVER(PARTITION BY specialization) as average_age
from researchers

SELECT
    planet_name,
    galaxy,
    distance_ly,
    AVG(distance_ly) OVER(PARTITION BY galaxy) AS average
FROM planets

SELECT 
    expedition_name,
    mission_type,
    budget_million,
    SUM(budget_million) OVER()
FROM expeditions


SELECT 
    expedition_name,
    mission_type,
    budget_million,
    SUM(budget_million) OVER(PARTITION BY mission_type)
FROM expeditions


SELECT 
    name,
    specialization,
    age,
    MIN(age) OVER(PARTITION BY specialization) AS min_age,
    MAX(age) OVER(PARTITION BY specialization) AS min_age
FROM researchers

SELECT
    station_name,
    station_type,
    capacity,
    SUM(capacity) OVER (partition by station_type)
FROM stations


SELECT 
    anomaly_name,
    anomaly_type,
    danger_level,
    AVG(CAST(danger_level AS FLOAT)) OVER (
        PARTITION BY anomaly_type
    ) AS avg_danger_level
FROM anomalies;


SELECT * ,
ROUND((budget_million - average_budget) , 2) AS difference
FROM (SELECT 
    expedition_name,
    mission_type,
    budget_million,
    AVG(budget_million) OVER(PARTITION BY mission_type) AS average_budget
FROM expeditions)t


SELECT
    name,
    specialization,
    age,
    ROUND(
        CAST(
            COUNT(*) OVER (PARTITION BY specialization)
            AS DECIMAL(10,2)
        )
        / COUNT(*) OVER () * 100,
        2
    ) AS specialization_percentage
FROM researchers;


SELECT 
    expedition_name,
    launch_date,
    budget_million,
    SUM(budget_million) OVER(ORDER BY launch_date)
FROM expeditions


SELECT 
    expedition_name,
    mission_type,
    launch_date,
    budget_million,
    SUM(budget_million) OVER(PARTITION BY mission_type ORDER BY launch_date)
FROM expeditions

SELECT 
    observation_id,
    observation_date,
    radiation_level,
    AVG(radiation_level) OVER(ORDER BY observation_date)
FROM observations


SELECT *,
    strength - previous_list 
    FROM (SELECT 
    signal_id,
    detected_at,
    strength,
    LAG(strength) OVER(ORDER BY detected_at) as previous_list
FROM signals)t

SELECT
    expedition_name,
    launch_date,
    budget_million,
    AVG(budget_million) OVER (
        ORDER BY launch_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_expedition_avg
FROM expeditions
ORDER BY launch_date;

SELECT 
    observation_id,
    observation_date,
    radiation_level,
    MAX(radiation_level) OVER(ORDER BY observation_date)
FROM Observations

SELECT *,
age - average_age FROM (SELECT 
    name,
    specialization,
    age,
    AVG(age) OVER(PARTITION BY specialization) AS average_age
FROM researchers)t

SELECT *,
ROUND((budget_million / total_budget) * 100 ,1) FROM  (SELECT 
    expedition_name,
    mission_type, 
    launch_date,
    budget_million,
    SUM(budget_million) OVER(PARTITION BY mission_type) AS total_budget
FROM expeditions)t

SELECT 
    name,
    specialization,
    age,
    RANK() OVER(ORDER BY age) AS raanks
FROM researchers

    SELECT 
        name,
        specialization,
        age,
        RANK() OVER(PARTITION BY specialization ORDER BY age DESC) AS raanks
    FROM researchers


SELECT 
    expedition_name,
    mission_type,
    budget_million,
    RANK() OVER(PARTITION BY mission_type ORDER BY budget_million DESC)
FROM expeditions


SELECT
    name,
    specialization,
    age,
    RANK() OVER(PARTITION BY specialization ORDER BY age DESC)
FROM researchers

SELECT 
    expedition_name,
    mission_type,
    budget_million,
    RANK() OVER(PARTITION BY mission_type ORDER BY budget_million DESC) AS ranks
FROM expeditions

SELECT 
    anomaly_name,
    anomaly_type,
    danger_level,
   dense_rank() OVER( ORDER BY danger_level DESC) AS ranks
FROM anomalies

SELECT 
    name,
    specialization,
    age,
    NTILE(4) OVER (
        ORDER BY age DESC
    ) AS age_group
FROM researchers;


SELECT
    expedition_name,
    mission_type,
    budget_million,
    PERCENT_RANK() OVER (
        PARTITION BY mission_type
        ORDER BY budget_million
    ) AS budget_percent_position
FROM expeditions;

SELECT
    name,
    specialization,
    age,
    CUME_DIST() OVER (
        PARTITION BY specialization
        ORDER BY age
    ) AS cumulative_distribution
FROM researchers;


WITH ranked_expeditions AS (
    SELECT
        mission_type,
        expedition_name,
        budget_million,
        ROW_NUMBER() OVER (
            PARTITION BY mission_type
            ORDER BY budget_million DESC
        ) AS rn
    FROM expeditions
)
SELECT
    mission_type,
    expedition_name,
    budget_million
FROM ranked_expeditions
WHERE rn <= 2;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1
SELECT *,
age - min_age,
max_age - age FROM (
SELECT 
    name,
    specialization,
    age,
    MIN(age) OVER() AS min_age,
    MAX(age) OVER() AS max_age
FROM researchers)t

SELECT *,
ROUND(radiation_level - average, 2) AS difference FROM (SELECT
    observation_id,
    researcher_id,
    radiation_level,
    AVG(radiation_level) OVER() AS average
FROM observations)t

SELECT TOP 1 
name,age, specialization
FROM researchers
ORDER BY age DESC

SELECT 
    expedition_name, 
    launch_date, 
    budget_million, 
    SUM(budget_million) OVER(
        ORDER BY launch_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total 
FROM 
    expeditions;

SELECT 
    expedition_name, 
    launch_date, 
    budget_million, 
    SUM(budget_million) OVER(
        ORDER BY launch_date 
        ROWS BETWEEN  1 PRECEDING AND CURRENT ROW
    ) AS running_total 
FROM  expeditions; 


SELECT 
    expedition_name, 
    launch_date, 
    budget_million, 
    SUM(budget_million) OVER(
        ORDER BY launch_date 
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS forward_sum 
FROM  
    expeditions;

  

SELECT 
    expedition_name, 
    launch_date, 
    budget_million, 
    AVG(budget_million) OVER(
        ORDER BY launch_date 
        ROWS BETWEEN  2 PRECEDING AND CURRENT ROW
    ) AS running_total 
FROM  expeditions; 



SELECT 
    observation_id, 
    observation_date, 
    radiation_level,
    MAX(radiation_level) OVER(ORDER BY observation_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM observations


 SELECT 
    name,
    specialization,
    age,
    RANK() OVER(PARTITION BY specialization ORDER BY age DESC)
FROM researchers
 

 SELECT *
 FROM (SELECT 
    name,
    specialization,
    age,
    RANK() OVER(PARTITION BY specialization ORDER BY age DESC) AS ranks
FROM researchers)t
WHERE ranks = 2


SELECT
    mission_type,
    expedition_name,
    budget_million
FROM (
    SELECT 
        mission_type, 
        expedition_name,
        budget_million,
        RANK() OVER (
            PARTITION BY mission_type
            ORDER BY budget_million ASC
        ) AS ranks
    FROM expeditions
) t
WHERE ranks <= 3;


 SELECT *
 FROM (SELECT 
    name,
    specialization,
    age,
    RANK() OVER(PARTITION BY specialization ORDER BY age DESC) AS ranks
FROM researchers)t
WHERE ranks = 1



 SELECT *
 FROM (SELECT 
    name,
    specialization,
    age,
    RANK() OVER(PARTITION BY specialization ORDER BY age ASC) AS ranks
FROM researchers)t
WHERE ranks <= 2

SELECT *
FROM (
    SELECT 
        observation_id,
        COUNT(*) OVER (
            PARTITION BY observation_id
        ) AS duplicate_count
    FROM observations
) t
WHERE duplicate_count > 1;


SELECT 
    name,
    age,
    specialization,
    ROUND(CUME_DIST() OVER( ORDER BY age),2) AS DIST
FROM researchers


SELECT 
    name,
    age,
    specialization,
    ROUND(CUME_DIST() OVER( ORDER BY age asc),2) AS DIST
FROM researchers
    
SELECT
    expedition_name,
    budget_million,
    mission_type,
    ROUND(
        CUME_DIST() OVER (
            PARTITION BY mission_type
            ORDER BY budget_million
        ),
        2
    ) AS cumulative_percentage
FROM expeditions;
    

SELECT *
FROM(SELECT
    expedition_name,
    budget_million,
    mission_type,
    CUME_DIST() OVER(PARTITION BY mission_type ORDER BY budget_million DESC) AS ranks
   FROM expeditions)t
WHERE ranks <= 0.4


SELECT
    expedition_name,
    budget_million,
    mission_type,
    CUME_DIST() OVER(PARTITION BY mission_type ORDER BY budget_million DESC) AS ranks
   FROM expeditions

SELECT 
    expedition_name,
    launch_date,
    budget_million,
    LAG(budget_million) OVER(ORDER BY launch_date)  AS previous_budget
FROM expeditions

SELECT 
    expedition_name,
    launch_date,
    budget_million,
    LEAD(budget_million,1,0) OVER(ORDER BY launch_date)  AS previous_budget
FROM expeditions


    SELECT
    expedition_name,
    launch_date,
    budget_million,
    previous_budget,
    budget_million - previous_budget AS budget_difference
FROM (
    SELECT 
        expedition_name,
        launch_date,
        budget_million,
        LAG(budget_million) OVER (
            ORDER BY launch_date
        ) AS previous_budget
    FROM expeditions
) t;



    SELECT 
        name,
        age,
        specialization,
        LAG(age) OVER(order by age) AS previous
    FROM researchers

SELECT 
    expedition_name,
    launch_date,
    budget_million,
    FIRST_VALUE(budget_million) OVER(ORDER BY launch_date) AS first_launch,
    LAST_VALUE(budget_million) OVER(ORDER BY launch_date) AS last_launch
FROM expeditions

SELECT 
    expedition_name,
    launch_date,
    budget_million,
    FIRST_VALUE(budget_million) OVER(PARTITION BY mission_type ORDER BY launch_date) AS first_launch,
    LAST_VALUE(budget_million) OVER(PARTITION BY mission_type ORDER BY launch_date) AS last_launch
FROM expeditions

SELECT *,
DATEDIFF(day, previous, joined_date) AS difference
FROM (Select
    name,
    specialization,
    joined_date,
    LAG(joined_date) OVER(order by joined_date) AS previous
   FROM researchers)t


SELECT *,
DATEDIFF(day, joined_date, next) AS difference
FROM (Select
    name,
    specialization,
    joined_date,
    LEAD(joined_date) OVER(order by joined_date) AS next
   FROM researchers)t