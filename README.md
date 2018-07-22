# Splashr - unsplash image getter

Script that will download 15 images from unsplash collection.  
This is a help script so we can automatically change background-image on desktop / login screen and i3lock.   
The downloaded images will be converted to PNG so i3lock will work.  
New images only be downloaded if tempfolders modified date is older then 2 days

## Requirements
1. imagemagick ( to convert jpeg to png for i3lock)
2. feh

Folder structure
```bash
~/.splashr
├── bg     - JPEG images
├── i3lock - Converted to PNG
└── temp   - Download Folder
```
# Get started

For lightdm or other loginmanager   
Create folder and file
```bash
sudo mkdir /usr/share/images/login/
sudo chown username:username /usr/share/images/login/
touch /usr/share/images/login/login.jpeg
```
Set `/usr/share/images/login/login.jpeg` as background-image in config for your loginmanger.

Make script executable
```bash
chmod +x splashr.sh
```
Run script
```bash
~/path/to/splashr/splashr.sh
```
# How to rotate images

### Desktop

i3config, set random background image when session starts. `~/config/i3/config`
```bash
exec --no-startup-id feh --bg-scale $(find $HOME/.splashr/bg -name "*.jpeg" | shuf -n1)
```

Create a cronjob to run `splashr.sh`. Background image will be change eachtime script runs. ( Every hour )
```bash
0 * * * *  /path/to/splashr/splashr.sh
```

### i3lock
```bash
bindsym $mod+l exec i3lock -i $(find $HOME/.splashr/i3lock -name "*.png" | shuf -n1)
```

### For lightdm or other loginmanager
`/usr/share/images/login/login.jpeg` will be updated if modified date is older then 1 day.



