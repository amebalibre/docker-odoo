FROM debian:jessie
MAINTAINER Ameba <ameba@autistici.org>

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            bzip2 \
            gettext \
            node-less \
            python-pip \
            python-gevent \
            python-support \
            python-renderpm \
            python-watchdog \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && pip install psycogreen==1.0 \
        && pip install wdb \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb
# Install Odoo
ENV ODOO_VERSION 10.0
ENV ODOO_RELEASE 20180122
RUN set -x; \
        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo '836f0fb94aee0d3771cf2188309f6079ee35f83e odoo.deb' | sha1sum -c - \
        && dpkg --force-depends -i odoo.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* odoo.deb

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
RUN chown odoo /etc/odoo && \
    chmod -R a+x /etc/odoo && \
    chown odoo /entrypoint.sh && \
    chmod a+x /entrypoint.sh

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/odoo && \
    chown -R odoo /mnt/odoo && \
    mkdir -p /var/log/odoo && \
    chown -R odoo /var/log/odoo
VOLUME ["/var/lib/odoo", "/mnt/odoo"]


ENV WDB_NO_BROWSER_AUTO_OPEN=True \
    WDB_SOCKET_SERVER=wdb \
    WDB_WEB_PORT=1984 \
    WDB_WEB_SERVER=localhost

ENV DB_HOST=db \
    DB_PORT=5432 \
    DB_USER=odoo \
    DB_PASSWORD=odoo \
    DB_NAME=odoo \
    LOGFILE=/var/log/odoo/odoo-server.log

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
