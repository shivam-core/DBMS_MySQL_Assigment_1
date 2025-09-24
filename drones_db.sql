-- drones_db.sql
-- Drone Management System - CREATE + INSERT + Sample Queries
DROP DATABASE IF EXISTS drones_db;
CREATE DATABASE drones_db;
USE drones_db;

-- =====================
-- CREATE TABLES
-- =====================

CREATE TABLE Drone (
  drone_id INT PRIMARY KEY,
  model VARCHAR(80) NOT NULL,
  manufacturer VARCHAR(80),
  purchase_date DATE,
  status VARCHAR(20) NOT NULL -- Active, Maintenance, Retired
) ENGINE=InnoDB;

CREATE TABLE Pilot (
  pilot_id INT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  license_no VARCHAR(50) UNIQUE,
  phone VARCHAR(30),
  email VARCHAR(120)
) ENGINE=InnoDB;

CREATE TABLE Flight (
  flight_id INT PRIMARY KEY,
  drone_id INT NOT NULL,
  pilot_id INT NOT NULL,
  flight_date DATE NOT NULL,
  location VARCHAR(120),
  purpose VARCHAR(60),
  duration_minutes INT, -- flight duration
  FOREIGN KEY (drone_id) REFERENCES Drone(drone_id),
  FOREIGN KEY (pilot_id) REFERENCES Pilot(pilot_id)
) ENGINE=InnoDB;

CREATE TABLE Maintenance (
  maintenance_id INT PRIMARY KEY,
  drone_id INT NOT NULL,
  maintenance_date DATE NOT NULL,
  details VARCHAR(255),
  cost DECIMAL(10,2),
  FOREIGN KEY (drone_id) REFERENCES Drone(drone_id)
) ENGINE=InnoDB;

CREATE TABLE Delivery (
  delivery_id INT PRIMARY KEY,
  flight_id INT NOT NULL,
  package_weight_kg DECIMAL(6,2),
  destination VARCHAR(150),
  delivery_status VARCHAR(30), -- Pending, Delivered, Failed
  FOREIGN KEY (flight_id) REFERENCES Flight(flight_id)
) ENGINE=InnoDB;

-- =====================
-- INSERT SAMPLE DATA
-- (~30 rows total)
-- =====================

-- Drones
INSERT INTO Drone VALUES
(1,'AeroX-100','SkyWorks','2024-03-12','Active'),
(2,'FalconPro-2','DynaFly','2023-11-01','Active'),
(3,'Surveyor-S','GeoDrone Inc','2022-08-20','Maintenance'),
(4,'CargoMax-XL','LiftAir','2024-01-15','Active'),
(5,'NanoLite','MicroDrones','2021-05-05','Retired'),
(6,'AeroX-200','SkyWorks','2024-06-02','Active');

-- Pilots
INSERT INTO Pilot VALUES
(10,'Rohit Sharma','LIC-IND-2024-001','+91-987650001','rohit@example.com'),
(11,'Priya Menon','LIC-IND-2023-008','+91-987650002','priya@example.com'),
(12,'Karan Gupta','LIC-IND-2022-121','+91-987650003','karan@example.com'),
(13,'Sara Iqbal','LIC-IND-2024-017','+91-987650004','sara@example.com'),
(14,'Dev Patel','LIC-IND-2024-033','+91-987650005','dev@example.com');

-- Flights (dates chosen near a hypothetical submission date)
INSERT INTO Flight VALUES
(5000,1,10,'2025-09-16','Sector A - Downtown','Delivery',25),
(5001,2,11,'2025-09-18','Riverside Survey','Survey',45),
(5002,1,12,'2025-09-20','Industrial Area','Security Patrol',60),
(5003,4,10,'2025-09-19','Airport Perimeter','Security Patrol',30),
(5004,6,13,'2025-09-21','Suburb Delivery','Delivery',22),
(5005,2,11,'2025-09-22','Coastal Survey','Survey',55),
(5006,3,12,'2025-09-14','Construction Site','Survey',80),
(5007,4,10,'2025-09-10','Warehouse Transfer','Delivery',40),
(5008,1,11,'2025-09-07','Rooftop Inspection','Survey',18),
(5009,6,13,'2025-09-02','Parcel Drop','Delivery',28),
(5010,1,10,'2025-08-30','Practice Field','Training',35),
(5011,2,14,'2025-09-20','Night Patrol','Security Patrol',50);

