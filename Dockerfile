# USE THE UBUNTU IMAGE
FROM ubuntu:18.04


# SET THE MAINTAINER FOR EMAIL UPDATES
MAINTAINER shreyamlk96@gmail.com
USER root

# UPDATE INSTALL HANDLE
RUN apt update

# ADD THE GNUPG2 FOR UBUNTU OPERATION
RUN apt install -y gnupg2


# ==========================================================================================================

WORKDIR /tmp/postgres10

###################################
# DOCKER POSTGRES STARTS HERE     #
###################################

RUN apt-get install -y wget ca-certificates

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list.d/pgdg.list

RUN apt-get update

RUN apt-get update && apt-get install -y software-properties-common postgresql postgresql-contrib
 
# Note: The official Debian and Ubuntu images automatically ``apt-get clean``
# after each ``apt-get``

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql -U postgres -c "CREATE USER learningtasker WITH SUPERUSER PASSWORD 'm3rg3r';" &&\
    psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'm3rg3r';" &&\
    createdb -O learningtasker learningtasks

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432



###################################
# DOCKER POSTGRES SETUP ENDS HERE #
###################################

# ==========================================================================================================



#############################
# PROJECT SETUP STARTS HERE #
#############################


# SETUP YOUR USER WORK DIRECTORY HERE
WORKDIR /tmp/Database


# USER POSTGRES
USER postgres

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/10/bin/postgres", "-D", "/var/lib/postgresql/10/main", "-c", "config_file=/etc/postgresql/10/main/postgresql.conf"]

WORKDIR /home/sugaanth/
