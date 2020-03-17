# Minecraft scripts

This is a collection of scripts to manage minecraft

## Installation

Make sure to have [rconc](https://github.com/klemens/rconc), `tar`, `lzop` and preferably [supervisord](http://supervisord.org/) installed.

Next edit the `mc-settings.sh` to fit your personal environment.
Make sure to **enable** RCON in your `server.properties` of Minecraft:

```properties
enable-rcon=true
rcon.password=supah_seekrit
rcon.port=25575
```

Before you can use the commands, you also have to configure `rconc` with your settings.

```shell
$ # replace the variables as needed.
$ # you must specify a port, a simple localhost is not enough
$ rconc server add $RCONC_NAME localhost:$RCON_POST $RCON_PASSWORD
```

## Usage

To launch Minecraft, just run `mc-supervisor`, preferably in `supervisord`.
But you can execute it in any runner (or manually) as you desire.

The `mc` script can be used to perform some management tasks

```shell
$ # create a backup
$ ./mc backup
$ # clear items on the ground
$ # this will delete item entities and thus *may* reduce lag
$ ./mc clearitems
```
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
