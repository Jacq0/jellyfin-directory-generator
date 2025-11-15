# Jellyfin Directory Generator
A bash script to generate a symbolically linked directory structure for shows for use with Jellyfin.

## Usage
To use this script, download or copy the ```dirgen.sh``` file and ensure it can be run using ```chmod +x <filename>```.

By default the script will only link certain common video filetypes. This can be modified inside the script with the ```INCLUDE=()``` variable.

#### Flags:
```-n``` : Name of Show [REQUIRED]

```-o``` : Output Directory [REQUIRED]

```-s``` : Season Directory [OPTIONAL]

```-e``` : Extra Content Directory [OPTIONAL]

```-h``` : Help [OPTIONAL]

*If none of the optional flags are used, a blank folder with the name of the show will be generated at the output directory.*

***NOTE:** Seasons are considered chronological by the script, so every subsequent ```-s``` flag is counted as the next season.*

#### Example:
```./dirgen.sh -n <Show Name> -s <Season 1 Directory> -s <Season 2 Directory> -e <Extra Content Directory> -o <Output Directory>```

#### Folder Structure Output:
```
Output Directory/
├─ Show Name/
│  ├─ Season 1/
│  ├─ Season 2/
│  ├─ Specials/
```
File links will be contained inside their respective folders.
