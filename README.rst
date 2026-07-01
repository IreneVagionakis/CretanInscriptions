Cretan Institutional Inscriptions
=================================

**Cretan Institutional Inscriptions** was created by Irene Vagionakis as
part of her PhD research project at the University of Venice Ca' Foscari
(2016-2019; supervisors: Claudia Antonetti and Gabriel Bodard).

The database, built using **EpiDoc Front-End Services (EFES)**, collects
EpiDoc editions of 600 inscriptions concerning the institutions of the
political entities of Crete from the 7th to the 1st century BC.

The application is based on EFES/Kiln and runs on a legacy Java stack
using Ant, Jetty, Solr and OpenRDF/Sesame.


Docker deployment
=================

The recommended way to run the project is Docker Compose.

Requirements
------------

* Docker Desktop or Docker Engine
* Docker Compose v2
* At least 4 GB of memory available for the container

On Docker Desktop for macOS, make sure Docker has enough memory assigned
in Docker Desktop settings. The current Compose configuration limits the
application container to 4 GB.


Quick start with Docker Compose
-------------------------------

From the project root:

.. code-block:: bash

   docker compose build --no-cache
   docker compose up -d

The application will be available at:

.. code-block:: text

   http://127.0.0.1:9999/cretaninscriptions/

To follow the logs:

.. code-block:: bash

   docker compose logs -f

To stop the application:

.. code-block:: bash

   docker compose down

To rebuild after source or configuration changes:

.. code-block:: bash

   docker compose build --no-cache
   docker compose up -d


Docker Compose configuration
----------------------------

The main runtime configuration is in ``compose.yaml``:

.. code-block:: yaml

   services:
     cretan-inscriptions:
       build:
         context: .
       image: cretan-inscriptions:local
       ports:
         - "9999:9999"
       environment:
         WEBAPP_CONTEXT_PATH: /cretaninscriptions
         JAVA_XMS: 256m
         JAVA_XMX: 2560m
         JAVA_MAX_METASPACE: 384m
       mem_limit: 4g
       restart: unless-stopped

The important variables are:

``WEBAPP_CONTEXT_PATH``
  Public context path for the webapp. The default is ``/`` if this
  variable is not set. The current deployment uses
  ``/cretaninscriptions``.

``JAVA_XMS``
  Initial Java heap size.

``JAVA_XMX``
  Maximum Java heap size. This must be lower than the container memory
  limit because Jetty, Solr, OpenRDF, thread stacks, metaspace and native
  memory also need RAM.

``JAVA_MAX_METASPACE``
  Maximum Java metaspace size.

``mem_limit``
  Docker memory limit for the container.

With the default configuration the container has a 4 GB limit and Java
uses up to 2560 MB of heap, leaving memory for non-heap usage.


Changing the context path
-------------------------

To serve the application at a different path, edit ``compose.yaml``:

.. code-block:: yaml

   environment:
     WEBAPP_CONTEXT_PATH: /my-path

Then rebuild and restart:

.. code-block:: bash

   docker compose build --no-cache
   docker compose up -d

If ``WEBAPP_CONTEXT_PATH`` is omitted, the application runs at:

.. code-block:: text

   http://127.0.0.1:9999/

When a context path is configured, static assets are generated under the
same path, for example:

.. code-block:: text

   /cretaninscriptions/assets/...


Manual Docker build and run
---------------------------

If you do not want to use Compose, build the image manually:

.. code-block:: bash

   docker build --no-cache --platform linux/amd64 -t cretan-inscriptions:local .

Run the container:

.. code-block:: bash

   docker run -d \
     --platform linux/amd64 \
     --name cretan-inscriptions \
     -p 9999:9999 \
     --memory=4g \
     -e WEBAPP_CONTEXT_PATH=/cretaninscriptions \
     -e JAVA_XMS=256m \
     -e JAVA_XMX=2560m \
     -e JAVA_MAX_METASPACE=384m \
     cretan-inscriptions:local

View logs:

.. code-block:: bash

   docker logs -f cretan-inscriptions

Stop and remove the container:

.. code-block:: bash

   docker rm -f cretan-inscriptions


macOS and Apple Silicon notes
-----------------------------

The Docker commands above use:

.. code-block:: text

   --platform linux/amd64

This is useful on Apple Silicon Macs when running legacy Java
dependencies that are safest on an amd64 Linux image. Docker Desktop will
run the container through emulation if needed.


Reverse proxy deployment
------------------------

The public deployment is available at:

.. code-block:: text

   https://ilc4clarin.ilc.cnr.it/cretaninscriptions/

In this setup the webapp runs internally on port ``9999`` and is exposed
through a reverse proxy. A typical Apache reverse proxy rule is:

.. code-block:: apache

   ProxyPreserveHost On

   RedirectMatch 301 ^/cretaninscriptions$ /cretaninscriptions/

   ProxyPass        /cretaninscriptions/ http://cretaninscriptions-cretan-inscriptions-1:9999/cretaninscriptions/
   ProxyPassReverse /cretaninscriptions/ http://cretaninscriptions-cretan-inscriptions-1:9999/cretaninscriptions/

The proxy path and ``WEBAPP_CONTEXT_PATH`` must match.


Troubleshooting
===============

Container is killed during startup
----------------------------------

If the logs show:

.. code-block:: text

   Killed sw/ant/bin/ant ...

the container probably ran out of memory. Increase Docker memory or lower
``JAVA_XMX``.

For the current 4 GB configuration, the recommended values are:

.. code-block:: yaml

   JAVA_XMS: 256m
   JAVA_XMX: 2560m
   JAVA_MAX_METASPACE: 384m
   mem_limit: 4g


``tools.jar`` warning
---------------------

The image uses ``eclipse-temurin:8-jdk-jammy`` instead of a JRE image
because the legacy Ant/Cocoon stack may require JDK components.


Broken CSS, JavaScript or images
--------------------------------

Check that:

* ``WEBAPP_CONTEXT_PATH`` is set correctly.
* The browser requests assets under the same context path, for example
  ``/cretaninscriptions/assets/...``.
* The application was rebuilt after changing the context path.


Line ending issues
------------------

If a shell script fails with an error such as:

.. code-block:: text

   /bin/sh^M: bad interpreter

the file has Windows line endings. The Dockerfile normalizes the main
shell scripts during build, and ``.gitattributes`` keeps shell scripts
with Linux line endings.


Legacy local run without Docker
===============================

For local development without Docker:

* Clone the repository.
* Enter the project directory.
* On macOS/Linux run:

  .. code-block:: bash

     ./build.sh

* On Windows run:

  .. code-block:: bat

     build.bat

The development server runs on port ``9999``. The actual URL depends on
the configured context path.


EFES and Kiln documentation
===========================

* https://github.com/EpiDoc/EFES
* https://github.com/EpiDoc/EFES/wiki/
* https://github.com/kcl-ddh/kiln/
* http://kiln.readthedocs.org/en/latest/


License
=======

EFES is licensed under the Apache 2.0 open software license and is
copyright the University of London, King's College London, and all listed
individual contributors.

The *Cretan Institutional Inscriptions* data are licensed under a
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
License:

* https://creativecommons.org/licenses/by-nc-sa/4.0/