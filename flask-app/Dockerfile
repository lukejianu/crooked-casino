###########################################
# Dockerfile for a simple Python program.

# Working from Python version 3.9.
FROM python:3.9-alpine

# Setting the working directory inside the container to the code directory.
WORKDIR /code

# Adding packages/tools to our container. 
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev

# Copying the requirements.txt file from the host system to container.
COPY src/requirements.txt requirements.txt

# Installing requirements inside the container using pip.
RUN pip install -r requirements.txt

# Exposing port 4000 from the container. 
EXPOSE 4000

# Telling the container to run the flask application.
CMD ["python", "app.py"]