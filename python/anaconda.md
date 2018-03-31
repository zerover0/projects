# Anaconda

## Anaconda Installation on Linux

In your browser download the Anaconda installer for Linux, then in your terminal window type the following,

```sh
bash ~/Downloads/Anaconda3-4.0.0-Linux-x86_64.sh
```

NOTE: Replace ~/Downloads with your actual path and Anaconda3-4.0.0-Linux-x86_64.sh with your actual file name.

NOTE: Accept the default location or select a user-writable install location such as ~/anaconda.

NOTE: Install Anaconda as a user unless root privileges are required.

Follow the prompts on the installer screens, and if unsure about any setting, simply accept the defaults, as they can all be changed later.

NOTE: If you select the option to not add the Anaconda directory to your bash shell PATH environment variable, you may later add this line to the file .bashrc in your home directory: export PATH="/home/username/anaconda/bin:$PATH" Replace /home/username/anaconda with your actual path.

Finally, close and re-open your terminal window for the changes to take effect.

> Reference : [https://docs.continuum.io/anaconda/install](https://docs.continuum.io/anaconda/install)

## Updating from older Anaconda versions

You can easily update to the latest Anaconda version by updating conda, then Anaconda as follows:

```sh
conda update conda
conda update anaconda
```
