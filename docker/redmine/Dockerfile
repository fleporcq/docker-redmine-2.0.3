FROM fleporcq/ruby:1.9.3

WORKDIR /redmine
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
