#!/bin/bash

cd /var/source
/usr/bin/forever start -c python web_service.py
/usr/bin/forever start -c python web_service2.py
/usr/bin/forever start -c python web_service3.py
/usr/bin/forever start -c python web_service4.py