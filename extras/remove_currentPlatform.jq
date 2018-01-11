# extract platforms but leave out $version
[.packages[].platforms[] | select(.version != $version)] as $platforms
# assign
| .packages[0].platforms = $platforms