-- Maintenance
INSERT INTO Maintenance VALUES
(9000,3,'2025-09-12','Propeller replacement & firmware update',150.00),
(9001,1,'2025-08-25','Battery pack replaced',200.00),
(9002,4,'2025-07-02','Motor calibration',75.00),
(9003,2,'2025-06-20','Routine check',45.00),
(9004,6,'2025-09-01','Landing gear fix',120.00),
(9005,3,'2024-12-05','Major repair after crash',900.00);

-- Deliveries (some flights carry deliveries; some flights may have none)
INSERT INTO Delivery VALUES
(7000,5000,1.20,'Block A, Building 5','Delivered'),
(7001,5004,0.75,'Sector B, House 13','Delivered'),
(7002,5007,5.50,'Warehouse 9','Delivered'),
(7003,5009,0.90,'Shop 21, Market Road','Failed'),
(7004,5002,0.00,'N/A','Pending'), -- flight used for security; no package weight
(7005,5005,0.60,'Coastal Lab','Delivered'),
(7006,5011,0.00,'N/A','Pending'),
(7007,5001,0.00,'N/A','Pending');

-- =====================
-- INDEXES (optional but helpful)
-- =====================
CREATE INDEX idx_flight_drone ON Flight(drone_id);
CREATE INDEX idx_flight_pilot ON Flight(pilot_id);
CREATE INDEX idx_maint_drone ON Maintenance(drone_id);

-- =====================
-- SAMPLE QUERIES (5 meaningful queries)
-- Run these and show results in your demo recording
-- =====================

-- Q1: Flights in the last 7 days (relative to CURDATE())
SELECT f.flight_id, f.flight_date, d.drone_id, d.model, p.pilot_id, p.full_name, f.location, f.purpose, f.duration_minutes
FROM Flight f
JOIN Drone d ON d.drone_id = f.drone_id
JOIN Pilot p ON p.pilot_id = f.pilot_id
WHERE f.flight_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
ORDER BY f.flight_date DESC;

-- Q2: Top 3 drones by total flight minutes (most used drones)
SELECT d.drone_id, d.model, SUM(f.duration_minutes) AS total_minutes, COUNT(*) AS flights_count
FROM Flight f
JOIN Drone d ON d.drone_id = f.drone_id
GROUP BY d.drone_id, d.model
ORDER BY total_minutes DESC
LIMIT 3;

-- Q3: Pilots who operated more than 3 flights (adjust threshold as needed)
SELECT p.pilot_id, p.full_name, COUNT(*) AS flights_count
FROM Flight f
JOIN Pilot p ON p.pilot_id = f.pilot_id
GROUP BY p.pilot_id, p.full_name
HAVING COUNT(*) > 3
ORDER BY flights_count DESC;

-- Q4: Drones that had maintenance in the last 30 days
SELECT m.maintenance_id, m.maintenance_date, m.details, m.cost, d.drone_id, d.model
FROM Maintenance m
JOIN Drone d ON d.drone_id = m.drone_id
WHERE m.maintenance_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY m.maintenance_date DESC;

-- Q5: Total delivery weight handled per pilot (sum of package weights for flights they piloted)
SELECT p.pilot_id, p.full_name, COALESCE(SUM(dl.package_weight_kg),0) AS total_weight_kg, COUNT(dl.delivery_id) AS deliveries_count
FROM Pilot p
LEFT JOIN Flight f ON f.pilot_id = p.pilot_id
LEFT JOIN Delivery dl ON dl.flight_id = f.flight_id
GROUP BY p.pilot_id, p.full_name
ORDER BY total_weight_kg DESC;

-- Extra helpful query: Find drones with low stock of maintenance (no concept of stock, but list retired or maintenance)
SELECT drone_id, model, status, purchase_date FROM Drone WHERE status <> 'Active';
