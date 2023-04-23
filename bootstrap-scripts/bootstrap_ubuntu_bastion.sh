#!/bin/bash +xe

until ping -c1 globalsdns.fortinet.net >/dev/null 2>&1; do :; done

sudo apt update
sudo apt install -y ubuntu-desktop
sudo apt install -y tightvncserver
sudo apt install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

sudo apt install -y expect

tee > /home/ubuntu/xstartup<<EOF
#!/bin/sh

export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
xsetroot -solid grey

vncconfig -iconic &
gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
gnome-terminal &
EOF

sudo chown ubuntu:ubuntu /home/ubuntu/xstartup
sudo chmod +x /home/ubuntu/xstartup

tee -a >> /home/ubuntu/.bashrc<<EOF
vncserver -geometry 1920x1080 :1
EOF

BASTION_PWD="1qaz@WSX"

/usr/bin/expect <<EOD
set timeout -1
spawn /bin/bash
send "su ubuntu\n"
send "vncserver :1\n"
expect "Password:"
send "$BASTION_PWD\n"
expect "Verify:"
send "$BASTION_PWD\n"
expect "Would you like to enter a view-only password (y/n)?"
send "n\n"
expect "Log file is"
send "mv  /home/ubuntu/.vnc/xstartup  /home/ubuntu/.vnc/xstartup.bak\n"
send "mv  /home/ubuntu/xstartup  /home/ubuntu/.vnc/xstartup\n"
send "vncserver -kill :1\n"
send "vncserver -geometry 1920x1080 :1\n"
expect eof
EOD










