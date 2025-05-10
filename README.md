# PancakeOS

## About PancakeOS
We are not a actual OS that you can put onto a USB stick and boot since making a actual OS in Lua is quite stupid idea.

What this actually is a OS made with [LOVE](https://love2d.org/) since this was originally a Scratch project but by a different name (btw using it is a little broken cause yea it was made like 3 years ago)
MORE COMING SOON


## FAQ
- No one has asked questions but feel free to make pull requests :)

## How to setup

### Windows
1. Download [LOVE](https://love2d.org/)
```POWERSHELL
curl -L https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.exe -o love2dintaller.exe
love2dintaller.exe
```
2. Find where your LOVE installation is located usually in C:\Users\<YOUR USERNAME>\AppData\Roaming\LOVE
3. Make a shortcut with the executable love.exe putting it in desktop is recommended.
4. Clone this repository
```POWERSHELL
git clone https://github.com/pancakeOS/pancakeOS.git
```
5. Drag the repository folder into the shortcut you made.

### Linux
1. Download LOVE for your distro<br>
APT(Any Ubuntu based distro)
```BASH
sudo apt update -y
sudo apt install love -y
```
PACMAN(Arch linux)
```BASH
sudo pacman -Syy
sudo pacman -S love
```
2. Clone the repository
```BASH
git clone https://github.com/pancakeOS/pancakeOS.git
```
3. Open your terminal and cd into the cloned repository
```BASH
cd pancakeOS
```
4. Run love . and a window should open.
```BASH
love .
```

### Mac
Currently undocumented. You can help by adding instructions.
