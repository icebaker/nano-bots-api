# Nano Bots API

The Nano Bots API leverages [ruby-nano-bots](https://github.com/icebaker/ruby-nano-bots) to create an API, enabling you to integrate your [Nano Bots](https://github.com/icebaker/nano-bots) through web requests.

- [Running](#running)
  - [Docker](#docker)
- [API](#api)
- [Development](#Development)

## Running

Requirements:
```bash
build-essential libffi-dev lua5.4-dev
```

Copy the `.env.example` file to `.env` and fill in the necessary data and run the server:

```sh
bundle
./init.sh
```

### Docker

```sh
git clone git@github.com:icebaker/nano-bots-api.git
cd nano-bots-api
./build.sh
cp docker-compose.example.yml docker-compose.yml # Provide your credentials.
docker-compose up -d
# http://localhost:3048
```

## API

| Verb | Path                   | Description                                    |
|------|------------------------|------------------------------------------------|
| GET  | /                      | Get the version.                               |
| GET  | /cartridges            | Get all available cartridges.                  |
| POST | /cartridges/source     | Show the source code of a cartridge.           |
| POST | /cartridges            | Evaluate the input.                            |
| POST | /cartridges/stream     | Create a stream to be pooled for a evaluation. |
| GET  | /cartridges/stream/:id | Get the current stream of a cartridge.         |


### Payloads

`POST /cartridges/source`
```json
{
  "id": "-"
}
```

`POST /cartridges`
```json
{
  "cartridge": "-",
  "state": "-",
  "input": "hi"
}
```

`POST /cartridges/stream`
```json
{
  "cartridge": "-",
  "state": "-",
  "input": "hi"
}
```

## Development

Once you've installed the dependencies with `bundle`, run Rubocop with the `-A` flag for automatic fixes.

```sh
rubocop -A
```
