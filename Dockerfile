FROM python:3.9-alpine3.13
LABEL maintainer="cristian"

ENV PYTHONUNBUFFERED 1

# Copia i file dei requisiti nel container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Copia il tuo codice dell'applicazione nel container
COPY ./app /app
WORKDIR /app
# Esponi la porta 8000 se l'applicazione la utilizza
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py
RUN /py/bin/pip install --upgrade pip

# Installa i pacchetti di produzione
RUN /py/bin/pip install -r /tmp/requirements.txt
# Se stai sviluppando, installa anche i pacchetti di sviluppo
RUN if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi
# Rimuovi i file temporanei
RUN rm -rf /tmp
# Crea un utente non privilegiato per eseguire l'applicazione
RUN adduser --disabled-password --no-create-home django-user

# Aggiorna la variabile di ambiente PATH per includere l'ambiente virtuale
ENV PATH="/py/bin:$PATH"

# Imposta l'utente predefinito
USER django-user