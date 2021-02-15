FROM python:3.9-slim

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 

COPY ./app /main/app

WORKDIR /main

RUN pip install -r app/requirements.txt

EXPOSE 80

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]