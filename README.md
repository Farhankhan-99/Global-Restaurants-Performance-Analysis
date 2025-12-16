# 🍽️ Global Restaurant Performance Analytics

A complete end-to-end analytics project uncovering how service availability, pricing, location, and cuisine variety impact restaurant performance across 16 countries.

---

## 📁 Dataset Fields
Restaurant ID, Restaurant Name, Country Code, City, Address, Locality, Locality Verbose, Longitude, Latitude, Cuisines, Average Cost for Two, Currency, Has Table Booking, Has Online Delivery, Is Delivering Now, Switch to Order Menu, Price Range, Aggregate Rating, Rating Color, Rating Text, Votes

---

## 🎯 Objective
Identify market patterns, service gaps, pricing dynamics, cuisine performance, and geographic opportunities to help restaurant businesses make smarter, data-driven decisions.

---

## 📌 Key Insights

### 1️ Service Adoption
- 67% restaurants offer no service (delivery/booking missing).
- Restaurants with both services score **3.6★**, far above no-service restaurants **2.4★**.

### 2️ Pricing & Quality
- Excellent-rated restaurants: **₹661 avg**
- Good-rated: **₹439 avg**

### 3️ Geography
- India: **8652 restaurants**, avg rating **2.52★**
- Global top cities: **Inner City (4.9★)**, **Quezon City (4.8★)**

### 4️ Cuisine Impact
- North Indian is the most common cuisine (936 restaurants).
- Multi-cuisine restaurants show better ratings than single-cuisine.

### 5️ Market Structure
- Cheap (Budget) category = **52%** of all restaurants.

---

## 💼 Business Questions (SQL)

### Level 1 — Fundamentals
- Top cuisines + avg ratings  
- Top cities by count/rating/votes  
- Price range distribution  
- % of delivery/booking/both  
- Votes by rating_text  

### Level 2 — Comparative
- Delivery vs non-delivery performance  
- Top-rated cities per country (window functions)  
- Cuisine variety vs rating correlation  
- Price category rating-to-cost ratio  
- High-rating premium performers  

### Level 3 — Advanced
- Top 3 restaurants per city (votes ranking)  
- Value score (rating ÷ price range)  
- High-density + high-rating cities  
- Service adoption by price segment  
- Underperforming high-volume cities  

---

## 🛠️ Tools & Workflow
- **Python:** Cleaning, EDA, feature engineering  
- **PostgreSQL:** BI queries & analysis  
- **Power BI:** Interactive dashboards  

