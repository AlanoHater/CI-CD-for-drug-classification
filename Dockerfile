# Dockerfile
FROM python:3.10-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de requerimientos y los instala
COPY requirements.txt .
COPY App/requirements.txt App/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r App/requirements.txt

# Copia el resto del código
COPY . .

# Comando para ejecutar la aplicación (será usado en el CD)
CMD ["python", "App/drug_app.py"]