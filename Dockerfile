ARG DEBIAN_VERSION=slim-bullseye
ARG PYTHON_VERSION=3.11.4
FROM python:${PYTHON_VERSION}-${DEBIAN_VERSION}

RUN apt-get update && apt-get upgrade -y

#-----------------------------------------------------
# Timezone
#-----------------------------------------------------
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#-----------------------------------------------------
# Certificates and pdfsig
#-----------------------------------------------------
# Install pdfsig and certutil
# We need to pin the poppler-utils version because we depend on its output
# It will probably work with newer versions, but we need to test it
ENV POPPLER_VERSION="20.09.0-3.1+deb11u1"
ENV PACKAGES="poppler-utils=${POPPLER_VERSION} libnss3-tools"
RUN apt-get install $PACKAGES -y

COPY certificates /certificates

# Build certificate database
COPY scripts /scripts
RUN chmod ug+x /scripts/*.sh
RUN /scripts/build_certificate_database.sh

#-----------------------------------------------------
# Flask app
#-----------------------------------------------------

RUN pip install --upgrade pip
RUN pip install waitress
CMD ["waitress-serve", "--call CoreApi:create_app"]
