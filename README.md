# SalesSavvy — Backend

A production-ready RESTful backend for a full-stack e-commerce application, built with Java and Spring Boot. Designed with a clean 5-layer architecture, JWT-based authentication, role-separated access control, and a normalized 7-table MySQL schema — containerized with Docker for consistent environment setup.

**Frontend Repository:** [SalesSavvy-Frontend](https://github.com/pavanjii/SalesSavvy-Frontend)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java |
| Framework | Spring Boot |
| ORM | Hibernate ORM |
| Database | MySQL |
| Authentication | JWT (JSON Web Token) |
| Security | Spring Security |
| Data Access | JDBC, Spring Data JPA |
| Containerization | Docker |
| API Testing | Postman |

---

## Architecture

The backend is structured into 5 distinct layers, keeping business logic fully isolated from data access:

```
├── controllers      → Handles HTTP requests and routes (7 controllers)
├── services         → Business logic layer
├── repositories     → Data access layer (Spring Data JPA)
├── dtos             → Data Transfer Objects for request/response mapping
└── entities         → Hibernate ORM-mapped database entities
```

This separation means each layer has a single responsibility. Adding the Wishlist module, for example, required no changes to existing controllers.

---

## API Controllers

| Controller | Responsibility |
|---|---|
| `AuthController` | User registration, login, JWT token issuance |
| `UserController` | User profile management |
| `ProductController` | Product catalog — Admin CRUD, Customer browse |
| `CartController` | Add to cart, update quantity, remove items |
| `OrderController` | Place orders, view order history |
| `PaymentController` | Payment flow and confirmation |
| `WishlistController` | Add/remove/view wishlist items |

---

## Database Schema

Normalized 7-table MySQL schema designed to eliminate data duplication across product, cart, and order relationships:

```
users
  └── jwt_tokens       (token persistence per user session)
  └── orders
        └── order_items
  └── wishlist
  └── cart → products
                └── product_images
```

| Table | Purpose |
|---|---|
| `users` | Stores user credentials, roles (ADMIN / CUSTOMER) |
| `products` | Product catalog with pricing and stock |
| `product_images` | Multiple images per product |
| `orders` | Order header — user, status, total |
| `order_items` | Line items per order |
| `wishlist` | User-saved products |
| `jwt_tokens` | Active JWT token persistence for session control |

---

## Authentication & Security

- JWT-based stateless authentication using a custom Spring Security request filter
- Tokens are persisted in the `jwt_tokens` table and validated on every request
- Role-based access control enforced at the controller level:
  - **ADMIN** — manage products, view all orders, manage users
  - **CUSTOMER** — browse products, manage cart, place orders, manage wishlist
- All endpoints enforce authorization boundaries — no cross-role access

---

## User Roles & Workflows

### Admin
- Add, update, delete products and product images
- View and manage all customer orders
- Manage user accounts

### Customer
- Register and log in
- Browse product catalog
- Add/remove items from cart and wishlist
- Place orders and view order history
- Payment confirmation flow

---

## Getting Started

### Prerequisites

- Java 17+
- MySQL 8.0+
- Maven
- Docker (optional, for containerized setup)

### 1. Clone the Repository

```bash
git clone https://github.com/pavanjii/SalesSavvy-Backend.git
cd SalesSavvy-Backend/SalesSavvy1
```

### 2. Configure the Database

Create a MySQL database:

```sql
CREATE DATABASE salessavvy;
```

Update `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/salessavvy
spring.datasource.username=your_mysql_username
spring.datasource.password=your_mysql_password
spring.jpa.hibernate.ddl-auto=update
```

### 3. Run the Application

```bash
mvn spring-boot:run
```

The backend starts on `http://localhost:8080`

---

## Running with Docker

```bash
# Build the Docker image
docker build -t salessavvy-backend .

# Run the container
docker run -p 8080:8080 salessavvy-backend
```

---

## API Testing

All 7 controllers were tested end-to-end using Postman across 10–15 functional scenarios covering:
- User registration and login
- Product catalog browsing
- Cart and wishlist operations
- Order placement and history
- Payment confirmation flow

---

## Project Stats

- **Duration:** 8 weeks (December 2024 – January 2025)
- **Controllers:** 7
- **Database Tables:** 7
- **Core Business Workflows:** 6
- **Test Scenarios:** 10–15 functional Postman tests
- **Architecture Layers:** 5

---

## Future Scope

- Deploy to cloud (AWS / Railway / Render)
- Add Swagger/OpenAPI documentation
- Implement email notifications for order confirmation
- Add product search and filter endpoints
- Write JUnit and Mockito unit tests for service layer

---

## Author

**Pavan Kumar Nimmala**
[LinkedIn](https://linkedin.com/in/pavan-nimmala) · [GitHub](https://github.com/pavanjii)
