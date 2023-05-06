# Asq - Your personal IT knowledge assistant

Asq is a command-line wrapper around the OpenAI GPT-3.5-turbo and GPT-4 APIs. While it functions largely as well as the ChatGPT web interface, Asq is designed to use various prompting techniques in the background to improve the output quality, and help ChatGPT get to the point faster.

Asq features an optional self-reflection feature that can be used to let it inspect its own source code and suggest changes, so that you can customise it any way you like. You don't even need to know much Python - Asq can tell you which parts to change if you ask.

Asq is currently stateless (i. e. won't remember anything between conversations), but support for a simple "save text to file" feature will be supported in the future (maybe).

Asq is currently preset to provide knowledge related to DevOps, Python and AWS, but it can be very easily customised with minor changes to anything you like - it can just as easily become your personal Ruby on Windows expert, or a JavaScript on ChromeOS expert.

This repository consists of the Asq source code and a Dockerfile so that you can run it in a container.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
    - [Docker Setup](#docker-setup)
    - [Building the Docker Image](#building-the-docker-image)
- [Configuration](#configuration)
    - [Setting API Key](#setting-api-key)
    - [Customizing User & Environment](#customizing-user--environment)
- [Usage](#usage)


## Configuration

Before using Asq, you must configure your API key and personalise a description of yourself and your environment.

### Setting the OpenAI API Key

You can set up your OpenAI API key either by saving it in a file called `openai_key.txt` in the current working directory, or by setting an environment variable named `OPENAI_API_KEY`. The environment variable will override the contents of `openai_key.txt' if the file is present.

### Customizing a description of yourself and your environment

To make sure that Asq can get to the point and provide details that are relevant to your OS, device type (laptop/desktop) and so on, you must provide a description like this in the third person.

Create a file called `user_description.txt` by copying the provided `user_description.txt.template`:

```
cp user_description.txt.template user_description.txt
```

And fill in any details about yourself that you'd like Asq to know. I personally chose to include some details about my OS, architecture, number of displays and other details that might help with troubleshooting your setup using Asq's help.

## Requirements
### Plain Python installation

To use Asq directly and without Docker, run `pip install -r requirements.txt`.

### Docker-based installation

Make sure you configure Asq first using the instructions above - the Dockerfile build process will bake the config into the image. Follow the [official documentation](https://docs.docker.com/get-docker/) if Docker is not yet installed on your system.

Afterwards, build the Docker image:

```sh
docker build -t asq .
```

## Usage

Now that Asq is configured, you can run it from the command line using `./asq.sh` or `docker run -it asq` (depending on how you installed it).

This will launch Asq's interface, through which you can interact with GPT-3.5/GPT-4. Exit with a Ctrl+C, a Ctrl+D, or by typing `/quit`

### Multi-line input

By default, typing some text and pressing Enter will submit the question immediately. If you want to send a multi-line message - for example, the contents of a config file, a piece of source code, or a paragraph of text - you must first enter the multi-line mode.

To do that, begin your first line with a `///` (or just type `///` on its own and press Enter). You can now type/paste as much text as you need. To finish typing in multi-line mode and submit your message, end your last line with `///` (or just type `///` on its own and press Enter). The whole block of text will then be submitted as a single message.

### /-Commands

Asq supports several /-commands to make the CLI experience more tolerable:

- `/gpt`: Switch between GPT-3.5 Turbo and GPT-4. Asq starts in GPT-3.5 Turbo mode by default, for a couple of reasons:
  - GPT-3.5 will handle most requests just as well as GPT-4, but is much cheaper and generates its responses much faster
  - GPT-4 support depends on whether you were approved for GPT-4 access from OpenAI, so GPT-3.5 is the safer bet

- `/`: Removes last message from the message log. Afterwards, press Enter to regenerate Asq's response, or type additional user input if you want to add anything before resubmitting your question. 

- `/reset`: Clears the entire message log. Do this frequently to save on API costs (this reduces token count), prevent crashing (no controlled "forgetting" will be supported before a full refactor is done), and to keep each discussion focused on one topic only

- `/source`: Show Asq what its own source code looks like. This will allow it to self-criticise and to explain its operation. This is useful if you are planning to hack on Asq to extend it for your own purposes.

- `/quit`: Exit the program

## Future plans:
- Chat history recording
- Refactor the codebase heavily, including splitting into files and moving functionality into separate libraries
- Work on a more ergonomic way to do rollbacks, including rolling back N messages and allowing user to edit what they already wrote.
- Less hacky multi-line support
- A simple web search + web scraping feature like that of Auto-GPT to allow Asq to help with technology released after the GPT cut-off date.
- More powerful message log editing. Ideally, all operations will be supported - insertion of user/assistant/system messages at an arbitrary point in the log, editing, deletion.
- More powerful history that works with the context length. This might include selecting a range of messages to be auto-summarised with GPT and replaced with the summary to keep the conversation length under the token limit.
- Translation of the user_description.txt from arbitrary format/writing style into a third-person style (using GPT) on first start-up
- Some sort of a configuration script to make the process easier.
- Switchable personas (for different programming tasks, or even non-programming ones) and customisable inline text templates (langchain-style) to get Asq to produce the kind of solutions you want.
