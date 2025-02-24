# Database Replication with PostgreSQL using Docker

This repository contains a detailed guide on how to perform database replication with **PostgreSQL** using **Docker containers** and a `compose.yaml` file. The process described is based on the information provided on the following website: [Kinsta - PostgreSQL Replication](https://kinsta.com/blog/postgresql-replication/), but adapted for execution within Docker containers.

---

## **Prerequisites**
Before starting, make sure you have:
- Docker and Docker Compose installed on your system.
- A text editor such as **Visual Studio Code** with the Docker extension (optional but recommended).

---

## **Setup Process**
### **1. Start the Containers**
Run the following command in the terminal to start the containers defined in the `compose.yaml` file:
```sh
docker compose up -d
```

### **2. Configure the Master Node**
Access the master node container and create the replication user with the following commands:
```sh
docker exec -it Master psql -U admin -d test
```
Or:
```sh
docker exec -it Master bash
psql -U admin -d test
```
Execute the following SQL command to create the replication user:
```sql
CREATE USER replication REPLICATION LOGIN ENCRYPTED PASSWORD 'example_password';
```
**Note:** This step can also be performed using a graphical PostgreSQL client.

### **3. Modify Configuration Files**
To modify the PostgreSQL configuration files on the master node:
1. Access the master node container:
   ```sh
   docker exec -it Master bash
   ```
2. Navigate to the configuration directory:
   ```sh
   cd /var/lib/postgresql/data/
   ```
3. Replace the `postgresql.conf` and `pg_hba.conf` files with those provided in this repository. You can use **nano**, **vim**, or **Visual Studio Code** with the Docker extension.

**Note:** If using Visual Studio Code with the Docker extension, you can edit these files directly without manually accessing the container.

4. Apply the changes by restarting the master container:
   ```sh
   docker restart Master
   ```

### **4. Configure the Slave Node**
1. Access the slave node container:
   ```sh
   docker exec -it Slave bash
   ```
2. Delete all existing configuration files:
   ```sh
   rm -rf /var/lib/postgresql/data/*
   ```
3. Execute the following command to synchronize the slave database with the master:
   ```sh
   pg_basebackup -D /var/lib/postgresql/data \
     -h Master -p 5432 \
     -X stream -c fast \
     -U replication -W -R
   ```

---

## **Conclusion**
By following these steps, you will have successfully configured database replication in **PostgreSQL** using **Docker**. Now, any changes in the master node will automatically replicate to the slave node.

If you need to make additional adjustments or troubleshoot errors, check the configuration files and container logs with:
```sh
docker logs Master
```
or
```sh
docker logs Slave
```

That's it! Your PostgreSQL database replication using Docker containers is now up and running.


