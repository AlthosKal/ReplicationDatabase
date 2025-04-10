# Replicación de Bases de Datos con PostgreSQL utilizando Docker

Este repositorio contiene una guía detallada para realizar una replicación de bases de datos con **PostgreSQL** utilizando **contenedores de Docker** y un archivo `compose.yaml`. El proceso descrito se basa en la información proporcionada en la siguiente página web: [Kinsta - Replicación en PostgreSQL](https://kinsta.com/es/blog/postgresql-replicacion/), pero adaptado para ejecutarse dentro de contenedores Docker.

---

## **Requisitos Previos**
Antes de comenzar, asegúrate de contar con:
- Docker y Docker Compose instalados en tu sistema.
- Un editor de texto como **Visual Studio Code** con la extensión de Docker (opcional, pero recomendado).

---

## **Proceso de Configuración**
### **1. Iniciar los Contenedores**
Ejecuta el siguiente comando en la terminal para iniciar los contenedores definidos en el archivo `compose.yaml`:
```sh
docker compose up -d
```

### **2. Configuración del Nodo Maestro**
Accede al contenedor del nodo maestro y crea el usuario de replicación con los siguientes comandos:
```sh
docker exec -it Master psql -U admin -d test
```
O también:
```sh
docker exec -it Master bash
psql -U admin -d test
```
Ejecuta el siguiente comando SQL para crear el usuario de replicación:
```sql
CREATE USER root REPLICATION LOGIN ENCRYPTED PASSWORD 'example_password';
```
**Nota:** También puedes realizar este paso desde un cliente gráfico de PostgreSQL.

### **3. Modificación de Archivos de Configuración**
Para modificar los archivos de configuración de PostgreSQL en el nodo maestro:
1. Accede al contenedor del nodo maestro:
   ```sh
   docker exec -it Master bash
   ```
2. Dirígete al directorio de configuración:
   ```sh
   cd /var/lib/postgresql/data/
   ```
3. Reemplaza los archivos `postgresql.conf` y `pg_hba.conf` con los proporcionados en este repositorio. Puedes hacerlo con **nano**, **vim**, o utilizando **Visual Studio Code** con la extensión de Docker.

**Nota:** Si usas Visual Studio Code con la extensión de Docker, puedes editar estos archivos directamente sin necesidad de acceder manualmente al contenedor.

4. Aplica los cambios reiniciando el contenedor maestro:
   ```sh
   docker restart Master
   ```

### **4. Configuración del Nodo Esclavo**
1. Accede al contenedor del nodo esclavo:
   ```sh
   docker exec -it Slave bash
   ```
2. Elimina todos los archivos de configuración existentes:
   ```sh
   rm -rf /var/lib/postgresql/data/*
   ```
3. Ejecuta el siguiente comando para sincronizar la base de datos del esclavo con la del maestro:
   ```sh
   pg_basebackup -D /var/lib/postgresql/data \
     -h Master -p 5432 \
     -X stream -c fast \
     -U replicator -W -R
   ```

---

## **Conclusión**
Siguiendo estos pasos, habrás configurado exitosamente la replicación de bases de datos en **PostgreSQL** utilizando **Docker**. Ahora, cualquier cambio en el nodo maestro se replicará automáticamente en el nodo esclavo.

Si necesitas realizar ajustes adicionales o solucionar errores, revisa los archivos de configuración y los registros del contenedor con:
```sh
docker logs Master
```
o
```sh
docker logs Slave
```

¡Listo! Tu replicación de bases de datos con PostgreSQL en contenedores Docker está funcionando correctamente.


