FROM python:2.7

ENV LANG C.UTF-8
ENV PYTHONUNBUFFERED 1
ENV PIP_REQUIRE_VIRTUALENV false

RUN pip install --no-deps argparse djangocms-installer six dj-database-url pytz tzlocal

RUN apt-get -y update && apt-get -y install git
# TODO: use the `preview` branch once djangocms-installer supports that
ADD requirements.txt /requirements.txt
RUN djangocms -r /requirements.txt -q -f -p /cms preview

RUN pip install https://github.com/divio/djangocms-admin-style/archive/develop.zip

ADD create-users /cms/create-users
RUN chmod +x /cms/create-users

EXPOSE 80

WORKDIR /cms
RUN /cms/create-users
CMD python manage.py runserver 0.0.0.0:80
