# Subscene-Downloader.au3
AutoIT script for downloading subtitles from Subscene.com

---
#### Requirements

To use this you will need:

1. [AutoIT version 3.3.14.5](https://www.autoitscript.com/autoit3/files/archive/autoit/autoit-v3.3.14.5-setup.exe)
1. [JSON UDF by Ward and Jos](https://www.autoitscript.com/forum/applications/core/interface/file/attachment.php?id=61831)
2. [autoit-winhttp](https://github.com/dragana-r/autoit-winhttp/releases/tag/1.6.4.1)
3. [WebDriver UDF by Danp2](https://github.com/Danp2/WebDriver/releases/tag/0.4.1.1)
4. [WebDriver for Chrome version 93](https://chromedriver.storage.googleapis.com/index.html?path=93.0.4577.15)
5. [Google Chrome version 93](https://www.google.com/chrome/?standalone=1)

For all the UDF and WebDriver executable, you will need to put it along with the script

The content of the directory should be look like this:

```
---\BinaryCall.au3
---\chromedriver.exe
---\Json.au3
---\Subscene-Downloader.au3
---\wd_cdp.au3
---\wd_core.au3
---\wd_helper.au3
---\WinHttp.au3
---\WinHttpConstants.au3
```

---
#### Usage

Inside the script, you can call _DoDownloadSubs with three arguments:
1. Link to the subscene specific movie page, e.g. "https://subscene.com/subtitles/the-queens-corgi"
2. File name of the movie, e.g. "The.Queen's.Corgi.2019" (optional, default is last part of the subscene's link)
3. Folder where you want to put the downloaded subtitles, e.g. "C:\Users\User1\Downloads\Video\The.Queen's.Corgi.2019" (optional, default is last part of the subscene's link within current user's download directory)

You can add or remove language to be downloaded by changing array $language on line 20.
If the subtitle in the language you specified doesn't exist, it will be skipped.

---
#### Trouble

If only one subtitle available for the language to be dowloaded, it get skipped.


