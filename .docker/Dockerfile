FROM jekyll/jekyll:4.2.2

ENV PLANTUML_VERSION 1.2022.5
RUN apk add --no-cache graphviz wget ca-certificates ttf-dejavu fontconfig openjdk11 \
  && wget http://downloads.sourceforge.net/project/plantuml/$PLANTUML_VERSION/plantuml.$PLANTUML_VERSION.jar -O /usr/bin/plantuml.jar \ 
  && echo '#!/bin/sh' > /usr/bin/plantuml\
  && echo 'java -jar /usr/bin/plantuml.jar $*' >> /usr/bin/plantuml \
  && chmod a+rx /usr/bin/plantuml
