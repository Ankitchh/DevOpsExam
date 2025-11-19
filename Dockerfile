FROM python:3.12-slim

ENV PTHONDONTWRITEBYCODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.python
ENV FLASK_ENV=production


WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd --create-home --shell /bin/bash appuser && \
    chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

VOLUME [ "/app/config", "/app/data", "/app/logs" ]

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "4"]
