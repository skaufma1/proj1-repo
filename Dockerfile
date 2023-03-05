ARG VERSION=latest
ARG name

FROM python:${VERSION}

WORKDIR /app

COPY /app/requirements.txt .

RUN pip install flask 

COPY /app . 

ENTRYPOINT ["python", "app.py"]
CMD [echo "$name"]
