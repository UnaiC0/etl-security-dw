FROM jupyter/pyspark-notebook:python-3.11

USER root

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# Instalar librerías Python
RUN pip install --no-cache-dir \
    faker \
    matplotlib \
    pandas \
    numpy \
    sqlalchemy 

# Directorio de trabajo
WORKDIR /home/jovyan/work

