FROM 0xpolygon/polygon-edge:latest

COPY generate_secrets.sh /usr/bin/generate_secrets.sh
COPY parse_node_id.sh /usr/bin/parse_node_id.sh

RUN apk update && apk add bash

RUN chmod +x /usr/bin/generate_secrets.sh
RUN chmod +x /usr/bin/parse_node_id.sh