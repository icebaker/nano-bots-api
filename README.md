# Nano Bots API

The Nano Bots API leverages [ruby-nano-bots](https://github.com/icebaker/ruby-nano-bots) to create an API, enabling you to integrate your [Nano Bots](https://github.com/icebaker/nano-bots) through web requests.

- [Public API](#public-api)
- [Running](#running)
  - [Docker](#docker)
- [API](#api)
- [Development](#Development)

## Public API

This API is available for free as a public API at: https://api.nbots.io

It is used to power the following projects:

- [Nano Bots Clinic (Live Editor)](https://clinic.nbots.io)
- [Nano Bots for Sublime Text](https://github.com/icebaker/sublime-nano-bots)
- [Nano Bots for Visual Studio Code](https://github.com/icebaker/vscode-nano-bots)

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

`POST /cartridges`
```json
{
  "cartridge": {
    "meta": {
      "symbol": "🤖",
      "name": "Nano Bot Name",
      "author": "Your Name",
      "version": "1.0.0",
      "license": "CC0-1.0",
      "description": "A helpful assistant."
    },
    "behaviors": {
      "interaction": {
        "directive": "You are a helpful assistant."
      }
    },
    "interfaces": {
      "repl": {
        "prompt": [
          { "text": "🤖" },
          { "text": "> ", "color": "blue" }
        ]
      }
    },
    "provider": {
      "name": "openai",
      "settings": {
        "model": "gpt-3.5-turbo",
        "credentials": {
          "address": "ENV/OPENAI_API_ADDRESS",
          "access-token": "ENV/OPENAI_API_ACCESS_TOKEN",
          "user-identifier": "ENV/OPENAI_API_USER_IDENTIFIER"
        }
      }
    }
  },
  "state": "-",
  "input": "hi"
}
```

`POST /cartridges`
```json
{
  "as": "repl",
  "action": "boot",
  "cartridge": "-",
  "state": "a21179b6104703af19328485101be839"
}
```

`POST /cartridges`
```json
{
  "as": "repl",
  "action": "eval",
  "cartridge": "-",
  "state": "a21179b6104703af19328485101be839"
}
```

`POST /cartridges`
```json
{
  "as": "eval",
  "action": "boot",
  "cartridge": "-",
  "state": "5677e56bbff1e8137c8eb1f60d2623ac"
}
```

`POST /cartridges`
```json
{
  "as": "eval",
  "action": "eval",
  "cartridge": "-",
  "state": "5677e56bbff1e8137c8eb1f60d2623ac"
}
```

`POST /cartridges/stream`

The same payloads that were used for `POST /cartridges`:

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
