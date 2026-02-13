""" Sleeps & logs endlessly. """

#! /usr/bin/env python3

import logging
import signal
import sys
import time

# Setup logging:
logging.basicConfig(
    filename='/var/log/my_app/my_app.log',
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s'
)

def handle_shutdown(signum, frame):
    logging.info("Received shutdown signal, exiting cleanly.")
    sys.exit(0)

signal.signal(signal.SIGTERM, handle_shutdown)
signal.signal(signal.SIGINT, handle_shutdown)

logging.info("Fake app started. ")

while True:
    logging.info("Fake app running... ")
    time.sleep(5)
