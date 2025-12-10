FROM python:alpine
WORKDIR /app
RUN adduser -D -u 1000 python-user 
USER python-user
COPY ./index.html .
EXPOSE 8000
CMD ["python", "-m", "http.server", "8000"]