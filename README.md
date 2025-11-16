<table>
<tr>
<td width="256" valign="top" align="center">
  <a href="https://github.com/anonyaro/ContextokenizeX">
    <img 
      src="https://github.com/user-attachments/assets/59cb79ee-c11f-42ec-bcf9-5474e8426e24"
      width="256" height="256"
      alt="logo"
      style="display:block;"
    />
  </a>
</td>
<td valign="top" style="padding-left:20px;">
  <strong style="font-size:22px; display:block; margin-bottom:0.5em;">
    ContextokenizeX — a modern, cross-platform, lightweight context tokenizer with custom GUI.
  </strong>
  <p style="margin:0 0 1em 0;">
  </p>
  <b style="display:block; margin-bottom:0.5em;">
    About ContextokenizeX
  </b>
  <p style="margin:0;">
    ContextokenizeX allows you to work with files and sources more efficiently.<br/>
    Search the contexts fast and easy in order to find the context tokenized data.<br/>
    Upload files right into the program, set the token and subtoken to find more precise contexts.
  </p>
  <p style="margin-top:0.5em;">
    <strong>Please read the LICENSE before installing and using ContextokenizeX.</strong>
  </p>
</td>
</tr>
</table>

# Overview
https://github.com/user-attachments/assets/502e2efe-78c0-4dfd-9638-50e23423d85e

# Usage
*Context tokenized data* **is your output data or in other words found contexts**  

*Raw input data* **is the plain text where you want to search your context supports UTF-8**  

*Token* **is what you want to find in** *raw input data*  

*Subtoken* ** is the token's end point or the end point of the context you want to search**  

**If the *Token* is empty it will return the *Raw input data* because there is nothing to search for**  

**If the *Subtoken* is empty, but *Token* is not it will assume that your *Subtoken==Token***  

**e.g raw input data = bit by bit and I got a bit of data | Token = bit | Subtoken =  (empty) will return:** 

*Token: bit*

*Subtoken:*

*Entrypoints: 3*

*[1] => bit. by bit. and I got a bit of data.*

*[2] => bit. and I got a bit of data.*

*[3] => bit of data.*

*Estimated time: 4 µs*  

**The same sample above, but with specified Subtoken: . (a dot) will return:**

*Token: bit*

*Subtoken: .*

*Entrypoints: 3*

*[1] => bit.*

*[2] => bit.*

*[3] => bit of data.*

*Estimated time: 4 µs*

**If the subtoken not found in the text it will assume that your *Subtoken==Token*, but if there is/are found subtoken(s) it will return mixed *Context tokenized data*:**

*e.g: from Token to Token until it finds Subtoken (prints the context) and again until finds next Subtoken to print the context, it's not really recommended to do that since, context tokenized data might mix a lot*  

**{NOTE-1} Avoid contexting really big files or data, since it's not designed to work with huge chunks of data, instead manage your input data part by part**  

**{NOTE-2} Always try to specify the *Subtoken*, it makes it faster to search, make sure that specified *Subtoken* exists in your input data**  

**{NOTE-3} Context tokenizing data of files such as: *binary, doc/docx/pdf etc* is not supported yet due to their different data structure, but you can still paste data from there manually**

