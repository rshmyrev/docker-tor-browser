# Tor Browser Docker

## Configuration

The [Tor Browser](https://www.torproject.org/) Docker container can be configured using environment variables and volumes.

### Environment Variables

- `DISPLAY`: X11 display server connection string (e.g., `unix$DISPLAY`).
- `PULSE_SERVER`: path to PulseAudio server (e.g. `unix:$XDG_RUNTIME_DIR/pulse/native`).

### Volumes

- `/tmp/.X11-unix:/tmp/.X11-unix:ro`: X11 socket for display forwarding.
- `$XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse:ro`: PulseAudio.
- `$HOME/Downloads:/Browser/Downloads`: Downloads directory.

## Usage

### Docker run

```bash
docker run -d \
  --name tor-browser \
  -e DISPLAY=unix${DISPLAY} \
  -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v ${XDG_RUNTIME_DIR}/pulse:${XDG_RUNTIME_DIR}/pulse:ro \
  -v ${HOME}/Downloads:/Browser/Downloads \
  rshmyrev/tor-browser
```

### Docker compose

```bash
docker compose up -d
```
