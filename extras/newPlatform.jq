# build url
(.url + $version + "/" + $filename) as $url
# assignments
| .version = $version
| .size = $filesize
| .url = $url
| .archiveFileName = $filename
| .checksum = $checksum
| .toolsDependencies = $toolsDeps
