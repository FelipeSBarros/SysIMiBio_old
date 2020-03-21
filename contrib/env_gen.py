#!/usr/bin/env python

""""
django SECRET_KEY generator
"""

from django.utils.crypto import get_random_string

chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)'

CONFIG_STRING="""
DEBUG=True
SECRET_KEY=%s
ALLOWED_HOSTS=127.0.0.1, .localhost
#DATABASE_URL=postgres://USER:PASSWORD@HOST:PORT/NAME
#DEFAULT_FROM_EMAIL=
#EMAIL_BACKEND=django.core.mail.bakcends.smtp.EmailBackEnd
#EMAIL_HOST=
#EMAIL_PORT=
#EMAIL_USE_TLS=
#EMAIL_HOST_USER=
#EMAIL_PASSWORD=
""".strip() % get_random_string(50, chars)

# writing configuration to .env file
with open('.env', 'w') as configfile:
    configfile.write(CONFIG_STRING)
