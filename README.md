<div align="center">

# 🚢 TrackEye AI

### Smart Logistics Platform Powered by AI

![TrackEye AI Logo](https://via.placeholder.com/200x200/1E3A8A/FFFFFF?text=TrackEye+AI)

[![Flutter](https://img.shields.io/badge/Flutter-3.10.1-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Flask](https://img.shields.io/badge/Flask-3.0.0-000000?logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![MongoDB](https://img.shields.io/badge/MongoDB-7.0-47A248?logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Supabase](https://img.shields.io/badge/Supabase-Storage-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com/)
[![Google AI](https://img.shields.io/badge/Google%20AI-Gemini-4285F4?logo=google&logoColor=white)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-Proprietary-red)](LICENSE)

**Revolutionizing logistics with AI-powered route optimization, real-time tracking, and intelligent document processing**

[Features](#-key-features) • [Architecture](#-architecture) • [Installation](#-installation--setup) • [Documentation](#-documentation) • [Team](#-team-yon Kons)

</div>

---

## 📋 Table of Contents

- [About the Project](#-about-the-project)
- [Project Vision](#-project-vision)
- [Key Features](#-key-features)
- [Architecture](#-architecture)
- [Content Overview](#-content-overview)
- [Tech Stack](#-tech-stack)
- [Installation & Setup](#-installation--setup)
- [Repository Links](#-repository-links)
- [Screenshots](#-screenshots)
- [Team YONKONS](#-team-yon Kons)
- [License](#-license)

---

## 🎯 About the Project

**TrackEye AI** is a comprehensive, AI-powered logistics and supply chain management platform designed to streamline international trade operations. The platform connects suppliers, forwarders, buyers, and drivers through an intelligent ecosystem that optimizes routes, processes documents, and provides real-time tracking capabilities.

### Core Capabilities

- **🤖 AI-Powered Route Optimization**: Leverages machine learning algorithms to find the shortest and most eco-friendly routes, reducing carbon footprint and operational costs
- **📄 Intelligent Document Processing**: Uses Google Gemini AI to extract and process shipping documents automatically
- **📍 Real-Time Tracking**: Live shipment tracking with GPS integration for drivers and stakeholders
- **💼 Multi-Role Platform**: Dedicated interfaces for suppliers, forwarders, buyers, and drivers
- **🌐 Cloud Storage**: Secure document storage using Supabase Storage
- **📊 Analytics Dashboard**: Comprehensive insights into shipment status, quotes, and performance metrics

---

## 🎯 Project Vision

**TrackEye AI** envisions a future where logistics operations are:

- **🌱 Sustainable**: AI-driven route optimization reduces environmental impact
- **⚡ Efficient**: Automated document processing and intelligent routing minimize delays
- **🔗 Connected**: Seamless communication between all stakeholders in the supply chain
- **📈 Data-Driven**: Real-time analytics enable informed decision-making
- **🌍 Global**: Support for international trade with customs integration

Our mission is to transform the logistics industry by making it smarter, faster, and more environmentally conscious through cutting-edge AI technology.

---

## ✨ Key Features

### 🏢 Supplier Dashboard
- Create and manage shipments
- Upload shipping documents with AI extraction
- Request quotes from multiple forwarders
- Track shipment status in real-time
- View analytics and performance metrics

### 🚚 Forwarder Portal
- Receive and manage shipment requests
- Submit competitive quotes
- Track assigned shipments
- Manage driver assignments
- Customs clearance integration

### 🛒 Buyer Interface
- Monitor incoming shipments
- View shipment details and documents
- Track delivery status
- Receive notifications and updates

### 🚗 Driver Mobile App
- Accept/reject job offers with countdown timer
- Real-time GPS tracking
- Navigation assistance
- Job status updates
- Earnings tracking
- Document management

### 🤖 AI Features
- **Route Optimization**: Finds shortest and eco-friendly paths
- **Document Extraction**: Automatic data extraction from invoices, bills of lading, etc.
- **Rate Prediction**: AI-powered freight rate forecasting
- **Delay Prediction**: Customs clearance delay prediction

---

## 🏗️ Architecture

### System Architecture Diagram

```mermaid
graph TB
    subgraph "Mobile Applications"
        A[TrackEye AI<br/>Primary App<br/>Flutter]
        B[Driver App<br/>Flutter]
    end
    
    subgraph "Backend Services"
        C[Flask REST API<br/>Python]
        D[MongoDB Atlas<br/>Database]
        E[Supabase Storage<br/>File Storage]
    end
    
    subgraph "AI Services"
        F[Google Gemini AI<br/>Document Processing]
        G[Route Optimization<br/>ML Engine]
    end
    
    subgraph "External Integrations"
        H[Carrier APIs]
        I[Customs APIs]
        J[GPS Services]
    end
    
    A -->|HTTPS/REST| C
    B -->|HTTPS/REST| C
    C -->|CRUD Operations| D
    C -->|File Upload/Download| E
    C -->|AI Requests| F
    C -->|Route Calculation| G
    C -->|Integration| H
    C -->|Integration| I
    B -->|Location Data| J
    
    style A fill:#1E3A8A,color:#fff
    style B fill:#22C55E,color:#fff
    style C fill:#000000,color:#fff
    style D fill:#47A248,color:#fff
    style E fill:#3ECF8E,color:#fff
    style F fill:#4285F4,color:#fff
    style G fill:#FF6B35,color:#fff
```

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    TrackEye AI Ecosystem                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   Supplier   │    │  Forwarder   │    │    Buyer     │  │
│  │   Mobile App │    │   Mobile App │    │  Mobile App  │  │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘  │
│         │                    │                    │          │
│         └────────────────────┼────────────────────┘          │
│                              │                               │
│                    ┌─────────▼─────────┐                     │
│                    │   Flask Backend   │                     │
│                    │   REST API Layer  │                     │
│                    └─────────┬─────────┘                     │
│                              │                               │
│         ┌─────────────────────┼─────────────────────┐        │
│         │                     │                     │         │
│  ┌──────▼──────┐    ┌────────▼────────┐   ┌───────▼──────┐ │
│  │   MongoDB   │    │  Supabase       │   │  AI Services │ │
│  │   Database  │    │  Storage        │   │  (Gemini)    │ │
│  └─────────────┘    └─────────────────┘   └──────────────┘ │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │              Driver Mobile App (Flutter)                │ │
│  │         GPS Tracking • Job Management • Navigation      │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📚 Content Overview

### Frontend (Flutter Applications)

#### Primary Mobile App (`trackeyeAI/`)
- **Location**: `/home/prieyan/weeb/pec/trackeyeAI/`
- **Framework**: Flutter 3.10.1
- **Key Modules**:
  - Authentication & Authorization
  - Supplier Dashboard
  - Forwarder Dashboard
  - Buyer Dashboard
  - Shipment Management
  - Document Upload & Viewing
  - Real-time Tracking
  - Quote Management

#### Driver Mobile App (`DriverAppTrackEye/`)
- **Location**: `/home/prieyan/weeb/pec/DriverAppTrackEye/`
- **Framework**: Flutter
- **Key Features**:
  - Driver Dashboard
  - Job Acceptance System
  - Live GPS Tracking
  - Navigation Integration
  - Earnings Tracking
  - Profile Management

### Backend (Flask API)

#### API Server (`backend-express/`)
- **Location**: `/home/prieyan/weeb/pec/backend-express/`
- **Framework**: Flask 3.0.0
- **Architecture**: MVC Pattern
- **Key Modules**:
  - Authentication Controller (JWT)
  - Shipment Controller
  - Document Controller (AI Integration)
  - Quote Controller
  - Tracking Controller
  - Carrier Integration
  - Customs Integration
  - Driver Controller
  - Forwarder Controller

### Database & Storage

- **MongoDB Atlas**: Primary database for all application data
- **Supabase Storage**: Cloud storage for documents and media files

### AI Services

- **Google Gemini AI**: Document extraction and processing
- **Route Optimization Engine**: ML-based shortest path and eco-friendly route calculation

---

## 🛠️ Tech Stack

### Frontend

<table>
<tr>
<td align="center" width="150">
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/flutter/flutter-original.svg" width="48" height="48" alt="Flutter" />
<br /><strong>Flutter</strong><br />3.10.1
</td>
<td align="center" width="150">
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/dart/dart-original.svg" width="48" height="48" alt="Dart" />
<br /><strong>Dart</strong><br />3.10.1
</td>
</tr>
</table>

**Key Packages:**
- `provider` - State management
- `http` - API communication
- `file_picker` - Document selection
- `flutter_map` - Map visualization
- `geolocator` - Location services
- `geocoding` - Address conversion

### Backend

<table>
<tr>
<td align="center" width="150">
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" width="48" height="48" alt="Python" />
<br /><strong>Python</strong><br />3.13
</td>
<td align="center" width="150">
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/flask/flask-original.svg" width="48" height="48" alt="Flask" />
<br /><strong>Flask</strong><br />3.0.0
</td>
</tr>
</table>

**Key Libraries:**
- `Flask-JWT-Extended` - Authentication
- `MongoEngine` - MongoDB ORM
- `google-generativeai` - AI integration
- `bcrypt` - Password hashing
- `Flask-CORS` - Cross-origin support

### Database & Storage

<table>
<tr>
<td align="center" width="150">
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original.svg" width="48" height="48" alt="MongoDB" />
<br /><strong>MongoDB</strong><br />Atlas Cloud
</td>
<td align="center" width="150">
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/supabase/supabase-original.svg" width="48" height="48" alt="Supabase" />
<br /><strong>Supabase</strong><br />Storage
</td>
</tr>
</table>

### AI & ML

<table>
<tr>
<td align="center" width="150">
<img src="https://www.gstatic.com/lamda/images/gemini_sparkle_v002_d4735304ff6292a690345.svg" width="48" height="48" alt="Google Gemini" />
<br /><strong>Google Gemini</strong><br />AI Processing
</td>
<td align="center" width="150">
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/tensorflow/tensorflow-original.svg" width="48" height="48" alt="ML" />
<br /><strong>ML Engine</strong><br />Route Optimization
</td>
</tr>
</table>

---

## 🚀 Installation & Setup

### Prerequisites

- **Flutter SDK**: Latest stable version (3.10.1+)
- **Dart SDK**: 3.10.1+
- **Python**: 3.13+
- **MongoDB Atlas**: Account and cluster
- **Supabase**: Account and project
- **Google AI**: Gemini API key
- **Android Studio** / **VS Code** with Flutter extension

### Frontend Setup (Primary App)

```bash
# Clone the repository
git clone https://github.com/PRIEYAN/TrackEye.git
cd TrackEye

# Install dependencies
flutter pub get

# Configure environment
# Update lib/core/constants.dart with your backend URL

# Run the application
flutter run
```

**Environment Configuration:**

Update `lib/core/constants.dart`:
```dart
static const String baseUrl = 'YOUR_BACKEND_URL/api';
```

### Frontend Setup (Driver App)

```bash
# Clone the repository
git clone https://github.com/PRIEYAN/DriverAppTrackEye.git
cd DriverAppTrackEye

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Backend Setup

```bash
# Clone the repository
git clone https://github.com/PRIEYAN/TrackEyeBackend.git
cd TrackEyeBackend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment variables
cp .env.example .env
# Edit .env with your credentials
```

**Required Environment Variables:**

```env
# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/
MONGODB_DB_NAME=TrackEye

# Security
SECRET_KEY=your-secret-key-here
JWT_SECRET_KEY=your-jwt-secret-key-here

# Storage
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
STORAGE_BUCKET=documents

# AI
GEMINI_API_KEY=your-gemini-api-key

# CORS (optional)
CORS_ORIGINS=*
```

**Run the Backend:**

```bash
# Development mode
python run.py

# Or using Flask CLI
flask run --host=0.0.0.0 --port=8000
```

The API will be available at `http://localhost:8000`

### Database Setup

MongoDB collections are created automatically when you first use the models. No migrations needed!

**Collections:**
- `users` - User accounts
- `shipments` - Shipment records
- `documents` - Uploaded documents
- `quotes` - Forwarder quotes
- `tracking_events` - Tracking history
- `drivers` - Driver profiles

---

## 🔗 Repository Links

### Primary Mobile Application
**GitHub**: [https://github.com/PRIEYAN/TrackEye/](https://github.com/PRIEYAN/TrackEye/)

Main Flutter application for suppliers, forwarders, and buyers.

### Driver Mobile Application
**GitHub**: [https://github.com/PRIEYAN/DriverAppTrackEye](https://github.com/PRIEYAN/DriverAppTrackEye)

Dedicated Flutter application for logistics drivers.

### Backend API Server
**GitHub**: [https://github.com/PRIEYAN/TrackEyeBackend/](https://github.com/PRIEYAN/TrackEyeBackend/)

Flask REST API backend with MongoDB and AI integration.

### AI Services Repository
**GitHub**: _To be filled_

ML models and AI services for route optimization and document processing.

---

## 📸 Screenshots

### Dashboard Views

<div align="center">

![Dashboard](https://via.placeholder.com/400x800/1E3A8A/FFFFFF?text=Dashboard+View)
*Supplier Dashboard with shipment overview*

![Shipment Creation](https://via.placeholder.com/400x800/3B82F6/FFFFFF?text=Create+Shipment)
*Create new shipment with document upload*

![Driver App](https://via.placeholder.com/400x800/22C55E/FFFFFF?text=Driver+Dashboard)
*Driver mobile app with job management*

![Tracking](https://via.placeholder.com/400x800/FF6B35/FFFFFF?text=Live+Tracking)
*Real-time shipment tracking with map*

![AI Processing](https://via.placeholder.com/400x800/4285F4/FFFFFF?text=AI+Document+Extraction)
*AI-powered document extraction interface*

</div>

> **Note**: Replace placeholder images with actual screenshots from your application.

---

## 👥 Team YONKONS

<div align="center">

### Meet the Team Behind TrackEye AI

<table>
<tr>
<td align="center">
<img src="https://via.placeholder.com/150/1E3A8A/FFFFFF?text=PR" width="120" height="120" style="border-radius:50%"/>
<br />
<strong>Poornima R</strong><br />
<em>Team Lead</em><br />
<a href="https://github.com/poornima2006188">🔗 GitHub</a> • 
<a href="https://linkedin.com/in/poornima-r">💼 LinkedIn</a>
</td>
<td align="center">
<img src="https://via.placeholder.com/150/3B82F6/FFFFFF?text=PM" width="120" height="120" style="border-radius:50%"/>
<br />
<strong>Prieyan MN</strong><br />
<em>Frontend & Backend</em><br />
<a href="https://github.com/PRIEYAN">🔗 GitHub</a> • 
<a href="https://linkedin.com/in/prieyan-mn">💼 LinkedIn</a>
</td>
</tr>
<tr>
<td align="center">
<img src="https://via.placeholder.com/150/22C55E/FFFFFF?text=RS" width="120" height="120" style="border-radius:50%"/>
<br />
<strong>Rithika Sri</strong><br />
<em>UI/UX Designer</em><br />
<a href="https://github.com/rithika-sri">🔗 GitHub</a> • 
<a href="https://linkedin.com/in/rithika-sri">💼 LinkedIn</a>
</td>
<td align="center">
<img src="https://via.placeholder.com/150/FF6B35/FFFFFF?text=MO" width="120" height="120" style="border-radius:50%"/>
<br />
<strong>Monish</strong><br />
<em>AI/ML Engineer</em><br />
<a href="https://github.com/monish">🔗 GitHub</a> • 
<a href="https://linkedin.com/in/monish">💼 LinkedIn</a>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<img src="https://via.placeholder.com/150/4285F4/FFFFFF?text=DK" width="120" height="120" style="border-radius:50%"/>
<br />
<strong>Dinesh Kumar</strong><br />
<em>Backend & Architecture</em><br />
<a href="https://github.com/dinesh-kumar">🔗 GitHub</a> • 
<a href="https://linkedin.com/in/dinesh-kumar">💼 LinkedIn</a>
</td>
</tr>
</table>

</div>

> **Note**: Update GitHub and LinkedIn links with actual profiles.

---

## 📄 License

This project is **proprietary** and confidential. All rights reserved.

**Copyright © 2025 YONKONS**

Unauthorized copying, modification, distribution, or use of this software, via any medium, is strictly prohibited without express written permission from the copyright holders.

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing cross-platform framework
- **Flask Community** - For the lightweight and flexible web framework
- **MongoDB** - For the robust NoSQL database solution
- **Supabase** - For the excellent storage infrastructure
- **Google AI** - For the powerful Gemini AI capabilities
- **Open Source Community** - For the incredible packages and tools

---

<div align="center">

## Made with 🖤 by YONKONS

**TrackEye AI** - Revolutionizing Logistics, One Shipment at a Time

[⬆ Back to Top](#-trackeye-ai)

</div>