# Installation 
## Windows x64
**To install the program on Windows 10-11 (any edition) first download it from:** *[Releases](https://github.com/anonyaro/ContextokenizeX/releases) or [ContextokenizeX.AppImage Windows x64 latest release ](https://github.com/anonyaro/ContextokenizeX/releases/download/winrelx64/ContextokenizeX.rar)*  

**Unzip it go into the ContextokenizeX folder and run:** *ContextokenizeX.exe*  

**If you are having crashes and issues with executing the program (e.g Error Runtime Library .dll not found) you might also need to download and install MSVC redistributable package from:** *[latest vcredist v14 package_x64](https://aka.ms/vc14/vc_redist.x64.exe)*  

**If above suggestions didn't help:** *[contact me](https://t.me/t3plc6x)*

## Linux x86-64
**{NOTE} Released version of AppImage was built on Ubuntu 22.04 glibc>=2.35, so if you have glibc<2.35 (e.g Ubuntu 20.04) skip installation part and go to the 'Building ContextokenizeX section' since you might have dynamic linking conflicts with glibc, if not follow the steps bellow**  

**First download the AppImage from:** *[ContextokenizeX Linux x86-64 latest release](https://github.com/anonyaro/ContextokenizeX/releases/download/linrelx64/ContextokenizeX.AppImage)*  

**Make it executable with:** *```chmod +x ./ContextokenizeX.AppImage``` and run ```./ContextokenizeX.AppImage```*  

**Since the ContextokenizeX.AppImage was built on glibc 2.35 you might need required system dependencies such as:** *```libOpenGL.so.0```*  

**e.g to install opengl on Ubuntu 24.04:**  *```sudo apt install libgl1-mesa-dev``` or ```sudo apt install libgl1-mesa-dri libegl1 libglx-mesa0```*  

**In order to run ContextokenizeX you need FUSE to run '.AppImage'**  

**e.g to  install FUSE on Ubuntu 22.04 or higher:** *```sudo apt install fuse``` or ```sudo apt install libfuse2```*  

**If you can't or don't have FUSE on your platform try following steps:** *extract the appimage with:*  

*```./ContextokenizeX.AppImaage --appimage-extract``` then launch it manually ```./squashfs-root/usr/bin/ContextokenizeX```*  

**If you are having issues with launching it, try to launch with:** *```--platform xcb```* **argument**  

**e.g to launch it with X11 windowing system:** ```./ContextokenizeX.AppImage --platform xcb```* 


# [Support me | ContextokenizeX](https://www.donationalerts.com/r/xenyaro)
  <a href="https://www.donationalerts.com/r/xenyaro">
    <img 
      src="https://github.com/user-attachments/assets/c89418ad-5a77-4cca-961f-bd8613ad0466"
      width="300" height="200"
      alt="logo"
      style="display:block;"
    />
  </a>

# Building ContextokenizeX
## Windows 10-11 x64
**{NOTE} before building the project check the 'License' section!**  

**In order to build the ContextokenizeX first clone the project with:** *```git clone``` or download it directly*   

**Then check the:** *'ContextokenizeX's dependencies and used technology' **section below**   

**After installing Qt 6.5.3 and all dependencies/packages go to the source directory and follow next steps**  

**To build the ContextokenizeX make sure you have all dependencies and cmake/ninja build tool**  

**Build example given below, Qt installation directory may vary:**  

*```cmake -B release -G "Visual Studio 17 2022" ^```*  
*```    -DCMAKE_BUILD_TYPE=Release ^```*  
*```    -DCMAKE_PREFIX_PATH="C:/Qt/6.5.3/msvc2019_64/lib/cmake" ^```*  
*```    -DQT_BIN_DIR="C:/Qt/6.5.3/msvc2019_64/bin"```*  
*```cmake --build release --config Release```*  

**Go to the release directory or run it from current directory via:** *```start release/ContextokenizeX.exe```* 

## Linux x86-64 
**{NOTE} before building the project check the 'License' section!**  

**In order to build the ContextokenizeX first clone the project with:** *```git clone```* **or download it directly**  

**Then check the:** *'ContextokenizeX's dependencies and used technology'* **section below**   
 
**After installing Qt 6.5.3 and all dependencies/packages go to the source directory and follow next steps**   

**To build the ContextokenizeX make sure you have all dependencies and cmake/ninja build tool**  

**build example given below, Qt installation directory may vary:**  

*```cmake -B release \```*  
*```    -DCMAKE_BUILD_TYPE=Release \```*  
*```    -DCMAKE_PREFIX_PATH=/Qt/6.5.3/gcc_64/lib/cmake```*  
*```cmake --build release```*  

**Go to the release directory or run it from current directory via:** *```./release/ContextokenizeX```*  

**If you are having launching issues on Wayland try running the binary with:** *```--platform xcb```* **argument**

# ContextokenizeX's dependencies and used technology
**The ContextokenizeX was built on Ubuntu 22.04 glibc>=2.35**  

**Used Framework -> Qt 6.5.3 Framework**  

**Language -> C++17**  

**Used qtkits windows -> msvc2019_64 linux -> g++ (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0**  

**Used Qt6 required components: *Quick, QuickControls2, Network, Qml, Core, Gui, Widgets, Concurrent***  

**Was built using .qml  instead of QWidgets since qml provides modern rendering methology and more flexible when working with UI's**  

**QApp was used instead of QGui window due to file dialog not being properly supported in QGuiWindow**  

**Also to make OS independent GUI with custom server panel**  

**The 'UI' part was fully written in .qml with Connectons to handle various types of signals such as file reading/update section etc**  

**Build system -> cmake/ninja was used due to its flexibility and being platform independent**  

**Packaging system used on windows -> windeployqt with archiving alltogether through winrar**  

**.AppImage packaging system was used for linux -> linuxdeploy-x86_64 with linuxdeploy-plugin-qt-x86_64**  

# **Minimum Requirements** 
**<u>may vary for Linux systems, check above 'ContextokenizeX's technical dependencies or used technology' section</u>**
| Component | Requirement |
| ---------------------- | ------------------------------------------ |
| **Processor** | 1 GHz or faster, with PAE, NX, and SSE2 support |
| **RAM** | 1 GB for 32-bit / 2 GB for 64-bit |
| **Hard Drive** | 16 GB for 32-bit / 20 GB for 64-bit |
| **Video Card** | Microsoft DirectX 9 graphics device with WDDM driver |
| **OS** | Windows 10 (any edition) |

# **Recommended Requirements**
| Component | Recommended |
| ---------------------- | ------------------------------------------------------------------------------- |
| **Processor** | 4+ cores, 2.0 GHz or higher, 10th Gen Intel Core i5/i7 or AMD Ryzen 3000+ |
| **RAM** | 8–16 GB DDR4 |
| **Storage** | 128 GB SSD or higher |
| **Video Card** | DirectX 12 / WDDM 2.1+, at least 2 GB of video memory |
| **OS** | Windows 11 (any edition) |
