# Self Hosted Postgres Server

https://www.postgresql.org/docs/

Create a `.env` file (gitignored) with your values. Optional vars: `POSTGRES_IMAGE`, `POSTGRES_CONTAINER_NAME`, `POSTGRES_DATA_DIR`, `POSTGRES_PORT`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, `TZ`. Set `POSTGRES_PASSWORD` to something secure.

start services

```bash
make start
```

stop services

```bash
make stop
```

view status

```bash
make status
```

view logs

```bash
make logs
```

**Connection:**
Connect from the host using the URL printed after `make start`, or set `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB` in the Makefile or environment before running `make start`. Data is stored in `./data/postgres/`.

**From another container on the same host:** use `host.docker.internal:5432` (Linux Docker 20.10+) or the host’s IP and port `$(POSTGRES_PORT)`.
