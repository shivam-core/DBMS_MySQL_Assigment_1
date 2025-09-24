# Drone Management Database — README

## 1. Overview

This project is a **mini relational database** for managing drone operations. It models drones, pilots, flights, maintenance, and deliveries. The system supports key queries such as recent flights, most used drones, pilot workloads, recent maintenance activities, and delivery statistics.

The database was designed in **3NF** (Third Normal Form) to ensure data consistency and avoid redundancy.

---

## 2. Entities & Attributes

* **Drone**

  * `drone_id (PK)`
  * `model`
  * `manufacturer`
  * `purchase_date`
  * `status` (Active, Maintenance, Retired)

* **Pilot**

  * `pilot_id (PK)`
  * `full_name`
  * `license_no` (Unique)
  * `phone`
  * `email`

* **Flight**

  * `flight_id (PK)`
  * `drone_id (FK)`
  * `pilot_id (FK)`
  * `flight_date`
  * `location`
  * `purpose` (Delivery, Survey, Security, Training)
  * `duration_minutes`

* **Maintenance**

  * `maintenance_id (PK)`
  * `drone_id (FK)`
  * `maintenance_date`
  * `details`
  * `cost`

* **Delivery**

  * `delivery_id (PK)`
  * `flight_id (FK)`
  * `package_weight_kg`
  * `destination`
  * `delivery_status` (Pending, Delivered, Failed)

---

## 3. Relationships

* **Drone → Flight** : One drone can have many flights.
* **Pilot → Flight** : One pilot can operate many flights.
* **Drone → Maintenance** : One drone can undergo many maintenance events.
* **Flight → Delivery** : One flight can carry multiple deliveries.

---

## 4. Sample Data

* 6 Drones
* 5 Pilots
* 12 Flights
* 6 Maintenance records
* 8 Deliveries
  (Total: \~35 records across tables)

---

## 5. Queries Demonstrated

1. **Flights in the last 7 days**

   * Lists all flights conducted within the past week.
2. **Top 3 drones by total flight minutes**

   * Ranks drones by usage time.
3. **Pilots with more than 3 flights**

   * Identifies active pilots.
4. **Drones with maintenance in the last 30 days**

   * Tracks recently serviced drones.
5. **Total delivery weight per pilot**

   * Calculates delivery load handled by each pilot.

---

## 6. Submission Package

* `drones_db.sql` → SQL script with CREATE, INSERT, and queries.
* `ER_Diagram.png` → ER diagram (friend’s style).
* `README.md` → This file (design summary).
* Demo video → Shows database creation and queries execution.
