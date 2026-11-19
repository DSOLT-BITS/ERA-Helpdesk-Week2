CREATE DATABASE IF NOT EXISTS helpdesk_db;
 
CREATE TABLE departments (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
password VARCHAR(255) NOT NULL,
role ENUM('employee', 'it_staff') DEFAULT 'employee',
department_id INT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (department_id) REFERENCES departments(id)
);helpdesk_db
 
CREATE TABLE tickets (
id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(255) NOT NULL,
description TEXT,
priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
status ENUM('open', 'in_progress', 'resolved', 'closed') DEFAULT 'open',
submitted_by INT NOT NULL,
assigned_to INT,
department_id INT,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY(submitted_by) REFERENCES users(id),
FOREIGN KEY(assigned_to) REFERENCES users(id),
FOREIGN KEY(department_id) REFERENCES departments(id)
);
 
CREATE TABLE ticket_assignments (
id INT AUTO_INCREMENT PRIMARY KEY,
ticket_id INT NOT NULL,
assigned_to INT NOT NULL,
assigned_by INT NOT NULL,
assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (ticket_id) REFERENCES tickets(id),
FOREIGN KEY (assigned_to) REFERENCES users(id),
FOREIGN KEY (assigned_by) REFERENCES users(id)
);
 
SHOW TABLES;
 
SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = 'helpdesk_db'
AND REFERENCED_TABLE_NAME IS NOT NULL;
 
INSERT INTO departments (name) VALUES
('IT'),
('HR'),
('Finance'),
('Marketing');
 
SELECT * FROM departments;
 
INSERT INTO users (first_name, last_name, email, password, role, department_id) VALUES
('Admin', 'IT', 'admin@eratech.com', 'Admin@123', 'it_staff', 1),
('Sarah', 'Connor', 'sarah@eratech.com', 'Sarah@123', 'it_staff', 1),
('John', 'Martinez', 'john@eratech.com', 'John@1234', 'employee', 2),
('Lisa', 'Chen', 'lisa@eratech.com', 'Lisa@1234', 'employee', 3),
('Marcus', 'Williams', 'marcus@eratech.com', 'Marcus@123', 'employee', 4);
 
SELECT id, first_name, last_name, email, role, department_id FROM users;

INSERT INTO tickets (title, description, priority, status, submitted_by, assigned_to, department_id) VALUES
('Cannot connect to VPN','Getting error 619 when trying to connect to company VPN from home','high','open', 3, 2, 2),
('Laptop running very slow.','Computer takes 10 minutes to boot. Freezes during meetings.','medium','in_progress', 4, 1, 3),
('Printer not working on third floor.','The HP printer in finance area shows offline status.', 'low', 'open', 4, NULL, 3),
('Email account locked.', 'Cannot login to Outlook. Account appears to be locked.', 'critical','open', 5, 2, 4),
('Software installation request', 'Need Adobe Acrobat Pro installed for contract work', 'low', 'resolved', 3, 1, 2);

SELECT id, title, priority, status, submitted_by, assigned_to FROM tickets;

INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by) VALUES 
(1, 2, 1),
(2, 2, 1),
(4, 2, 1),
(5, 1, 1);

SELECT t.id AS ticket_id, t.title, t.priority, t.status, CONCAT(u1.first_name, ' ', u1.last_name) AS submitted_by,
CONCAT(u2.first_name, ' ', u2.last_name) AS assigned_to, d.name AS department FROM tickets t JOIN users u1 ON t.submitted_by = u1.id
LEFT JOIN users u2 ON t.assigned_to = u2.id JOIN departments d ON t.department_id = d.id;

SELECT id, first_name, last_name, email, ROLE, department_id FROM users;

SELECT id, title, priority, status, submitted_by FROM tickets;


-- DELETE FROM tickets WHERE id IN (6, 7, 8, 9, 10);
-- UPDATE tickets SET id = 6 WHERE id = 11;
-- UPDATE tickets SET id = 7 WHERE id = 12;
-- ALTER TABLE tickets AUTO_INCREMENT = 8;

