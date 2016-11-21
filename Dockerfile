FROM sentry:8.8

EXPOSE 8080
ENV C_FORCE_ROOT "1"

RUN apt-get update && apt-get install -y supervisor libsasl2-dev libldap2-dev libssl-dev && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

RUN mkdir /var/log/supervisord/
COPY supervisord.conf /etc/supervisord.conf

COPY sentry.conf.py /etc/sentry/sentry.conf.py
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]