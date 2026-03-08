# Maintenance Manager Mobile Application
![Flutter](https://img.shields.io/badge/Flutter-Mobile-blue)
![Firebase](https://img.shields.io/badge/Firebase-Backend-orange)

Maintenance Manager is a Flutter-based mobile application designed to help vehicle owners track fuel expenses, vehicle information, and maintenance costs in one organized system.

The app provides a clear overview of vehicle ownership costs while keeping detailed records of fuel usage and important vehicle specifications.

This project was originally developed as part of an academic thesis exploring mobile application architecture and vehicle maintenance tracking.

Thesis documentation:
https://www.overleaf.com/read/ywkjjnkfrnnr#82cb57

## Features
### Account Management
    - Secure user authentication using Firebase Authentication
    - User profile management

### Vehicle Management
    - Add and manage multiple vehicles
    - Store detailed vehicle information including:
        - make, model, year
        - VIN and license plate
        - purchase price
        - odometer readings
    - Archive and restore vehicles
    - Delete vehicles and associated records

### Fuel Tracking
    - Log fuel purchases for each vehicle
    - Record:
        - fuel amount
        - price per unit
        - total cost
        - odometer reading
        - fuel date
    - Edit and delete fuel records
    - View fuel history for each vehicle

### Expense Tracking
    - Monthly fuel expense summaries
    - Yearly fuel expense summaries
    - Lifetime vehicle fuel costs
    - Lifetime vehicle maintenance costs

### Vehicle Component Records
Store reference information for common service components including:
    - Engine specifications
    - Oil weight and oil filters
    - Battery size and specifications
    - Exterior components such as:
        - wiper blades
        - bulbs
        - lamps
This information helps simplify routine maintenance.

### Cloud Data Sync
    - Vehicle data and fuel records are securely stored using Firebase Firestore
    - Data is associated with user accounts
    - Protects records from device loss
    - Supports cross-device access

### Notifications
    - Firebase Cloud Messaging integration for future notification features

### Localization
    - Multi-language support using Flutter localization system

### Customization
    - User settings for:
        - currency
        - date format
        - fuel units
        - mileage units
        - notifications

## Technology Stack
### Frontend
    - Flutter
    - Dart

### Backend Services
    - Firebase Authentication
    - Firebase Firestore
    - Firebase Cloud Messaging
    - Firebase Analytics

### Local Storage
    - SQLite (sqflite)

### State Management
    - Provider

## Project Architecture

The application uses a hybrid architecture combining:

Local storage for fast device access
Cloud synchronization for persistent backup and multi-device data protection

Key components include:
    - Local data models
    - Cloud data models
    - Mapper classes to convert between local and cloud formats
    - Cloud read/write service layers
    - SQLite database operations
This structure allows the application to scale while maintaining performance on mobile devices.

## Future Development Roadmap
Planned features include:

### Data Visualization
    - Graphs showing fuel and maintenance expenses over time

### Maintenance Tracking
    - Detailed repair and service history logs

### Export Features
    - Export vehicle and fuel records as:
        - PDF
        - CSV reports

### Document Processing
    - Upload mechanic reports and receipts
    - Automatic data extraction

### Customization
    - Light/Dark theme support

### Expanded Analytics
    - More advanced financial summaries and reports

### Project Status
    This project is actively under development and continues to evolve with new features and improvements.

### Author
    Daniel Smargiassi

### License
    This project is currently maintained as a personal academic and development project.