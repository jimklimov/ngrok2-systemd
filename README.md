# ngrok2-systemd
Yet another setup to wrap ngrok v2 with systemd and chroot jail

I am giving a shot to the ngrok.com service, and being cautious, want
to run the VPN client in a chroot jail -- who knows what unspecified
people could feed back into it, right? ;) Binary being static, this
part was rather easy. And also I want it to be a systemd service, so
other things can define dependencies on it running; for that I picked
up pieces from a number of similar projects that did not work for me
(e.g. wrapping a `ngrok` program of different version with different
CLI options).

For setup:

* place contents of this repo into `/opt/ngrok`;
* get the relevant Linux version for your platform from
  https://ngrok.com/download unpacked as a single
  `/opt/ngrok/bin/ngrok` binary program file;
* make device nodes for `/opt/ngrok/dev/*random` same as on your
  host system, e.g.:
````
# mknod -m 666 random c 1 8
# mknod -m 666 urandom c 1 9
````
* symlink the systemd unit to install it:
````
# ln -sr /opt/ngrok/ngrok.service /etc/systemd/system/multi-user.target.wants
# systemctl daemon-reload
````
* customize the `/opt/ngrok/root/.ngrok2/ngrok.yml.example` into your own
  `/opt/ngrok/root/.ngrok2/ngrok.yml` complete with services you want and
  the authorization token you get when signing up for an ngrok.com account;
* try starting the service and walk your way through error messages, if any.
* note that if you have `curl` on your system, the service unit will try to
  wait for tunnels to get established before exiting by querying the client's
  internal REST API in the loop.

There is also a `ngrok@.service` intended for multi-instance services, but
for this PoC it was not clear how well that is supported by ngrok.com and
the binaries, and also which REST API port to poll for current state - same
or individual for each copy?

If it does work, probably several services can be kept in either different
chroots, or by defining more user accounts and their homedirs in this one.

Another hint: if your service to be published does not listen on `localhost`
but rather on some other IP address, the use of `chroot` probably technically
allows you to define some other IP address to be named `localhost` in the
`/opt/ngrok/etc/hosts` file.

Good luck,
Jim Klimov
