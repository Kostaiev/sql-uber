
# Uber MySQL

Educational MySQL database project.

## Requirements
- MySQL 8.0.18+ (InnoDB, utf8mb4); CHECK constraints require MySQL 8.0.16+.
- Linux with GNU Make.
- MySQL CLI tools: mysql, mysql_config_editor.
- A local MySQL administrator account (by default, sudo mysql).

Local development only. The Makefile creates the MySQL account
'uber'@'localhost' with ALL PRIVILEGES on uber.*, not on the entire
MySQL server. This account is not equivalent to MySQL root.

## Database Schema (ERD)

```mermaid

erDiagram
    direction LR

    region ||--o{ city : contains
    city ||--o{ street : contains
    street ||--o{ house : contains

    street |o--o{ road_segment : names
    intersection ||--o{ road_segment : cross1
    intersection ||--o{ road_segment : cross2
    road_segment |o--o{ house : access

    passenger ||--o{ ride : requests
    driver |o--o{ ride : performs
    operator |o--o{ ride : creates

    house |o--o{ ride : pickup
    house |o--o{ ride : dropoff

    ride ||--o| driver_rating : has
    ride ||--o| passenger_rating : has

    region {
        INT_UNSIGNED id PK
        VARCHAR_150 name UK
    }

    city {
        INT_UNSIGNED id PK
        INT_UNSIGNED region_id FK
        VARCHAR_150 name
    }

    street {
        INT_UNSIGNED id PK
        INT_UNSIGNED city_id FK
        VARCHAR_150 name
        BOOLEAN drivable
    }

    house {
        BIGINT_UNSIGNED id PK
        INT_UNSIGNED street_id FK
        VARCHAR_20 house_number
        POINT location
        POINT access_point
        INT_UNSIGNED road_segment_id FK
    }

    intersection {
        INT_UNSIGNED id PK
        POINT location
    }

    road_segment {
        INT_UNSIGNED id PK
        INT_UNSIGNED street_id FK
        INT_UNSIGNED cross1_id FK
        INT_UNSIGNED cross2_id FK
        LINESTRING path
        INT_UNSIGNED distance_m
        ENUM structure_type
        BOOLEAN drivable
    }

    passenger {
        BIGINT_UNSIGNED id PK
        VARCHAR_100 first_name
        VARCHAR_100 last_name
        VARCHAR_16 phone UK
        VARCHAR_254 email UK
        DECIMAL rating_avg
        INT_UNSIGNED rating_count
        DATETIME created_at
    }

    driver {
        BIGINT_UNSIGNED id PK
        VARCHAR_100 first_name
        VARCHAR_100 last_name
        VARCHAR_16 phone UK
        VARCHAR_254 email UK
        DECIMAL rating_avg
        INT_UNSIGNED rating_count
        DATETIME created_at
    }

    operator {
        BIGINT_UNSIGNED id PK
        VARCHAR_100 first_name
        VARCHAR_100 last_name
        VARCHAR_254 email UK
        DATETIME created_at
    }

    ride {
        BIGINT_UNSIGNED id PK
        BIGINT_UNSIGNED passenger_id FK
        BIGINT_UNSIGNED driver_id FK
        BIGINT_UNSIGNED operator_id FK
        BIGINT_UNSIGNED pickup_house_id FK
        BIGINT_UNSIGNED dropoff_house_id FK
        POINT pickup_location
        POINT dropoff_location
        DECIMAL fare_amount
        BOOLEAN paid
        BOOLEAN completed
        DATETIME created_at
    }

    driver_rating {
        BIGINT_UNSIGNED ride_id PK,FK
        TINYINT_UNSIGNED rating
        VARCHAR_1000 review
        DATETIME created_at
    }

    passenger_rating {
        BIGINT_UNSIGNED ride_id PK,FK
        TINYINT_UNSIGNED rating
        VARCHAR_1000 review
        DATETIME created_at
    }
```


## Relationships

- region → city → street → house: One-to-Many.
- intersection → road_segment: One-to-Many per endpoint.
- street → road_segment: One-to-Many (optional).
- road_segment → house: One-to-Many (optional access).
- passenger / driver / operator → ride: One-to-Many.
- house → ride: One-to-Many (optional pickup/dropoff).
- ride → driver_rating / passenger_rating: One-to-Zero-or-One.
- Foreign keys use RESTRICT for DELETE and UPDATE.

## Business Rules

- Regions include oblasts and special-status cities.
- Names are unique within their parent; house numbers within a street.
- Address entities require their parent.
- Road segments connect different intersections and have positive distances.
- Segments may be roads, bridges, or tunnels; routing respects drivable.
- Houses may store location and road-access coordinates.
- Every ride requires pickup and dropoff coordinates; house references are optional.
- Completed rides require an assigned driver and payment.
- Ratings are 1–5, one per direction per ride; averages are cached.
- River-crossing routes use exactly one designated bridge.

## Quick start

Initialize the local MySQL environment:

```bash
make setup
```
The setup creates the MySQL user, database, tables,
and development data, then verifies the result.

Save the generated password and enter it when prompted.
If the user already exists, use its existing password.

## Commands
```bash
make help      # List available commands
make verify    # Check tables and sample data
make seed      # Insert development data
make reset     # Remove database, user, and saved login
```
*make reset* permanently deletes the local database and
requires confirmation.