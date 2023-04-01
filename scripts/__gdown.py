import sys
import gdown

DOWNLOAD_URL=sys.argv[1]
if len(sys.argv) == 2:
    gdown.download(DOWNLOAD_URL, quiet=False)
elif len(sys.argv) == 3:
    OUTPUT_DIRECTORY=sys.argv[2]
    gdown.download(DOWNLOAD_URL, OUTPUT_DIRECTORY, quiet=False)
