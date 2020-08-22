FROM alpine:3.5

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip

ADD configure1.sh /configure1.sh
RUN chmod +x /configure1.sh
CMD /configure1.sh
