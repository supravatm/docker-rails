# 🚀 Ruby on Rails App Setup (with Docker & MySQL)

This document explains how to set up, run, and manage a Ruby on Rails application inside Docker with MySQL as the database.

---

## 📦 Prerequisites

* Docker installed → [Get Docker](https://docs.docker.com/get-docker/)
* Docker Compose installed → [Install Docker Compose](https://docs.docker.com/compose/install/)
* Basic understanding of Ruby on Rails

---

## 🏗️ Project Structure

```
hello_rails/
 ├── Dockerfile
 ├── docker-compose.yml
 ├── Gemfile
 ├── Gemfile.lock
 └── (Rails app files will be generated here)
```

---

## 🐳 Docker Setup

### 1. Build the containers

```bash
docker-compose build
```

### 2. Start services

```bash
docker-compose up
```

* Rails app will run at: [http://localhost:3000](http://localhost:3000)
* MySQL runs on port `3306`

### 3. Create a new Rails app (first run only)

If `/app` is empty, Docker will auto-generate the Rails project:

```bash
rails new . -d mysql
```

---

## 🗄️ Database Setup

Inside the Rails container:

```bash
docker-compose run --rm web rails db:create db:migrate
```

---

## 🛠️ Useful Commands

### Enter Rails container shell

```bash
docker-compose exec web bash
```

### Enter MySQL container

```bash
docker-compose exec db mysql -u root -p
```

(password: `password`)

### Run Rails console

```bash
docker-compose run --rm web rails console
```

---

## 🧹 Cleanup Commands

* Stop this project only:

  ```bash
  docker-compose down
  ```

* Remove project DB (delete volumes):

  ```bash
  docker-compose down -v
  ```

* Remove all stopped containers (safe):

  ```bash
  docker container prune -f
  ```

* Remove dangling images:

  ```bash
  docker image prune -f
  ```

---

## ✅ Workflow Summary

1. `docker-compose build` → build environment
2. `docker-compose up` → start app + DB
3. `docker-compose exec web bash` → enter Rails container
4. `rails db:create db:migrate` → setup DB
5. Visit `http://localhost:3000` 🚀

---
